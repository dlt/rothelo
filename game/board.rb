module Rothelo
	class Board
	  def initialize
  	  @board = Array.new(8)
    	@board.map! {|row| row = Array.new 8}
    
	    for x in 0..7
  	    for y in 0..7
    	    @board[x][y] = 0
      	end
	    end
 		  @board[4][4] = 1
    	@board[3][3] = 1
    	@board[3][4] = 2
    	@board[4][3] = 2        
  	end
  
  	def []=(x,y,z)
    	@board[y][x] = z
  	end
  
  	def [](x = nil, y = nil)
			raise ArgumentError, 'Should inform either x or y' unless x || y			
			if x.nil?
				return @board[y]
			end
			if y.nil?
				x_axis = (0..7).collect {|yy| @board[yy][x]}
				return x_axis
			end
    	@board[y][x]
  	end

  	def each_field
	 		for x in 0..7
  			for y in 0..7
					yield x, y, self[x, y]
     	 end
    	end
		end 

		def coordinates(piece)
			coords = []
			self.each_field do |x, y, f|
				coords << [x, y] if f == piece
			end
			coords
		end

		def to_s
			@board.inspect	
		end

		def empty?(x, y)
			self[x, y].zero?
		end

	end
end

