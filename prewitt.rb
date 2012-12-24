#!/usr/bin/ruby

# Autor: Felipe Molina (https://twitter.com/felmoltor)
#
# ===============================
# El programa lee imagenes PGM (http://www.math.umbc.edu/~rouben/2003-09-math625/images.html)
# Y detecta los borde con el filtro prewitt.
#
# Puedes crear la tuya propia con el Gimp->Guardar como...->Imagen PGM->Exportar->ASCII
# ===============================

require './Prewitt.class.rb'

########
# MAIN #
########

if (!ARGV[0].nil?)
	prewitt = Prewitt.new(ARGV[0].to_str)
	resultfilename = prewitt.filter_image
	puts "El resultado se ha guardado en #{resultfilename}"
else
	puts "Error. Indica el nombre del fichero con la imagen PGM"
	exit
end


