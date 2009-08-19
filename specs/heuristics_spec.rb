require 'pp'
require File.dirname(__FILE__) + '/../heuristics/heuristics'
require File.dirname(__FILE__) + '/../game/rothelo'

describe(Rothelo::Heuristics) do

  describe(Rothelo::Heuristics::Dummy) do
    before(:all) do
      @game = Rothelo::Game.new
      @dummy = Rothelo::Heuristics::Dummy.new @game 
    end

    it 'should find a new valid next play' do

      play = @dummy.next_play
      @game.valid?(play).should be_true
    end

    it 'should change the board after a play' do
      x, y = @dummy.change_game_board
      @game.board.empty?(x, y).should be_false
    end
  end

end



