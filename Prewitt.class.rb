require 'matrix'

class Prewitt

    private 

    def initialize(filename)
        @src_filename = filename
		@src_image = read_src_image
        @dst_image = Marshal.load(Marshal.dump(@src_image))
		@image_h = @src_image.size
        @image_w = @src_image[0].size
        @prewittGx = Matrix[[-1,0,1],[-1,0,1],[-1,0,1]]
		@prewittGy = Matrix[[1,1,1],[0,0,0],[-1,-1,-1]]
	end
    
    #=========================	
	def calculateGx(pixels)
        gx=0
		(@prewittGx * Matrix.build(3,3){|r,c| pixels[r][c]}).each{|val| gx+=val}
        gx
	end
	
    #=========================
	def calculateGy(pixels)
		gy = 0
        (@prewittGy * Matrix.build(3,3){|r,c| pixels[r][c]}).each{|val| gy+=val}
        gy
	end
	
    #=========================
	def calculateGradient(x,y)
        target_matrix = [[0,0,0],[0,0,0],[0,0,0]]
        
        target_matrix[0][0] = @src_image[((y-1)<0)?0:(y-1)][((x-1)<0)?0:(x-1)]
        target_matrix[0][1] = @src_image[((y-1)<0)?0:(y-1)][x]
        target_matrix[0][2] = @src_image[((y-1)<0)?0:(y-1)][((x+1)>=@image_w)?0:(x+1)]
        target_matrix[1][0] = @src_image[y][((x-1)<0)?0:(x-1)]
        target_matrix[1][1] = @src_image[y][x]
        target_matrix[1][2] = @src_image[y][((x+1)>=@image_w)?0:(x+1)]
        target_matrix[2][0] = @src_image[((y+1)>=@image_h)?0:(y+1)][((x-1)<0)?0:(x-1)]
        target_matrix[2][1] = @src_image[((y+1)>=@image_h)?0:(y+1)][x]
        target_matrix[2][2] = @src_image[((y+1)>=@image_h)?0:(y+1)][((x+1)>=@image_w)?0:(x+1)]

        Math.sqrt((calculateGx(target_matrix)**2)+(calculateGy(target_matrix)**2))
	end
	
    #=========================
	# El formato de una imagen PGM http://netpbm.sourceforge.net/doc/pgm.html
	def read_src_image
		@src_image = nil
        w = h = 0
		if (File.exists?(@src_filename))
			nline = 0
			f = File.open(@src_filename).each do |line|
				if (nline == 2)
					w,h = line.split(' ')
                    w = w.to_i
                    h = h.to_i
                    @src_image = Array.new(h){Array.new(w) {0}}
				end
				if (nline > 3)
                    @src_image[(nline-4)/w][(nline-4)%w] = line.to_i
				end
				nline += 1
			end
            f.close
		end
        @src_image
	end
	
    #=========================
	def save_dst_image
		dstfilename = "prewitt-#{@src_filename}"
		f = File.open(dstfilename,"w")
        # Guardamos la cabecera de una imagen PGM
        f.puts("P2")
        f.puts("# Felipe Molina (@felmoltor)")
        f.puts("#{@image_w} #{@image_h}")
        f.puts("255")
        # Guardamos la matriz completa con saltos de línea
        f.puts @dst_image.join("\n")
        f.close

        return dstfilename
	end
	
	#=========================
	public

    def filter_image
        # Calculamos el gradiente de cada pixel de la imagen
		@image_h.times {|y|
            @image_w.times {|x|
                gradient = calculateGradient(x,y)
                # puts "Gradient #{y},#{x}: #{gradient}" #if gradient > 9
                # Guardamos el gradiente en la matriz destino
                @dst_image[y][x] = gradient.to_i
            }
        }
        # Guardamos en un fichero el resultado
        save_dst_image
	end
end
