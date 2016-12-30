require 'sinatra'
require 'json'
require 'rubygems'
require 'base64'
require 'json'
require 'io/console'

secuencial=1;
puertoInicial=5000;
usuarioID=1;

#-------------------------------------------------------------------------------------------------#
#REGISTRO DE USUARIOS
#curl -i -X GET http://127.0.0.1:4567/registrarse
get '/registrarse' do 
    usuario="usuario"+usuarioID.to_s	
    respuestaRegistro=registrarusuario(usuario)
    usuarioID=usuarioID+1;
    @mensajeMostrar=respuestaRegistro.to_s
    erb :interfaz	
    return respuestaRegistro.to_s	
end

#Registra el usuario creando el contenedor y asociándoselo.
def registrarUsuario(usuario)
	nombreContenedor="domjudge"+secuencial.to_s;
	system("sudo docker run -it -d --name "+nombreContenedor.to_s+" -p "+puertoInicial.to_s+":80 distribuidos/DOMJudge")
	respuesta="Se le ha asociado el domjudge"+secuencial.to_s+", con dirección IP 127.0.0.1, por el puerto:"+puertoInicial.to_s+"\n"
	secuencial=secuencial+1;
	puertoInicial=puertoInicial+1;
	#registrar en la base de datos el usuario y el domjudge name en la base de datos de Mysql.
	almacenarUsuario(usuario,nombreContenedor)
	return respuesta;
end

#Almacena un usuario en la base de datos con su contenedor.
def almacenarUsuario(usuario,nombreContenedor)
	system("sudo mysql -u root -p password")
	system("insert into usuarios values("+usuario.to_s+","+nombreContenedor.to_s)
	system("exit")		
end

#-------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------#

#ELIMINAR USUARIO
#curl -i -X POST -d '{"nombreContenedor":"domjudge1"}' http://127.0.0.1:4567/eliminarUsuario
post '/eliminarUsuario' do 
	data=JSON.parse request.body.read
	nombreContenedor=data["nombreContenedor"]
	nombreUsuario = "usuario"+nombreContenedor.sub("domjudge", "").to_i
	usuario=nombreUsuario
	delete(usuario)
    	system("sudo docker stop "+nombreContenedor)
	system("sudo docker rm "+nombreContenedor)
	respuesta="Su contenedor "+nombreContenedor+ " fue eliminado" +"\n"
	@mensajeMostrar=respuesta.to_s
        erb :interfaz
	return respuesta
end

def deleteUsuario(usuario)
	system("sudo mysql -u root -p password")
	system("delete from usuarios where usuario ="+"\'"+usuario.to_s+"\'")
	system("exit")		
end

#-------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------#

#LISTAR USUARIOS
#curl -i -X GET http://127.0.0.1:4567/listarUsuarios
get '/listarUsuarios' do 
	respuesta=listarUsuarios()	
	return respuesta
end

def listarUsuarios()
	system("sudo mysql -u root -p password")
	comando="select* from usuarios"
	respuestaConsulta=IO.popen(comando)	
	system("exit")		
	respuesta=respuestaConsulta.to_s
	@mensajeMostrar=respuesta.to_s
        erb :interfaz	
	return respuesta
end
#-------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------#

