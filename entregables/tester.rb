#!/usr/bin/ruby
require 'json'
require 'rubygems'
require 'base64'
require 'io/console'
require 'socket'

#Control del modelo vista control, donde el control hace procesamiento de 

class Control

 attr_accessor :secuencial, :puertoInicial, :puertoSiguiente, :usuarioID


def initialize()
	@secuencial=1;
	@puertoInicial=4999;
	@puertoSiguiente=5000;
	@usuarioID=1;
	puts 'Se ha iniciado el controlador del servidor,IPServidor:'+local_ip
end

def darIP()
	return 'Se ha iniciado el controlador del servidor,IPServidor:'+local_ip
end

#REGISTRAR USUARIO-CONTENEDOR
def registrarUsuario(usuario)
	@usuarioN=usuario
	@nombreContenedor="domjudge"+@secuencial.to_s
	system("sudo docker run -it -d --name "+@nombreContenedor.to_s+" -p "+@puertoSiguiente.to_s+":80 debian_domjudge &")
	@dirIP=local_ip()
	@respuesta="Se le ha asociado el domjudge:"+@nombreContenedor.to_s+", con direccion IP:"+@dirIP.to_s+", por el puerto:"+@puertoSiguiente.to_s+"\n"
	puts @respuesta.to_s
	@secuencial=@secuencial+1
	@puertoSiguiente=@puertoSiguiente+1
	#registrar en la base de datos el usuario y el domjudge name en la base de datos de Mysql.
	almacenarUsuario(@usuarioN,@nombreContenedor)
	return @respuesta
end

#ALMACENAR USUARIO-CONTENEDOR EN BD MySQL
def almacenarUsuario(usuario,nombreContenedor)
	@usuarioN=usuario
	@nombreContenedorN=nombreContenedor
	@sql_host="localhost"
	@slq_usuario="root"
	@sql_password="password"
	@sql_database="usuarios"
	@sql_args="-h"+ @sql_host.to_s+" -u"+ @slq_usuario.to_s+" -p"+@sql_password.to_s+" -D"+ @sql_database.to_s+" -s -e"
 	system("mysql @sql_args insert into usuario(nombreUsuario,nombreContenedor) values('"+@usuarioN.to_s+"','"+@nombreContenedorN.to_s+"');")
end

#http://stackoverflow.com/questions/5029427/ruby-get-local-ip-nix
def local_ip()
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end

#ELIMINAR USUARIO-CONTENEDOR
def deleteUsuario(usuario,nombreContenedor)
	@usuarioN=usuario
	@nombreContenedorN=nombreContenedor
        system("sudo docker stop "+@nombreContenedorN)
	system("sudo docker rm "+@nombreContenedorN)
	@sql_host="localhost"
	@slq_usuario="root"
	@sql_password="password"
	@sql_database="usuarios"
	@sql_args="-h"+ @sql_host.to_s+" -u"+ @slq_usuario.to_s+" -p"+@sql_password.to_s+" -D"+ @sql_database.to_s+" -s -e"
 	system("mysql @sql_args delete from usuario where nombreUsuario ='"+@usuarioN.to_s+"';")
	return "El contenedor:"+@nombreContenedorN.to_s+ " del usuario:"+@usuarioN.to_s+"fue eliminado exitosamente." +"\n"		
end

#LISTAR USUARIOS-CONTENEDORES
def listarUsuarios()
	@sql_host="localhost"
	@slq_usuario="root"
	@sql_password="password"
	@sql_database="usuarios"
	@sql_args="-h"+ @sql_host.to_s+" -u"+ @slq_usuario.to_s+" -p"+@sql_password.to_s+" -D"+ @sql_database.to_s+" -s -e"
	@comando="select* from usuario;"
	@respuestaConsulta=IO.popen("mysql "+@sql_args+" "+@comando)	
	@respuesta=@respuestaConsulta.to_s
	return @respuesta
end



end

