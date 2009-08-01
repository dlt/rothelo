require '../game/board'

describe(Rothelo::Board) do
	before do
		@board = Rothelo::Board.new
	end

	it 'should have a valid initial othelo state when initialized' do
		@board.each_field {|x, y, f| f.should == 0 unless [3, 4].include?(x) || [3, 4].include?(y)}
		@board[4, 4].should == 1
		@board[4, 3].should == 2
		@board[3, 4].should == 2
		@board[3, 3].should == 1
	end

	it 'should have a [] method for easy field accessing' do
		lambda {@board[]}.should raise_error ArgumentError
		@board[0].should 			== [0] * 8
		@board[7].should 			== [0] * 8
		@board[nil, 0].should == [0] * 8
		@board[nil, 7].should == [0] * 8
		@board[0, 0].should 	== 0
		@board[7, 7].should 	== 0
		@board[nil, 0].should == [0] * 8
		@board[4].should 			== [0, 0, 0, 2, 1, 0, 0, 0]
		@board[nil, 4].should == [0, 0, 0, 2, 1, 0, 0, 0]
		@board[3].should 			== [0, 0, 0, 1, 2, 0, 0, 0]
		@board[nil, 3].should == [0, 0, 0, 1, 2, 0, 0, 0]
	end

	it 'should return coordinates for given piece type' do
		@board.coordinates(1).should == [[3, 3], [4, 4]]
		@board.coordinates(2).should == [[3, 4], [4, 3]]
	end

	it 'should inform if a field is empty' do
		@board.empty?(0, 0).should be_true
	end

	
end
