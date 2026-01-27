# si3009 BDA - 2026-1

## crear una máquina EC2 en AWS Academy, con ubuntu 24.04

    - tipo t2.large con 40 GB DD
    - asignarle una IP flotante para que la VM tenga siempre la misma IP pública
    - abrir los puertos 5050 y 5432 desde diferentes subredes privadas, Internet, etc

## instalar docker sobre ubuntu 24.04: https://docs.docker.com/engine/install/ubuntu/

## agregar el usuario ubuntu como ejecutante de docker:

    sudo usermod -a -G docker ubuntu 

## clonar el repositorio en la EC2:

    git clone https://github.com/si3009eafit/si3009-261.git

## lanzar postgres, pgadmin, etc

    cd si3009-261/pg-lab1
    docker compose up -d

## establezca un tunel entre su máquina laptop y la EC2:

    ssh -i "file.pem" ubuntu@ip-publica -L 5050:<ip-privada-ec2>:5050

## abra un navegador y contectese a:

    http://localhost:5050

    con usuario: user@acme.com y clave: adminpass

## en pgAdmin, adiciones un nuevo servidor de BD:

    nombre conexión: pg-lab1
    ip: <ip-privada-ec2>
    port: 5432
    db name: labdb
    db user: labuser
    db pass: labpass

## puede continuar a ejecutar scripts sql o directamente sentencias sql en el editor sql de pgAdmin.

