
require_relative './provided'

class MyPiece < Piece

  # Array holding all the new pieces to be added and their rotations
  New_Pieces = [rotations([[0,0], [1,0], [2,1], [0,1], [1,1]]),
                rotations([[-1,0], [0,0], [1,0], [2,0], [3,0]]),
                rotations([[0,0], [1,0], [1,1]])]

  # override All_My_Pieces to add new pieces
  All_My_Pieces = New_Pieces + All_Pieces

  # Array holding a piace when the user user cheating command.
  Cheat_Piece = [rotations([[0,0]])]

  # class method to choose the next piece
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  # class method to choose the cheating piece
  def self.next_cheat_piece (board)
    MyPiece.new(Cheat_Piece.sample, board)
  end

end

class MyBoard < Board

  # initialize current_block and isCheat that is used for checking if the user
  # is using cheating command or not.
  def initialize (game)
    super
    @current_block = MyPiece.next_piece(self)
    @isCheat = false
  end

  # gets the information from the current piece about where it is and uses this
  # to store the piece on the board itself.  Then calls remove_filled.
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..locations.size-1).each{|index|
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] =
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  # gets the next piece. If 'isCheat' is true, get cheating
  # piece. Otherwise, get the next piece from 10 classic
  # piece. After getting piece, 'isCheat' will be initialized.
  def next_piece
    if @isCheat
      @current_block = MyPiece.next_cheat_piece(self)
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
    @isCheat = false
  end

  # rotate 90 degree 2 times (rotate 180 degree).
  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  # this function substract 100 point and change isCheat
  # to be true.
  def cheat
    @score -= 100
    @isCheat = true
  end

  # this function check if the user has more than and equal to
  # 100 point and is using chating command. Then call cheat function.
  def start_cheating
    if @score >= 100 && @isCheat != true
      cheat
    end
  end

end

class MyTetris < Tetris
  
  # creates a canvas and the board that interacts with it
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  # add 'u' key that has 180 degree rotation function and 'c' key call
  # cheating system.
  def key_bindings
    super
    @root.bind('u', lambda {@board.rotate_180})
    @root.bind('c', lambda {@board.start_cheating})
  end

end
