require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  	# Si se quita esta línea: Routing Error: No route matches [GET] "/auth/spotify"
  	# scope son los permisos que entrega el usuario
  	provider :spotify, CLIENT_ID, CLIENT_SECRET,
  				scope: 'user-read-email playlist-modify-public user-library-read user-library-modify'
end