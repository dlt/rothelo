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
    	@board[x][y] = z
  	end
  
  	def [](x = nil, y = nil)
			raise ArgumentError, 'Should inform either x or y' unless x || y			
			if y.nil?
				return @board[x]
			end
			if x.nil?
				y_axis = (0..7).collect {|x| @board[x][y]}
				return y_axis
			end
    	@board[x][y]
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

