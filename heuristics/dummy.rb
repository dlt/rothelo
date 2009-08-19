module Rothelo
  module Heuristics
    MockButton = Struct.new :x, :y

    class Dummy
      attr_reader :game
      def initialize(game)
        @game = game
      end

      def next_play
        game.board.each_field do |x, y, player|
          play = [x, y, game.current_player]
          return play if game.valid?(play)
        end
      end

      def change_game_board
        x, y = next_play
        bt = MockButton.new(x, y)
        game.process bt
        return x, y
      end
    end
  end
end
