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

        score = ab.last
        x, y, player = ab.first
        return x, y
      end

      def play!
        x, y, p = next_play
        @game.process MockButton.new(x, y)
      end

      def evaluate_state(game)
        me, enemy = 0, 0
        other     = 3 - game.current_player

        game.board.each_field do |x, y, player|
          if player == game.current_player 
            me    += 1
          elsif player == other
            enemy += 1
          end
        end

        me - enemy
      end

      private
      def alphabeta
        g = Game.new
        g.board = game.board
        g.current_player = game.current_player
        max(g, -Infinity, Infinity, nil, nil, 5)
      end

      def max(game, alpha, beta, x, y, depth) 
        return [[x, y, game.current_player], evaluate_state(game)] if game.over? or depth.zero?

        game.successors do |x, y, child|
          alpha = [alpha, min(game, alpha, beta, x, y, depth - 1).last].max
          return [[x, y, child.current_player], beta] if alpha >= beta
        end

        [[x, y, game.current_player], alpha]
      end

      def min(game, alpha, beta, x, y, depth) 
        return [[x, y, game.current_player], evaluate_state(game)] if game.over? or depth.zero?

        game.successors do |x, y, child|
          beta = [beta, max(child, alpha, beta, x, y, depth - 1).last].min
          return [[x, y, child.current_player], alpha] if beta <= alpha
        end

        [[x, y, game.current_player], beta]
      end

    end
  end
end

