# TicTacToe module
#
# Write your own TicTacToe with the given board class,
# or just play on command-line with TicTacToe.play
module TicTacToe

  class TicTacToeError < StandardError; end;

  class OutOfBoundsError < TicTacToeError; end;
  class CellOccupiedError < TicTacToeError; end;
  class BadRowColError < TicTacToeError; end;

  # play a game of tic tac toe
  def self.play

    board = TicTacToe::Board.new
    players = PlayerManager.new

    loop do

      # get user input
      puts board
      puts
      print "\n #{players.current} >> "
      row, col = gets.split.map { |e| e.to_i }
      puts

      begin
        board.fill_cell(row, col, players.current)
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

      if board.wins? players.current
        puts board
        puts
        puts "#{players.current} wins!"
        return players.current
      end

      if board.filled?
        puts board
        puts
        puts "It's a draw!"
        return false
      end

      players.next_player
    
    end
  end

  # manage a cycle of players
  class PlayerManager

    attr_reader :current

    def initialize(players=[:X, :O])
      @players_cycle = players.cycle
      self.next_player
    end

    def next_player
      @current = @players_cycle.next
    end

  end

  # a tic tac toe board
  # 
  # does not play a game, use play method or implement your own with this class
  class Board
  
    DIM = 2
    attr_reader :size, :cells

    # Initialize a tic-tac-toe board of given size
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
    #
    # note: it will take any token you give it, so you can play with
    #       more players, but that's probably silly
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
    def filled?
      @cells.flatten.compact.length == @size**DIM
    end

    # string representation of board
    def to_s
      @cells.map { |row| row.map { |e| e || " " }.join("|") }.join("\n")
    end

  end
end

TicTacToe::play
