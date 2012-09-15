def choose_tile_to_slide(board)
    mobile_tiles(board).sample
end

def mobile_tiles(board)
    result = []
    (0..board.size - 1).each do |row|
        (0..board.size - 1).each do |column|
            result << [row, column] if board.can_slide?(row, column)
        end
    end
    result
end
