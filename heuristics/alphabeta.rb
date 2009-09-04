require 'pp'
require File.dirname(__FILE__) + '/../ext/alphabeta_optimizations'
module Rothelo
  module Heuristics
    class AlphaBetaPruning
      Infinity = 1.0 / 0

      attr_reader :game

      def initialize(game)
        @game = game
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
        score_unit = 0.5

        game.board.each_field do |x, y, player|
          if player == game.current_player 
            me += 10 * score_unit
            me += score_unit if x.zero? or y.zero?
            me += 3 * score_unit if x.zero? and y.zero?
            me -= 4 * score_unit if x == 1 or y == 1
            me -= 4 * score_unit if x == 6 or y == 6

          elsif player == other
            enemy += 10 * score_unit
            enemy += score_unit if x.zero? or y.zero?
            enemy += 3 * score_unit if x.zero? and y.zero?
            enemy -= 4 * score_unit if x == 1 or y == 1
            enemy -= 4 * score_unit if x == 6 or y == 6
          end
        end
        me - enemy
      end

      private
      def alphabeta
        g = Game.new
        g.board = game.board
        g.current_player = game.current_player
        max(g, -Infinity, Infinity, nil, nil, 7)
      end

      def max(game, alpha, beta, x, y, depth) 
        return [[x, y], evaluate_game_opt(game)] if game.over? or depth.zero?

        game.successors do |x, y, child|
          alpha = [alpha, min(game, alpha, beta, x, y, depth - 1).last].max
          return [[x, y], beta] if alpha >= beta
        end

        [[x, y], alpha]
      end

      def min(game, alpha, beta, x, y, depth) 
        return [[x, y], evaluate_game_opt(game)] if game.over? or depth.zero?

        game.successors do |x, y, child|
          beta = [beta, max(child, alpha, beta, x, y, depth - 1).last].min
          return [[x, y], alpha] if beta <= alpha
        end

        [[x, y], beta]
      end
    end
  end
end

