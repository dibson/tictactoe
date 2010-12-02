module TicTacToe
  class OutOfBoundsError < StandardError; end;
  class CellOccupiedError < StandardError; end;

  class Board

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

    def wins? token

      lines = [
                [[0,0],[1,1],[2,2]], # diag from tl to br
                [[2,0],[1,1],[0,2]], # diage from bl to tr

                # horiz lines
                [[0,0], [0,1], [0,2]],
                [[1,0], [1,1], [1,2]],
                [[2,0], [2,1], [2,2]],

                # vert lines
                [[0,0], [1,0], [2,2]],
                [[0,1], [1,1], [2,1]],
                [[0,2], [1,2], [2,2]],
              ]

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

  if board.wins? current_player
    puts "#{current_player} wins!"
    exit
  end

  if board.draw?
    puts "It's a draw!"
    exit
  end

  current_player = players.next 
end
