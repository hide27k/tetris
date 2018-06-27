
require 'minitest/autorun'
require_relative './provided'
require_relative './customize'

class TestMyTetris < Minitest::Test

  # This function checks if the piece rotate 180 degrees both when
  # call rotate_180 (push 'u' key) and rotate 90 degrees 2 times
  # (call rotate_clock/rotate_clockwise 2 times)
  def test_u_key
    @new_board = TestMyBoard.new
    @piece = MyPiece.next_piece(@new_board)
    @new_board.rotate_180
    @rotate_by_u = @piece.current_rotation
    @new_board.rotate_counter_clockwise
    @new_board.rotate_counter_clockwise
    @new_board.rotate_clockwise
    @new_board.rotate_clockwise
    @new_board.rotate_counter_clockwise
    @new_board.rotate_counter_clockwise
    @new_board.rotate_clockwise
    @new_board.rotate_clockwise
    @rotate_90 = @piece.current_rotation
    assert_equal(@rotate_by_u, @rotate_90)
  end

  # This function checks if the program generate All 10 classic pieces.
  # However, it might be fail because the pieces are generated randomly.
  def test_10_piece
    @new_board = TestMyBoard.new
    @piece = MyPiece.next_piece(@new_board)
    # class array holding all the pieces and their rotations
    test_classic_pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
                 MyPiece.rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
                 [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
                 [[0, 0], [0, -1], [0, 1], [0, 2]]],
                 MyPiece.rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
                 MyPiece.rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
                 MyPiece.rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
                 MyPiece.rotations([[0, 0], [1, 0], [0, -1], [-1, -1]])] # Z

    # class array holding all the new pieces to be added and their rotations
    test_new_pieces = [MyPiece.rotations([[0,0], [1,0], [2,1], [0,1], [1,1]]),
                  MyPiece.rotations([[-1,0], [0,0], [1,0], [2,0], [3,0]]),
                  MyPiece.rotations([[0,0], [1,0], [1,1]])]
    # override All_My_Pieces to add new pieces
    all_test_pieces = test_new_pieces + test_classic_pieces

    all_pieces_strage = []

    (0..(all_test_pieces.size-1)).each{|index|
      all_pieces_strage += all_test_pieces[index]
    }

    (0..10000).each{|index|
      @piece = MyPiece.next_piece(@new_board)
      all_pieces_strage.delete(@piece.current_rotation)
    }

    assert_empty(all_pieces_strage)
  end

  # This function checks if next_cheat_piece functino makes
  # a valid cheat piece.
  def test_cheat_piece
    @new_board = TestMyBoard.new
    @cheat_piece = MyPiece.next_cheat_piece(@new_board)
    cheat_piece = MyPiece.rotations([[0,0]])
    cheat_piece.delete(@cheat_piece.current_rotation)
    assert_empty(cheat_piece)
  end

  # This function checks if cheat function works when the
  # user have more than and equal to 100 score. Also check
  # the case when the user have less than 100 score after
  # using one cheat command and try to use the cheat command.
  def test_cheat_function_case1
    @new_board = TestMyBoard.new
    @old_score = @new_board.score
    @new_board.start_cheating
    @new_score = @new_board.score
    @new_board.next_piece
    @new_piece = @new_board.current_block
    assert_equal(@new_score + 100, @old_score)
    assert_equal(@new_piece.current_rotation, [[0, 0]])

    # try to do cheat command again
    @new_board.start_cheating
    @new_score2 = @new_board.score
    @new_board.next_piece
    @new_piece = @new_board.current_block
    assert_equal(@new_score, @new_score2)
    assert(@new_piece.current_rotation != [[0, 0]])
  end

  # This function checks if cheat function doesn't work when the
  # user have less than 100 score.
  def test_cheat_function_case2
    @new_board = TestMyBoard2.new
    @new_board.start_cheating
    @new_score = @new_board.score
    @new_board.next_piece
    @new_piece = @new_board.current_block
    assert_equal(@new_score, 50)
    assert(@new_piece.current_rotation != [[0, 0]])
  end

  # This function checks if cheat function works when the
  # user have more than 100 score (this test case set as
  # 200) and use cheat command 2 times sequencely.
  def test_cheat_function_case3
    @new_board = TestMyBoard3.new
    @old_score = @new_board.score
    @new_board.start_cheating
    @new_score = @new_board.score
    @new_board.next_piece
    @new_piece = @new_board.current_block
    assert_equal(@new_score + 100, @old_score)
    assert_equal(@new_piece.current_rotation, [[0, 0]])

    # try to do cheat command again
    @new_board.start_cheating
    @new_score2 = @new_board.score
    @new_board.next_piece
    @new_piece = @new_board.current_block
    assert_equal(@new_score2 + 100, @new_score)
    assert_equal(@new_piece.current_rotation, [[0, 0]])
  end
end

# subclass of MyBoard to use Unit test. It overrides some function
# that is used for unit test. This Board has score 100.
class TestMyBoard < MyBoard

  def initialize
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 100
    @delay = 500
  end

  def rotate_clockwise
    @current_block.move(0, 0, 1)
  end

  def rotate_counter_clockwise
    @current_block.move(0, 0, -1)
  end

  def rotate_180
    @current_block.move(0, 0, 2)
  end

  def current_block
    @current_block
  end

end

# subclass of MyBoard to use Unit test. It overrides some function
# that is used for unit test. This Board has score 50.
class TestMyBoard2 < MyBoard

  def initialize
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 50
    @delay = 500
  end

  def current_block
    @current_block
  end

end

# subclass of MyBoard to use Unit test. It overrides some function
# that is used for unit test. This Board has score 200.
class TestMyBoard3 < MyBoard

  def initialize
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 200
    @delay = 500
  end

  def current_block
    @current_block
  end

end
