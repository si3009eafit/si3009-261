# programa generado por chatgpt y organizado y optimizado por el profesor
# debe ser adaptado por el estudiante para sus propias necesidades
import argparse
import random
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from typing import List, Tuple

import psycopg


@dataclass
class Metrics:
    latencies_s: List[float]  # latencias por transacción en segundos
    errors: int


def percentile(sorted_vals: List[float], p: float) -> float:
    """p en [0, 100]. sorted_vals debe estar ordenada."""
    if not sorted_vals:
        return float("nan")
    k = (p / 100.0) * (len(sorted_vals) - 1)
    f = int(k)
    c = min(f + 1, len(sorted_vals) - 1)
    if f == c:
        return sorted_vals[f]
    return sorted_vals[f] + (sorted_vals[c] - sorted_vals[f]) * (k - f)


def do_transaction(conn, order_id: int, n_customers: int, n_products: int, n_items: int = 4) -> None:
    """
    1) Insert orders
    2) Insert n_items en order_item
    3) Insert payment
    4) Select dashboard (últimas órdenes del cliente)
    Todo en una transacción.
    """
    customer_id = random.randint(1, n_customers)
    total_amount = round(random.random() * 800 + 10, 2)

    with conn.cursor() as cur:
        # 1) Order
        cur.execute(
            """
            INSERT INTO orders(order_id, customer_id, order_date, status, total_amount)
            VALUES (%s, %s, now(), %s, %s)
            """,
            (order_id, customer_id, "PAID", total_amount),
        )

        # 2) Items
        for k in range(n_items):
            order_item_id = order_id * 10 + k
            product_id = random.randint(1, n_products)
            qty = random.randint(1, 4)
            unit_price = round(random.random() * 400 + 5, 2)
            cur.execute(
                """
                INSERT INTO order_item(order_item_id, order_id, product_id, quantity, unit_price)
                VALUES (%s, %s, %s, %s, %s)
                """,
                (order_item_id, order_id, product_id, qty, unit_price),
            )

        # 3) Payment
        cur.execute(
            """
            INSERT INTO payment(payment_id, order_id, payment_date, payment_method, payment_status)
            VALUES (%s, %s, now(), %s, %s)
            """,
            (order_id, order_id, "CARD", "APPROVED"),
        )

        # 4) Dashboard read
        cur.execute(
            """
            SELECT order_id, order_date, status, total_amount
            FROM orders
            WHERE customer_id = %s
            ORDER BY order_date DESC
            LIMIT 20
            """,
            (customer_id,),
        )
        cur.fetchall()


def worker(
    dsn: str,
    duration_s: int,
    warmup_s: int,
    order_id_base: int,
    n_customers: int,
    n_products: int,
    n_items: int,
) -> Metrics:
    latencies: List[float] = []
    errors = 0

    # Una conexión por worker (lo normal para TPS testing)
    with psycopg.connect(dsn, autocommit=False) as conn:
        # Warmup
        t_warm_start = time.perf_counter()
        while (time.perf_counter() - t_warm_start) < warmup_s:
            try:
                oid = order_id_base + random.randint(1, 10_000_000)
                t0 = time.perf_counter()
                do_transaction(conn, oid, n_customers, n_products, n_items)
                conn.commit()
                _ = time.perf_counter() - t0
            except Exception:
                conn.rollback()
                errors += 1

        # Run
        t_start = time.perf_counter()
        while (time.perf_counter() - t_start) < duration_s:
            try:
                oid = order_id_base + random.randint(1, 10_000_000)
                t0 = time.perf_counter()
                do_transaction(conn, oid, n_customers, n_products, n_items)
                conn.commit()
                latencies.append(time.perf_counter() - t0)
            except Exception as e:
                conn.rollback()
                errors += 1

    return Metrics(latencies_s=latencies, errors=errors)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", required=True)
    ap.add_argument("--port", type=int, default=5432)
    ap.add_argument("--db", required=True)
    ap.add_argument("--user", required=True)
    ap.add_argument("--password", required=True)
    ap.add_argument("--sslmode", default="prefer")  # para RDS: require
    ap.add_argument("--concurrency", type=int, default=4)
    ap.add_argument("--duration", type=int, default=60, help="segundos de medición")
    ap.add_argument("--warmup", type=int, default=10, help="segundos de calentamiento (no se reporta)")
    ap.add_argument("--customers", type=int, default=200_000)
    ap.add_argument("--products", type=int, default=20_000)
    ap.add_argument("--items", type=int, default=4)
    ap.add_argument("--order_id_base", type=int, default=900_000_000)
    args = ap.parse_args()

    dsn = (
        f"host={args.host} port={args.port} dbname={args.db} "
        f"user={args.user} password={args.password} sslmode={args.sslmode}"
    )

    t_global_start = time.perf_counter()
    futures = []

    with ThreadPoolExecutor(max_workers=args.concurrency) as ex:
        for w in range(args.concurrency):
            futures.append(
                ex.submit(
                    worker,
                    dsn,
                    args.duration,
                    args.warmup,
                    args.order_id_base + w * 50_000_000,
                    args.customers,
                    args.products,
                    args.items,
                )
            )

        all_lat = []
        total_errors = 0
        for fu in as_completed(futures):
            m = fu.result()
            all_lat.extend(m.latencies_s)
            total_errors += m.errors

    elapsed = time.perf_counter() - t_global_start

    all_lat.sort()
    ops = len(all_lat)
    tps = ops / args.duration if args.duration > 0 else float("nan")

    mean = sum(all_lat) / ops if ops else float("nan")
    p50 = percentile(all_lat, 50) if ops else float("nan")
    p95 = percentile(all_lat, 95) if ops else float("nan")
    p99 = percentile(all_lat, 99) if ops else float("nan")

    print("\n=== RESULTADOS ===")
    print(f"Concurrencia: {args.concurrency}")
    print(f"Warmup: {args.warmup}s | Medición: {args.duration}s")
    print(f"Transacciones exitosas: {ops}")
    print(f"Errores: {total_errors}")
    print(f"TPS (aprox): {tps:.2f}")

    print("\nLatencias por transacción:")
    print(f"  mean: {mean*1000:.2f} ms")
    print(f"  p50 : {p50*1000:.2f} ms")
    print(f"  p95 : {p95*1000:.2f} ms")
    print(f"  p99 : {p99*1000:.2f} ms")

    # Nota: elapsed incluye warmup+overhead; TPS calculado sobre ventana de medición (duration)
    print(f"\nTiempo total (incluye warmup): {elapsed:.2f}s")


if __name__ == "__main__":
    main()

