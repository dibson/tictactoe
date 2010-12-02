module TicTacToe
  class OutOfBoundsError < StandardError; end;
  class CellOccupiedError < StandardError; end;
  class BadRowColError < StandardError; end;

  class Board

    def initialize()
      @size = 3

      @cells = []
      @size.times { @cells << Array.new(@size) }

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

    def wins? token

      @lines.any? do |line|
        line.all? { |row,col| @cells[row][col] == token }
      end

    end

    def draw?
      @cells.flatten.compact.length == 9
    end

    def to_s
      @cells.map { |row| row.map { |e| e || " " }.join("|") }.join("\n")
    end

  end
end

board   = TicTacToe::Board.new

players = [:X, :O].cycle

current_player = players.next 

loop do
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
    puts "#{current_player} wins!"
    exit
  end

  if board.draw?
    puts board
    puts "It's a draw!"
    exit
  end

  current_player = players.next 
end
