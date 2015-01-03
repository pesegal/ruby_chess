require 'pieces'
# require './pieces'

class ChessBoard

	attr_accessor :piece_loc

	def initialize 
		@piece_loc = {}
		build
		init_pieces
	end

	def display		
		puts "\nLast Move: \n\n"
		puts "     a   b   c   d   e   f   g   h     "
		8.times do |i|
			puts "   +---+---+---+---+---+---+---+---+  "
			puts " #{8 - i} | #{@piece_loc[[0,7 - i]].sym} | #{@piece_loc[[1,7 - i]].sym} | #{@piece_loc[[2,7 - i]].sym} | #{@piece_loc[[3,7 - i]].sym} | #{@piece_loc[[4,7 - i]].sym} | #{@piece_loc[[5,7 - i]].sym} | #{@piece_loc[[6,7 - i]].sym} | #{@piece_loc[[7,7 - i]].sym} | #{8 - i}"
		end
		puts "   +---+---+---+---+---+---+---+---+  "
		puts "     a   b   c   d   e   f   g   h     \n\n"
	end

	def move_piece (start_pos,end_pos)
		moving_piece = @piece_loc[start_pos]
		@piece_loc[start_pos] = Piece.new
		@piece_loc[end_pos] = moving_piece
		clear_movement_highlight
		display
	end

	def valid_movement_highlight(valid_moves)
		valid_moves.each do |cord|
			if @piece_loc[cord].class == Piece			
				@piece_loc[cord].sym = "_"
			end

		end
		display
	end

	def clear_movement_highlight
		@piece_loc.each_value do |value|
			if value.class == Piece
				value.sym = " "
			end
		end			
	end

	private	

	def build
		8.times do |i|
			8.times do |j|
				@piece_loc[[i,j]] = Piece.new()
			end
		end
	end

	def init_pieces
		#Init Black Pieces
		@piece_loc[[0,7]] = Rook.new(true)
		@piece_loc[[7,7]] = Rook.new(true)
		@piece_loc[[1,7]] = Knight.new(true)
		@piece_loc[[6,7]] = Knight.new(true)
		@piece_loc[[2,7]] = Bishop.new(true)
		@piece_loc[[5,7]] = Bishop.new(true)
		@piece_loc[[3,7]] = Queen.new(true)
		@piece_loc[[4,7]] = King.new(true)

		#Init White Pieces
		@piece_loc[[0,0]] = Rook.new(false)
		@piece_loc[[7,0]] = Rook.new(false)
		@piece_loc[[1,0]] = Knight.new(false)
		@piece_loc[[6,0]] = Knight.new(false)
		@piece_loc[[2,0]] = Bishop.new(false)
		@piece_loc[[5,0]] = Bishop.new(false)
		@piece_loc[[3,0]] = Queen.new(false)
		@piece_loc[[4,0]] = King.new(false)

		#Init Pawns
		8.times do |i|
			@piece_loc[[i,6]] = Pawn.new(true)
			@piece_loc[[i,1]] = Pawn.new(false)
		end
	end
end
