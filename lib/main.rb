require_relative 'board'
# require './board'

class Player
	attr_accessor :color

	def initialize(color) #color true == black false == white
		@color = color
		@name = color == true ? "Solid" : "Clear"
	end

	def select(board)
		valid = %w{a b c d e f g h}
		cord_array = []

		puts "#{@name}'s Turn, select a piece to move, 'save' to save the game and exit, or 'resign' to quit."

		while cord_array.empty?
			move = gets.downcase.chomp
			input_array = move.split(//)			
			if valid.include?(input_array[0]) && input_array[1].to_i > 0 && input_array[1].to_i < 9
				cord_array = [valid.index(input_array[0]), input_array[1].to_i - 1]
			elsif input_array.join == "resign"
				return :resign
			elsif input_array.join == "save"
				return :save
			else
				puts "Please input a valid location e.g. 'g6'"
			end
		end

		if board[[cord_array[0],cord_array[1]]].color == @color
			return cord_array
		else
			puts "Please select a valid piece."
			return false
		end
	end

	def move(valid_moves)
		puts "Enter a location to move piece, or 'back' to select another."

		valid = %w{a b c d e f g h}
		cord_array = []

		while cord_array.empty?
			move = gets.downcase.chomp
			input_array = move.split(//)
			if valid.include?(input_array[0]) && input_array[1].to_i > 0 && input_array[1].to_i < 9
				cord_array = [valid.index(input_array[0]), input_array[1].to_i - 1]
			elsif input_array.join == "back"
				return :back
			else
				puts "Please input a valid location."
			end
		end

		if valid_moves.include?(cord_array)
			return cord_array
		else
			puts "Please select a valid move."
			return false
		end
	end

end

class MainGame 
	def initialize
		@board = ChessBoard.new
		@p_black = Player.new(true)
		@p_white = Player.new(false)
	end

	def game_loop
		game_end = false
		player_flag = false
		
		
		while !game_end

			@board.display	

			player_turn_complete = false

			if player_flag == true
				player = @p_black
				player_flag = false
			else
				player = @p_white
				player_flag = true
			end	

			while !player_turn_complete
				player_turn_complete = true

				selector = false				
				while selector == false
					selector = player.select(@board.piece_loc)
				end

				if selector == :resign
					game_end = true #flesh this out with win conditional
				elsif selector == :save
					game_end = true #flesh this out with save functionality
				else
					valid_moves = @board.piece_loc[selector].moves(selector, @board.piece_loc)
					@board.valid_movement_highlight(valid_moves)

					move = false
					while move == false
						move = player.move(valid_moves)
					end

					if move == :back #catch for player going back to piece selection
						player_turn_complete = false
					else
						selected_piece = @board.piece_loc[selector]

						case selected_piece.class.to_s #apply special conditions for pieces
							when "King"

							when "Queen"

							when "Rook"

							when "Knight"

							when "Bishop"

							when "Pawn"
								selected_piece.moved = true
							else
								p "SOMETHING WENT WRONG BR0"
						end

						@board.move_piece(selector,move)
					end		
					
				end
			end	#end of player turn loop
		end
	end

end

 # game = MainGame.new
 # game.game_loop

