require_relative 'pieces'
# require './pieces'

class ChessBoard
	attr_accessor :piece_loc

	def initialize (empty = false)
		@piece_loc = {}
		build
		init_pieces unless empty 
	end

	## ACTION FUNCTIONS

	def test_move? (start_pos,end_pos,player)
		moving_piece = @piece_loc[start_pos]
		stored_piece = @piece_loc[end_pos]
		if moving_piece.class == Rook && @piece_loc[end_pos].class == King && moving_piece.color == @piece_loc[end_pos].color
			return castling_test?(moving_piece, stored_piece, start_pos, end_pos, player)
		else
			@piece_loc[start_pos] = Piece.new
			@piece_loc[end_pos] = moving_piece
			if in_check?(player)
				@piece_loc[start_pos] = moving_piece
				@piece_loc[end_pos] = stored_piece
				return false
			else
				@piece_loc[start_pos] = moving_piece
				@piece_loc[end_pos] = stored_piece
				return true
			end
		end
	end

	def move_piece (start_pos,end_pos)
		moving_piece = @piece_loc[start_pos]
		if moving_piece.class == Rook && @piece_loc[end_pos].class == King && moving_piece.color == @piece_loc[end_pos].color
			castling(moving_piece, start_pos, end_pos)
		else
			@piece_loc[start_pos] = Piece.new
			@piece_loc[end_pos] = moving_piece
			if moving_piece.class == Pawn #Pawn promotion prompt				
				pawn_promotion(end_pos,moving_piece.color) if end_pos[1] == 0		
				pawn_promotion(end_pos,moving_piece.color) if end_pos[1] == 7	
			end
		end
	end

	def checkmate? (player)
		player_hash = {}
		valid_moves = []
		checkmate_flag = true
		if in_check?(player)

			@piece_loc.each do |key, value|
				if value.color == player 
					player_hash[key] = value
				end
			end

			player_hash.each do |key, value|
				valid_moves = value.moves(key, self)				
				valid_moves.each do |cord|				
					checkmate_flag = false if test_move?(key,cord,player) == true					
				end
			end
		else # This is where stalemates are checked
			@piece_loc.each do |key, value|
				if value.color == player 
					player_hash[key] = value
				end
			end

			player_hash.each do |key, value|
				valid_moves = value.moves(key, self)
				valid_moves.each do |cord|
					checkmate_flag = false if test_move?(key,cord,player) == true
				end
			end
			return :draw if checkmate_flag == true
		end
		checkmate_flag
	end

	def in_check? (player)
		king = []
		@piece_loc.each do |key, value|
			if value.class == King && value.color == player
				king = key
			end
		end
		danger_loc(player).include?(king)
	end

	def danger_loc(player) #Returns a list of potential dangerous spots for the player to move. I.E. Piece can be attacked next turn.
		danger_spots = []
		@piece_loc.each do |key, value|
			unless value.color == player || value.class == Piece
				if value.class == Pawn
					piece_mov = value.pot_attacks(key, self)
					piece_mov.each { |cord| danger_spots.push(cord) }
				else
					piece_mov = value.pot_attacks(key, self)
					piece_mov.each { |cord| danger_spots.push(cord) }
				end
			end
		end
		danger_spots.uniq!
		danger_spots
	end

	## DISPLAY FUNCTIONS

	def display	
		puts " \n\n"
		puts "     a   b   c   d   e   f   g   h     "
		8.times do |i|
			puts "   +---+---+---+---+---+---+---+---+  "
			puts " #{8 - i} | #{@piece_loc[[0,7 - i]].sym} | #{@piece_loc[[1,7 - i]].sym} | #{@piece_loc[[2,7 - i]].sym} | #{@piece_loc[[3,7 - i]].sym} | #{@piece_loc[[4,7 - i]].sym} | #{@piece_loc[[5,7 - i]].sym} | #{@piece_loc[[6,7 - i]].sym} | #{@piece_loc[[7,7 - i]].sym} | #{8 - i}"
		end
		puts "   +---+---+---+---+---+---+---+---+  "
		puts "     a   b   c   d   e   f   g   h     \n\n"
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

	private	##HELPER FUNCTIONS

	def castling (moving_piece, start_pos,end_pos)
		if start_pos[0] == 0
			@piece_loc[[2,start_pos[1]]] = @piece_loc[end_pos]
			@piece_loc[[3,start_pos[1]]] = moving_piece
			@piece_loc[start_pos] = Piece.new
			@piece_loc[end_pos] = Piece.new
		else
			@piece_loc[[6,start_pos[1]]] = @piece_loc[end_pos]
			@piece_loc[[5,start_pos[1]]] = moving_piece
			@piece_loc[start_pos] = Piece.new
			@piece_loc[end_pos] = Piece.new
		end
	end

	def castling_test? (moving_piece, stored_piece, start_pos, end_pos, player)
		checked = true
		if start_pos[0] == 0
			@piece_loc[[2,start_pos[1]]] = @piece_loc[end_pos]
			@piece_loc[[3,start_pos[1]]] = moving_piece
			@piece_loc[start_pos] = Piece.new
			@piece_loc[end_pos] = Piece.new
			checked = false if in_check?(player)
			@piece_loc[[2,start_pos[1]]] = Piece.new
			@piece_loc[[3,start_pos[1]]] = Piece.new
			@piece_loc[start_pos] = moving_piece
			@piece_loc[end_pos] = stored_piece
			return checked
		else
			@piece_loc[[6,start_pos[1]]] = @piece_loc[end_pos]
			@piece_loc[[5,start_pos[1]]] = moving_piece
			@piece_loc[start_pos] = Piece.new
			@piece_loc[end_pos] = Piece.new
			checked = false if in_check?(player)
			@piece_loc[[6,start_pos[1]]] = Piece.new
			@piece_loc[[5,start_pos[1]]] = Piece.new
			@piece_loc[start_pos] = moving_piece
			@piece_loc[end_pos] = stored_piece
			return checked
		end
	end

	def pawn_promotion(pos, player)
		puts "Promote to: Queen (default), Knight (1), Rook (2), Bishop (3). Enter number or continue for default."
		selection = gets.chomp.to_i
		case selection
		when 1
			@piece_loc[pos] = Knight.new(true) if player
			@piece_loc[pos] = Knight.new(false) if !player
		when 2
			@piece_loc[pos] = Rook.new(true) if player
			@piece_loc[pos] = Rook.new(false) if !player
		when 3
			@piece_loc[pos] = Bishop.new(true) if player
			@piece_loc[pos] = Bishop.new(false) if !player
		else
			@piece_loc[pos] = Queen.new(true) if player
			@piece_loc[pos] = Queen.new(false) if !player
		end
	end

	def build
		8.times do |i|
			8.times do |j|
				@piece_loc[[i,j]] = Piece.new()
			end
		end
	end

	def init_pieces
		#Init Black Pieces (solid)
		@piece_loc[[0,7]] = Rook.new(true)
		@piece_loc[[7,7]] = Rook.new(true)
		@piece_loc[[1,7]] = Knight.new(true)
		@piece_loc[[6,7]] = Knight.new(true)
		@piece_loc[[2,7]] = Bishop.new(true)
		@piece_loc[[5,7]] = Bishop.new(true)
		@piece_loc[[3,7]] = Queen.new(true)
		@piece_loc[[4,7]] = King.new(true)

		#Init White Pieces (clear)
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