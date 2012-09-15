class Point

    attr_reader :column, :row

    def initialize(column, row)
        @column = column
        @row = row
    end

    def ==(point)
        @column == point.column && @row == point.row
    end

    def +(point)
        Point.new(@column + point.column, @row + point.row)
    end

    def -(point)
        Point.new(@column - point.column, @row - point.row)
    end

    def to_s
        "(#{column}, #{row})"
    end

end
