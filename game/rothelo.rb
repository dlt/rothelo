require File.dirname(__FILE__) + '/../game/board'
require File.dirname(__FILE__) + '/../heuristics/heuristics'

module Rothelo
	class Game
		attr_accessor :last_play, :board, :current_player
		attr_reader   :gui, :altered_fields, :options
	
		def initialize(gui = nil, options = nil)
			@board 					= Board.new
			@options        = options || {}
			@current_player = @options[:first] || 1
			@altered_fields = []
			@gui 						= gui
		end

		def init
			init_ia if has_ia_player?
		end

		def pre_processing
			discard_changes
		end

		def post_processing
			discard_changes
			unless over? 
				@ia.play! if ia_player?(current_player)
			end
		end

		def process button
			pre_processing
			play           = button.x, button.y, current_player
			self.last_play = play
		
			if valid?(play)
				apply_changes current_player
				update_current_player
			end

			post_processing
		end

		def valid? play
			x, y, player = play

			horizontals  = validate_horizontals(x, y, player)
			diagonals    = validate_diagonals(x, y, player)
			verticals    = validate_verticals(x, y, player) 
			diagonals or horizontals or verticals
		end

		def ia_player?(player)
			options[player] and options[player][:intelligence] != :Human
		end

		def heuristic(player)
			options[player][:intelligence]
		end

		def over?
			board.each_field do |x, y, player|
				return false if valid?([x, y, current_player])
			end
			true
		end
		
		def has_ia_player?
			options.values.each do |val|
				return true if val.is_a?(Hash) and val[:intelligence] and val[:intelligence] != :Human
			end
			false
		end

		def successors
			ss = []
			g = Game.new
			g.board = board.copy
			g.current_player = current_player

			board.each_field do |x, y, p|
				ply = [x, y, current_player]
				ss << ply if g.valid? ply
			end

			#shuffle to avoid playing always in one 'side' of the board
			ss.shuffle.each do |ply|
				x, y, p = ply
				g.process  Heuristics::MockButton.new(x, y)
				yield(x, y, g)
			end
		end

		private
		def validate_verticals(x, y, player)
			return false unless board.empty?(x, y)
			other  = get_other_player player
			offset = 1
			valid  = false

			changed(x, y) if last_play?(x, y, player)
			sandboxed do |stack|
				apply = false
				while (y - offset) > 0 && board[x, y - offset] == other 
					stack.push [x, y - offset]
					if board[x, y - (offset + 1)] == player
						stack.push [x, y - (offset + 1)]
						valid = true
						apply = true
					end
					offset += 1
				end
				apply
			end
				
			offset = 1
			sandboxed do |stack|
				apply = false
				while  (y + offset) < 7 && board[x, y + offset] == other 
					stack.push [x, y + offset]
					if board[x, y + offset + 1] == player
						stack.push [x, y + offset + 1]
						valid = true	
						apply = true
					end
					offset += 1
				end
				apply
			end

			valid
		end

		def validate_horizontals(x, y, player)
			return false unless board.empty?(x, y)
			other  = get_other_player player
			valid  = false
			offset = 1

			changed(x, y) if last_play?(x, y, player)

			sandboxed do |stack|
				while (x - offset) > 0 && board[x - offset, y] == other 
					apply = false
					stack.push [x - offset, y]
					if board[x - (offset + 1), y] == player
						stack.push [x - (offset + 1), y]
						valid = true
						apply = true
					end
					offset += 1 
				end 
				apply
			end

			offset = 1
			sandboxed do |stack|
				apply = false
				while (x + offset) < 7 && board[x + offset, y] == other 
					stack.push [x + offset, y]
					if board[x + offset + 1, y] == player
						stack.push [x + offset + 1, y]
						valid = true
						apply = true
					end
					offset += 1
				end
				apply
			end

			valid
		end

		def validate_diagonals(x, y, player)
			return false unless board.empty?(x, y)
			other  = get_other_player player
			valid  = false
			offset = 1
			
			changed(x, y) if last_play?(x, y, player)
			sandboxed do |stack|
				apply = false
				while (x - offset) > 0 && (y - offset) > 0 && board[x - offset, y - offset] == other 
					stack.push [x - offset, y - offset]
					if board[x - (offset + 1), y - (offset + 1)] == player
						stack.push [x - (offset + 1), y - (offset + 1)]
						valid = true
						apply = true
					end
					offset += 1 
				end 
				apply
			end

			offset = 1
			sandboxed do |stack|
				apply = false
				while (x - offset) > 0 && (y + offset) < 7 && board[x - offset, y + offset] == other 
					stack.push [x - offset, y + offset]
					if board[x - (offset + 1), y + offset + 1] == player
						stack.push [x - (offset + 1), y + offset + 1]
						valid = true
						apply = true
					end
					offset += 1 
				end 
				apply
			end

			offset = 1
			sandboxed do |stack|
				apply = false
				while (x + offset) < 7 && (y - offset) > 0 && board[x + offset, y - offset] == other 
					stack.push [x + offset, y - offset]
					if board[x + offset + 1, y - (offset + 1)] == player
						stack.push [x + offset + 1, y - (offset + 1)]
						valid = true
						apply = true
					end
					offset += 1 
				end 
				apply
			end

			offset = 1
			sandboxed do |stack|
				apply = false
				while (x + offset) < 7 && (y  + offset) < 7 && board[x + offset, y + offset] == other 
					stack.push [x + offset, y + offset]
					if board[x + offset + 1, y + offset + 1] == player
						stack.push [x + offset + 1, y + offset + 1]
						valid = true
						apply = true
					end
					offset += 1 
				end 
				apply
			end

			valid
		end

		def get_other_player p
			return 1 if p == 2
			return 2 if p == 1
			raise ArgumentError, "Invalid player #{p}. Player number must be 1 or 2"
		end
		
		def discard_changes
			@altered_fields.clear
		end
	
		def changed x, y
			altered_fields << [y, x] unless altered_fields.include? [y, x]
		end

		def apply_changes player
			altered_fields.each do |y, x|
				board[x, y] = player
			end
			gui.refresh and puts 'refreshing gui' if gui
			discard_changes
		end

		def update_current_player
			@current_player = 3 - @current_player
		end

		def last_play? x, y, player
			[x, y, player] == last_play
		end

		def sandboxed
			stack = []
			apply = yield(stack)
			stack.each {|x, y| changed(x, y)} if apply
		end

		def init_ia
			@ia = iafactory
			if ia_player? current_player
				@ia.play!
			end
		end

		def iafactory
			Heuristics::AlphaBetaPruning.new self
			#Heuristics::Dummy.new self
		end
	end
end
