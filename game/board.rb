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
  
  def [](x,y)
    @board[x][y]
  end

  def each_field
	 	for x in 0..7
  		for y in 0..7
				yield self[x, y], x, y
      end
    end
  end 
end

