require File.dirname(__FILE__) + '/../game/board'

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
    @board[0].should      == [0] * 8
    @board[7].should      == [0] * 8
    @board[nil, 0].should == [0] * 8
    @board[nil, 7].should == [0] * 8
    @board[0, 0].should   == 0
    @board[7, 7].should   == 0
    @board[nil, 0].should == [0] * 8
    @board[4].should      == [0, 0, 0, 2, 1, 0, 0, 0]
    @board[nil, 4].should == [0, 0, 0, 2, 1, 0, 0, 0]
    @board[3].should      == [0, 0, 0, 1, 2, 0, 0, 0]
    @board[nil, 3].should == [0, 0, 0, 1, 2, 0, 0, 0]
  end

  it 'should return coordinates for given piece type' do
    @board.coordinates(1).should == [[3, 3], [4, 4]]
    @board.coordinates(2).should == [[3, 4], [4, 3]]
  end

  it 'should inform if a field is empty' do
    @board.empty?(0, 0).should be_true
    @board.empty?(4, 4).should be_false
  end

  it '#copy should return a board copy' do
    copy = @board.copy
    for x in 0..7
      copy[x].object_id.should_not == @board[x].object_id
      for y in 0..7
        copy[x, y].should == @board[x, y]
      end
    end
  end

  it 'changing a board copy should not change the original one' do
    copy = @board.copy
    copy[0, 0].should be_zero
    @board[0, 0].should be_zero
    copy[0, 0] = 1
    copy[0, 0].should == 1
    @board[0, 0].should_not == 1
  end

  it '#empty_fields should return the number of empty fields' do
    @board.empty_fields.should == 60
    @board[1,1] = 1
    @board.empty_fields.should == 59
  end

  it 'should have an equality method' do
    @b1 = Rothelo::Board.new
    @b2 = Rothelo::Board.new

    (@b1 == @b2).should be_true
    (@b1 == @b1.copy).should be_true
    @b2[0, 0] = 1

    (@b1 == @b2).should be_false
  end


end
