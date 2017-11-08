# Represents a game board for Conway's Game of Life
#
# @attr_reader [Int] width The width of the game board.
# @attr_reader [Int] height The height of the game board.
# @attr_reader [Array<Array<Boolean>>] board A board state to start with.
#
# @note The board is finite but wraps around.
class Game
  attr_reader :width
  attr_reader :height
  attr_reader :board

  def initialize(width, height, board: nil)
    @width  = width
    @height = height

    _setup_board board: board
  end

  # Prints the board to out.
  #
  # @param [#puts] out Where to print the board to.
  def print(out: $stdout)
    raise ArgumentError.new("Board can only print to objects that respond to .puts!") if not out.respond_to? :puts

    @board.each do |row|
      line = row.map { |c| c ? "1" : "0" }.join(" ")
      out.puts(line)
    end

    # newline for separation
    out.puts("")
  end

  # Return the cells as a flattened array
  #
  # @return [Array<Int>]
  def cells
    @board.flatten
  end

  # Return the value at the cell position.
  #
  # @param [Int] x The x position of the cell.
  # @param [Int] y The y position of the cell.
  #
  # @return [Boolean]
  def cell_at(x, y)
    # need to traverse the board by y then x because rows then cols
    @board[y][x]
  end

  # Is the cell alive at the given position?
  #
  # return [Boolean]
  def alive?(x, y)
    # need to traverse the board by y then x because rows then cols
    @board[y][x]
  end

  # Is the cell dead at the given position?
  #
  # @see Board#alive?
  #
  # @return [Boolean]
  def dead?(x, y)
    !alive?(x, y)
  end

  # Marks the cell as alive.
  #
  # @param [Int] x The x position of the cell.
  # @param [Int] y The y position of the cell.
  def mark_alive(x, y)
    # need to traverse the board by y then x because rows then cols
    @board[y][x] = true
  end

  # Marks the cell as dead.
  #
  # @param [Int] x The x position of the cell.
  # @param [Int] y The y position of the cell.
  def mark_dead(x, y)
    # need to traverse the board by y then x because rows then cols
    @board[y][x] = false
  end

  # Toggle the state of the given cell.
  #
  # @param [Int] x The x position of the cell.
  # @param [Int] y The y position of the cell.
  #
  # @return [Boolean] Returns the current state of the cell.
  def toggle_state(x, y)
    # need to traverse the board by y then x because rows then cols
    @board[y][x] = !@board[y][x]
  end

  # Returns the set of neighbors for the cell from 0 - 7, e.g.:
  #
  # 0 1 2
  # 3 c 4
  # 5 6 7
  #
  # where 'c' is the cell on the board
  #
  # @param [Int] x The x position of the cell.
  # @param [Int] y The y position of the cell.
  #
  # @return [Array<Boolean>] Returns the current state of the cell.
  def neighbors(x, y)
    prev_x = (x - 1 < 0) ? @board.first.length - 1 : x - 1
    prev_y = (y - 1 < 0) ? @board.length - 1 : y - 1
    next_x = (x + 1 >= @board.first.length) ? 0 : x + 1
    next_y = (y + 1 >= @board.length) ? 0 : y + 1

    return [
      cell_at(prev_x, prev_y), cell_at(x, prev_y), cell_at(next_x, prev_y),
      cell_at(prev_x, y),                          cell_at(next_x, y),
      cell_at(prev_x, next_y), cell_at(x, next_y), cell_at(next_x, next_y)
    ]
  end

  # Returns if the given cell should live in the next iteration.
  #
  # The Game of Life is a simple discrete simulation on a regular grid. It is governed by two rules:
  #   1. An empty cell "comes to life" if it is adjacent to exactly three live squares.
  #   2. A live cell "dies" if it has less than two live neighbors, or more than three live neighbors.
  #
  #
  # @param [Int] x The x position of the cell.
  # @param [Int] y The y position of the cell.
  #
  # @return [Boolean]
  def next_cell_state(x, y)
    alive_count = neighbors(x, y).count {|n| n}

    if alive?(x, y)
      if alive_count < 2 or alive_count > 3
        false
      else
        true
      end
    else
      if alive_count == 3
        true
      else
        false
      end
    end
  end

  # Returns the next game state in terms of the board
  #
  # @return [Array<Array<Boolean>>]
  def next_state
    Array.new(@height) do |y|
      Array.new(@width) do |x|
        next_cell_state(x, y)
      end
    end
  end

  # Advance the game state and set the new board
  def advance
    @board = next_state
  end

  private

  # Creates and sets up a new board either with a seed or with all false cells.
  #
  # @param [Array<Array<Boolean>>] board A board to setup.
  def _setup_board(board: nil)
    if board.nil?
      # need to traverse the board by y then x because rows then cols
      @board = Array.new(@height) { Array.new(@width) { false } }
    else
      @board = board
    end
  end

end
