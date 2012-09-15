require 'point'

class Board

    attr_reader :gap

    def self.generate(size)
        tiles = []
        (1..size).each do |r|
            first_tile_in_row = ((r - 1) * size + 1)
            last_tile_in_row = first_tile_in_row + size - 1
            tiles << (first_tile_in_row..last_tile_in_row).to_a
        end

        tiles[size - 1][size - 1] = nil

        Board.new(tiles)
    end

    # The size of the board; i.e. the width or height, in tiles.
    def size
        tiles[0].length
    end

    # Returns the number of the tile at the given position, nil for the empty space.
    def get(point)
        tiles[point.row][point.column]
    end

    # Returns a new Board where the given tile has been moved into the empty space.
    def slide(point)
        dup.slide!(point)
    end

    # Slides the tile, modifying the current Board instance.
    def slide!(point)
        raise "#{point} is not on the board" if not on_board?(point)
        if not can_slide?(point)
            raise "Can't slide tile '#{get(point)}' at #{point} into the empty space in board:\n#{self}"
        end

        tiles[gap.row][gap.column] = get(point)
        tiles[point.row][point.column] = nil
        @gap = point

        self
    end

    def on_board?(point)
        point.column >= 0 && point.column < size && point.row >= 0 && point.row < size
    end

    def can_slide?(point)
        points_adjacent_to_gap.include?(point)
    end

    def points_adjacent_to_gap
        north = gap + Point.new(0, 1)
        south = gap - Point.new(0, 1)
        east = gap + Point.new(1, 0)
        west = gap - Point.new(1, 0)

        result = []

        result << north if on_board?(north)
        result << south if on_board?(south)
        result << east if on_board?(east)
        result << west if on_board?(west)

        result
    end

    def dup
        Board.new(@tiles.map { |row| row.dup })
    end

    def ==(board)
        @tiles.each_index { |row| return false if tiles[row] != board.tiles[row] }
        true
    end

    def to_s
        line = "-" + "----" * size
        result = ""
        result << line
        @tiles.each do |row|
            result << "\n| "
            row.each { |tile| result << "#{tile || ' '} | " }
            result << "\n"
            result << line
        end
        result
    end

    def shuffle
        Board.new(tiles.map { |row| row.shuffle })
    end

    protected

    attr_reader :tiles

    def initialize(tiles)
        @tiles = tiles

        tiles.each_index do |row|
            gap_column = tiles[row].index(nil)
            if gap_column
                @gap = Point.new(gap_column, row)
                break
            end
        end
    end

end
