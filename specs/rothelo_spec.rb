require 'pp'
require File.dirname(__FILE__) + '/../game/rothelo'
require File.dirname(__FILE__) + '/../game/board'

describe(Rothelo) do
	Button = Struct.new :x, :y	
	before do
		@game = Rothelo::Game.new
	end

	it 'should validate a play in a horizontal line' do
		play = [0, 0, 1]
		@game.valid?(play).should be_false

		play = [3, 5, 1]
		@game.valid?(play).should be_true

		@game.board[3, 5] = 2
		play = [3, 6, 1]
		@game.valid?(play).should be_true
	end

	it 'should validate a play in a vertical line' do
		play = [2, 3, 2]
		@game.valid?(play).should be_true	

		play = [5, 3, 1]
		@game.valid?(play).should be_true	

		play = [5, 4, 2]
		@game.valid?(play).should be_true	

		play = [3, 5, 1]
		@game.valid?(play).should be_true	
	end


	it 'should validate a play in all diagonals' do
		@game.board[3, 4].should == 2
		@game.board[3, 4] = 1
		play = [2, 5, 2]
		@game.valid?(play).should be_true

		@game = Rothelo::Game.new
		@game.board[3, 3].should == 1
		@game.board[3, 3] = 2

		play = [2, 2, 1]
		@game.valid?(play).should be_true

		@game = Rothelo::Game.new
		@game.board[4, 3].should == 2
		@game.board[4, 3] = 1

		play = [5, 2, 2]
		@game.valid?(play).should be_true

		@game = Rothelo::Game.new
		@game.board[4, 4].should == 1
		@game.board[4, 4] = 2

		play = [5, 5, 1]
		@game.valid?(play).should be_true
	end

	it 'should apply changes after a valid play' do
		@game.board[4, 2].should be_zero
		@game.valid?([4, 2, 1]).should be_true
		button = Button.new 4, 2
		@game.process button	
		@game.board[4, 2].should == 1	
		@game.board[4, 4].should == 1	
		@game.board[4, 3].should == 1	
	end

  it 'should discard changes made during a invalid row check' do
		@game.board[4, 2].should be_zero
		@game.valid?([4, 2, 1]).should be_true
		button = Button.new 4, 2
		@game.process button	
		@game.board[4, 2].should == 1	
		@game.board[4, 4].should == 1	
		@game.board[4, 3].should == 1	

    @game.current_player.should == 2
    button2 = Button.new 3, 2
    @game.board[3, 2].should be_zero
    @game.has_ia_player?.should be_false
    @game.valid?([3, 2, 2]).should be_true
    @game.process button2
    @game.board[3, 2].should == 2
    @game.board[4, 2].should == 1
    @game.board[4, 3].should == 1
  end

  it 'should have options settings for an artificial intelligent player' do
    @ia_game = Rothelo::Game.new(nil, :player1 => {:intelligence => :human}, :player2 => {:intelligence => :Dummy})
  end

  it 'should apply ia options' do
    @ia_game = Rothelo::Game.new(nil, 1 => {:intelligence => :Human}, 2 => {:intelligence => :Dummy})
    @ia_game.ia_player?(1).should be_false
    @ia_game.ia_player?(2).should be_true
    @ia_game.heuristic(2).should == :Dummy
    @ia_game.heuristic(1).should == :Human


    @ia_game = Rothelo::Game.new(nil, 1 => {:intelligence => :AlphaBetaPruning}, 2 => {:intelligence => :Dummy}, :first => 1)
    @ia_game.ia_player?(1).should be_true
    @ia_game.ia_player?(2).should be_true
    @ia_game.heuristic(1).should == :AlphaBetaPruning
    @ia_game.heuristic(2).should == :Dummy
  end

  it 'should set first players based in options' do
    @ia_game = Rothelo::Game.new
    @ia_game.current_player.should == 1

    @ia_game = Rothelo::Game.new(nil, 1 => {:intelligence => :Human}, 2 => {:intelligence => :Dummy}, :first => 1)
    @ia_game.current_player.should == 1

    @ia_game = Rothelo::Game.new(nil, 2 => {:intelligence => :Human}, 1 => {:intelligence => :Dummy}, :first => 2)
    @ia_game.current_player.should == 2
  end

  it 'it should play on #initialize if first player is a robot' do
    @ia_game = Rothelo::Game.new(nil, 1 => {:intelligence => :Dummy}, 2 => {:intelligence => :Human}, :first => 1)
    @ia_game.init
    @ia_game.board.empty_fields.should == 59
  end

  it 'should have a #over? method that says if game is in a terminal state' do
    @game.over?.should be_false
    @ia_game = Rothelo::Game.new(nil, 1 => {:intelligence => :Dummy}, 2 => {:intelligence => :Dummy})
    @ia_game.init
    @ia_game.over?.should be_true
  end

end
