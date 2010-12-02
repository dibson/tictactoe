module TicTacToe

  class TicTacToeError < StandardError; end;

  class OutOfBoundsError < TicTacToeError; end;
  class CellOccupiedError < TicTacToeError; end;
  class BadRowColError < TicTacToeError; end;

  class Board
  
    DIM = 2

    # Initialize a tic-tac-toe board
    def initialize(size=3)

      @size = size

      # make game board
      @cells = []
      @size.times { @cells << Array.new(@size) }

      # make possible winning lines
      @lines = []

      # add diaganols
      @lines << (0...@size).map { |n| [n,n] }
      @lines << (0...@size).map { |n| [n, @size - n - 1] }

      # add horiz lines
      @lines += (0...@size).map do |row|
        row_line = []
        (0...@size).each { |col| row_line << [row, col] }
        row_line
      end

      # add vert lines
      @lines += (0...@size).map do |col|
        col_line = []
        (0...@size).each { |row| col_line << [row, col] }
        col_line
      end

    end

    # fill board position with given token
    def fill_cell(row, col, token)

      if row.nil? or col.nil? or !(row.integer? and col.integer?)
        raise BadRowColError
      end

      begin
        cell_contents = @cells.fetch(row).fetch(col)
      rescue IndexError
        raise OutOfBoundsError
      end

      if cell_contents
        raise CellOccupiedError
      end

      @cells[row][col] = token

    end

    # true if this token has won the game
    def wins? token

      @lines.any? do |line|
        line.all? { |row,col| @cells[row][col] == token }
      end

    end

    # true if no more moves can be played
    def draw?
      @cells.flatten.compact.length == @size**DIM
    end

    # string representation of board
    def to_s
      @cells.map { |row| row.map { |e| e || " " }.join("|") }.join("\n")
    end

  end
end

board = TicTacToe::Board.new

[:X, :O].cycle do |current_player|

  puts board
  print "\n #{current_player} >> "
  row, col = gets.split.map { |e| e.to_i }
  puts

  begin
    board.fill_cell(row, col, current_player)
  rescue TicTacToe::OutOfBoundsError
    puts "Row/Col are out of bounds"
    next
  rescue TicTacToe::CellOccupiedError
    puts "Cell is occupied"
    next
  rescue TicTacToe::BadRowColError
    puts "Bad row/col entered - enter two integers separated by a space"
    next
  end

  if board.wins? current_player
    puts board
    puts
    puts "#{current_player} wins!"
    exit
  end

  if board.draw?
    puts board
    puts
    puts "It's a draw!"
    exit
  end

end
