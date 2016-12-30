require 'sinatra'
require 'json'
require 'rubygems'
require 'base64'
require 'json'
require 'io/console'
require './tester.rb'

usuarioID=1
#10

get '/' do 
    @control=Control.new	
    'Aplicacion con docker de forma distribuida.'	
    @mensajeMostrar=@control.darIP()
    erb :interfaz	   
end


#-------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------#

#REGISTRO DE USUARIOS
post '/registrarse' do 
    @control=Control.new
    @usuario="usuario"+usuarioID.to_s	
    @respuesta=@control.registrarUsuario(@usuario)
    @usuarioID=usuarioID+1;
    @mensajeMostrar=@respuesta
    erb :interfaz	
end
#32
#-------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------#

#ELIMINAR USUARIO
post '/eliminarUsuario' do
	@control=Control.new
	system("curl -i -X POST -d '{\"nombre\":\"domjudge1\"}' http://"+@control.local_ip().to_s+":4567/deleteUsuario") 
end
#42
post '/deleteUsuario' do 
	@control=Control.new
	data=JSON.parse request.body.read
	@nombreContenedor=data["nombreContenedor"]
	@nombreUsuario = "usuario"+nombreContenedor.sub("domjudge", "").to_i
	@usuario=@nombreUsuario.to_s
	@respuesta=@control.deleteUsuario(@usuario,@nombreContenedor)
    	@mensajeMostrar=@respuesta.to_s
        erb :interfaz
end
#53
#-------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------#

#LISTAR USUARIOS
post '/listarUsuarios' do 
	@control=Control.new
	@respuesta=@control.listarUsuarios()	
	@mensajeMostrar=@respuesta.to_s
        erb :interfaz	
end
#-------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------#

