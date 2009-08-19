module Rothelo
  module Heuristics
    class AlphaBetaPruning
      attr_reader :game

      def initialize(game)
        @game = game
      end

      def next_play
        oldboard = game.board
        copy     = oldboard.copy
        

      end

      def play!
      end

      private
      def alphabeta(board, depth, alpha = Infinity, beta = -Infinity)
      end

      def all_valid_plays
        valid = []
        game.board.each_field do |x, y, player|
          play = [x, y, game.current_player]
          valid << play if game.valid?(play)
        end
        valid
      end

      def evaluate_state(board)
      end

    end
  end
end

