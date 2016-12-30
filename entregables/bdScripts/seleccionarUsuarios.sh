#!/bin/sh
sql_host="localhost"
slq_usuario="root"
sql_password="password"
sql_database="usuarios"
sql_args="-h $sql_host -u $slq_usuario -p$sql_password -D $sql_database -s -e"
mysql $sql_args "insert into usuario(nombreUsuario,nombreContenedor) values('usuarioN','contenedorN');"