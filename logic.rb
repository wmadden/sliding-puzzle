def start(current_board, solved_board)
  # Perform initialisation
end

def choose_tile_to_slide(current_board, solved_board)
  # Return the tile to slide (identified by its position, as a Point)
  current_board.points_adjacent_to_gap.sample
end