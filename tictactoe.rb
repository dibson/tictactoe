module TicTacToe
  class OutOfBoundsError < StandardError; end;
  class CellOccupiedError < StandardError; end;

  class Board

    attr_reader :cells

    def initialize()
      @cells = [[nil,nil,nil],
                [nil,nil,nil],
                [nil,nil,nil]]
    end

    def fill_cell(row, col, token)

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

    def wins? (row, col, token)

      lines = []

      left_diagonal = [[0,0],[1,1],[2,2]]
      right_diagonal = [[2,0],[1,1],[0,2]]

      [left_diagonal, right_diagonal].each do |line|
        lines << line if line.include?([row,col])
      end

      lines << (0..2).map { |c1| [row, c1] }
      lines << (0..2).map { |r1| [r1, col] }

      win = lines.any? do |line|
        line.all? { |row,col| @cells[row][col] == token }
      end

      return win

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
  end

  if board.wins? row, col, current_player
    puts "#{current_player} wins!"
    exit
  end

  if board.draw?
    puts "It's a draw!"
    exit
  end

  current_player = players.next 
end
