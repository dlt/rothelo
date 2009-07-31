class Rothelo
	attr_reader :board

	def initialize
    @board = Board.new
		puts 'inicializado'
	end

	def process(button)
		x, y, player = button.x, button.y, button.player
	end

end

