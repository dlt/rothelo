require 'pp'
require '../game/rothelo'
require '../game/board'

describe(Rothelo) do
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

end
