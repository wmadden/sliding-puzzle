class Board

    attr_reader :gap_column, :gap_row

    def self.generate(size)
        tiles = []
        (1..size).each do |r|
            first_tile_in_row = ((r - 1) * size + 1)
            last_tile_in_row = first_tile_in_row + size - 1
            tiles << (first_tile_in_row..last_tile_in_row).to_a
        end

        gap_column = size - 1
        gap_row = size - 1
        tiles[gap_column][gap_row] = nil

        Board.new( tiles )
    end

    # The size of the board; i.e. the width or height, in tiles.
    def size
        tiles[0].length
    end

    # Returns the number of the tile at the given position, nil for the empty space.
    def get(row, column)
        tiles[row][column]
    end

    # Returns a new Board where the given tile has been moved into the empty space.
    def slide(row, column)
        result = dup
        result.slide!(row, column)
        result
    end

    # Slides the tile, modifying the current Board instance.
    def slide!(row, column)
        raise "(#{row}, #{column}) is not on the board" if not on_board?(row, column)
        raise "Can't slide #{get(row, column)} (row=#{row}, col=#{column}) into the empty space" if not can_slide?(row, column)

        tiles[gap_row][gap_column] = get(row, column)
        tiles[row][column] = nil
        @gap_column = column
        @gap_row = row
    end

    def can_slide?(row, column)
        (row == gap_row || column == gap_column) && !(row == gap_row && column == gap_column) && 
            (row - gap_row).abs <= 1 && (column - gap_column).abs <= 1
    end

    def on_board?(x, y)
        x < size && y < size
    end

    def dup
        Board.new(@tiles.dup)
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

        tiles.each_index do |r|
            @gap_column = tiles[r].index(nil)
            if @gap_column
                @gap_row = r
                break
            end
        end
    end

end
