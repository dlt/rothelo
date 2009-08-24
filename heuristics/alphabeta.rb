require 'pp'
module Rothelo
  module Heuristics
    class AlphaBetaPruning
      Infinity = 1.0 / 0

      attr_reader :game

      def initialize(game)
        @game   = game
      end

      def next_play
        ab = alphabeta
        x, y = ab.first
        return x, y
      end

      def play!
        x, y = next_play
        @game.process MockButton.new(x, y)
        return x, y
      end

      def evaluate_state(game)
        me, enemy = 0, 0
        other     = 3 - game.current_player

        game.board.each_field do |x, y, player|
          if player == game.current_player 
            me += 5
            me += 0.5 if x.zero?
            me += 0.5 if y.zero?
            me += 1.5 if x.zero? and y.zero?
            me -= 2 if x == 1 or x == 6
            me -= 2 if y == 1 or y == 6
          elsif player == other
            enemy += 5
            enemy += 0.5 if x.zero?
            enemy += 0.5 if y.zero?
            enemy += 1.5 if x.zero? and y.zero?
            enemy -= 2 if x == 1 or x == 6
            enemy -= 2 if y == 1 or y == 6
          end
        end
        me - enemy
      end

      private
      def alphabeta
        g = Game.new
        g.board = game.board
        g.current_player = game.current_player
        max(g, -Infinity, Infinity, nil, nil, 4)
      end

      def max(game, alpha, beta, x, y, depth) 
        return [[x, y], evaluate_state(game)] if game.over? or depth.zero?

        game.successors do |x, y, child|
          alpha = [alpha, min(game, alpha, beta, x, y, depth - 1).last].max
          return [[x, y], beta] if alpha >= beta
        end

        [[x, y], alpha]
      end

      def min(game, alpha, beta, x, y, depth) 
        return [[x, y], evaluate_state(game)] if game.over? or depth.zero?

        game.successors do |x, y, child|
          beta = [beta, max(child, alpha, beta, x, y, depth - 1).last].min
          return [[x, y], alpha] if beta <= alpha
        end

        [[x, y], beta]
      end
    end
  end
end

