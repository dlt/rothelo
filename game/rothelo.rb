$debug = true
module Rothelo
	class Game
    attr_accessor :last_play
		attr_reader   :board, :current_player, :gui, :altered_fields
	
		def initialize(gui = nil)
    	@board 					= Board.new
			@current_player = 1
			@altered_fields = []
			@gui 						= gui
		end

		def process(button)
			play           = [button.x, button.y, current_player]
      self.last_play = play

			if valid? play
				apply_changes current_player
				update_current_player
			else
				discard_changes
			end
		end

		def valid?(play)
      x, y, player = play
			validate_horizontals(x, y, player) or
      validate_verticals(x, y, player) or
		  validate_diagonals(x, y, player)
		end

		private
		def validate_verticals(x, y, player)
			return false unless board.empty?(x, y)
			other  = get_other_player player
			offset = 1
      valid  = false

      changed x, y if last_play?(x, y, player)
			while board[x, y - offset] == other && (y - offset) > 0
        changed x, y - offset
				if board[x, y - (offset + 1)] == player
          changed x, y - (offset + 1)
					valid = true
				end
				offset +=1
			end 
      
      offset = 1
			while board[x, y + offset] == other && (y + offset) < 7
        changed x, y + offset
				if board[x, y + offset + 1] == player
          changed x, y + offset + 1
					valid = true	
				end
				offset += 1
			end
      valid
		end

		def validate_horizontals(x, y, player)
			return false unless board.empty?(x, y)
			other  = get_other_player player
      valid  = false
			offset = 1

      changed x, y if last_play?(x, y, player)
			while board[x - offset, y] == other && (x - offset) > 0
        changed x - offset, y
				if board[x - (offset + 1), y] == player
          changed x - (offset + 1), y
          valid = true
        end
				offset += 1 
			end 
			
			offset = 1
			while board[x + offset, y] == other && (x + offset) < 7
        changed x + offset, y
				if board[x + offset + 1, y] == player
          changed x + offset + 1, y
          valid = true
        end
				offset += 1
			end
			valid
		end

		def validate_diagonals(x, y, player)
			return false unless board.empty?(x, y)
			other  = get_other_player player
			offset = 1
			
			while board[x - offset, y - offset] == other && (x - offset) > 0 && (y - offset) > 0
				return true if board[x - (offset + 1), y - (offset + 1)] == player
				offset += 1 
			end 

			offset = 1
			while board[x - offset, y + offset] == other && (x - offset) > 0 && (y + offset) < 7
				return true if board[x - (offset + 1), y + offset + 1] == player
				offset += 1 
			end 

			offset = 1
			while board[x + offset, y - offset] == other && (x + offset) < 7 && (y - offset) > 0
				return true if board[x + offset + 1, y - (offset + 1)] == player
				offset += 1 
			end 

			offset = 1
			while board[x + offset, y + offset] == other && (x + offset) < 7 && (y  + offset) < 7
				return true if board[x + offset + 1, y + offset + 1] == player
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
	
    def changed x, y
      altered_fields << [y, x] unless altered_fields.include? [y, x]
    end

		def apply_changes player
			altered_fields.each do |y, x|
				board[x, y] = player
			end
      discard_changes
			gui.refresh if gui
		end

		def update_current_player
			@current_player = 3 - @current_player
		end

    def last_play? x, y, player
      [x, y, player] == last_play
    end
	end
end
