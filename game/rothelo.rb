module Rothelo
	class Game
		attr_reader :board, :current_player
	
		def initialize
    	@board 					= Board.new
			@current_player = 1
		end

		def process(button, gui)
			play = [button.x, button.y, current_player]
			puts valid? play
			update_current_player
			board[0, 0] = 1
			gui.refresh
		end

		def valid?(play)
			validate_horizontals(play) or
			validate_verticals(play) or
			validate_diagonals(play)
		end

		def update_current_player
			@current_player = 3 - @current_player
		end

		private
		def validate_horizontals(play)
			x, y, player = play

			return false unless board.empty?(x, y)
			other  = get_other_player player
			offset = 1

			while board[x][y - offset] == other && (y - offset) > 0
				return true if board[x][y - (offset + 1)] == player
				offset += 1 
			end 

			offset = 1
			while board[x][y + offset] == other && (y + offset) < 7
				return true if board[x][y + offset + 1] == player
				offset +=1
			end
			false
		end

		def validate_verticals(play)
			x, y, player = play

			return false unless board.empty?(x, y)
			other  = get_other_player player
			offset = 1

			while board[x - offset][y] == other && (x - offset) > 0
				return true if board[x - (offset + 1)][y] == player
				offset += 1 
			end 
			
			offset = 1
			while board[x + offset][y] == other && (x + offset) < 7
				return true if board[x + offset + 1][y] == player
				offset += 1
			end
			false
		end

		def validate_diagonals(play)
			x, y, player = play

			return false unless board.empty?(x, y)
			other  = get_other_player player
			offset = 1
			
			while board[x - offset][y - offset] == other && (x - offset) > 0 && (y - offset) > 0
				return true if board[x - (offset + 1)][y - (offset + 1)] == player
				offset += 1 
			end 

			offset = 1
			while board[x - offset][y + offset] == other && (x - offset) > 0 && (y + offset) < 7
				return true if board[x - (offset + 1)][y + offset + 1] == player
				offset += 1 
			end 

			offset = 1
			while board[x + offset][y - offset] == other && (x + offset) < 7 && (y - offset) > 0
				return true if board[x + offset + 1][y - (offset + 1)] == player
				offset += 1 
			end 

			offset = 1
			while board[x + offset][y + offset] == other && (x + offset) < 7 && (y  + offset) < 7
				return true if board[x + offset + 1][y + offset + 1] == player
				offset += 1 
			end 
			false
		end

		def get_other_player p
			return 1 if p == 2
			return 2 if p == 1
			raise ArgumentError, "Invalid player #{p}. Player number must be 1 or 2"
		end
	end
end
