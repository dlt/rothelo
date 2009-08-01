module Rothelo
	class Game
		attr_reader :board, :current_player, :gui, :altered_fields
	
		def initialize(gui = nil)
    	@board 					= Board.new
			@current_player = 1
			@altered_fields = []
			@gui 						= gui
		end

		def process(button)
			play = [button.x, button.y, current_player]
			if valid? play
				apply_changes current_player
				update_current_player
			else
				discard_changes
			end
		end

		def valid?(play)
			validate_horizontals(play) or
			validate_verticals(play) or
		  validate_diagonals(play)
		end

		private
		def validate_horizontals(play)
			x, y, player = play

			return false unless board.empty?(x, y)
			other  = get_other_player player
			offset = 1

			altered_fields << [x, y]
			while board[x][y - offset] == other && (y - offset) > 0
				altered_fields << [x, y - offset]
				if board[x][y - (offset + 1)] == player
					altered_fields << [x, y - (offset + 1)]
					return true
				end
				offset += 1 
			end 

			offset = 1
			while board[x][y + offset] == other && (y + offset) < 7
				altered_fields << [x, y + offset]
				if board[x][y + offset + 1] == player
					altered_fields << [x, y + (offset + 1)]
					return true	
				end
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
		
		def discard_changes
			@altered_fields = []
		end
		
		def apply_changes player
			altered_fields.uniq.each do |x, y|
				board[x, y] = player
			end
			gui.refresh if gui
		end

		def update_current_player
			@current_player = 3 - @current_player
		end
	end
end
