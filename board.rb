require 'point'

class Board

    def self.generate(size)
        tiles = []
        positions_of_tiles = {}

        tile = 1
        (0..size - 1).each do |row|
            tiles.push([])
            (0..size - 1).each do |column|
                tiles[row].push(tile)
                positions_of_tiles[tile] = Point.new(column, row)
                tile += 1
            end
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

    # Returns a new Board where the given tile (identified by its number value) has been moved into the empty space.
    #
    # Example:
    #   ---------
    #   | 1 | 2 |
    #   ---------
    #   | 3 |   |
    #   ---------
    #
    # slide(3) yields
    #
    #   ---------
    #   | 1 | 2 |
    #   ---------
    #   |   | 3 |
    #   ---------
    #
    def slide(tile)
        dup.slide!(tile)
    end

    def position_of(tile)
        @positions_of_tiles[tile]
    end

    def can_slide?(tile)
        movable_tiles.include?(tile)
    end

    def gap
        position_of(nil)
    end

    def movable_tiles
        north = gap - Point.new(0, 1)
        south = gap + Point.new(0, 1)
        east = gap + Point.new(1, 0)
        west = gap - Point.new(1, 0)

        result = []

        result << get(north) if north.row >= 0
        result << get(south) if south.row < size
        result << get(east) if east.column < size
        result << get(west) if west.column >= 0

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
        result = "\n"
        result << line
        @tiles.each do |row|
            result << "\n| "
            row.each { |tile| result << "#{tile || ' '} | " }
            result << "\n"
            result << line
        end
        result
    end

    def shuffle(amount = 1000)
        result = dup

        amount.times do
            result.slide!(result.movable_tiles.sample)
        end

        result
    end

    protected

    attr_reader :tiles

    def initialize(tiles)
        @tiles = tiles
        @positions_of_tiles = {}

        tiles.each_index do |row|
            tiles[row].each_index do |column|
                tile = tiles[row][column]
                @positions_of_tiles[tile] = Point.new(column, row)
            end
        end
    end

    def set(point, value)
        @tiles[point.row][point.column] = value
        @positions_of_tiles[value] = point
    end

    # Slides the tile, modifying the current Board instance.
    def slide!(tile)
        if not can_slide?(tile)
            raise "Can't slide tile '#{tile}' at #{position_of(tile)} into the empty space #{gap} in board:\n#{self}"
        end

        position_of_tile = position_of(tile)
        position_of_gap = position_of(nil)

        set(position_of_tile, nil)
        set(position_of_gap, tile)

        self
    end

end
