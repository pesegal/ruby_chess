require "./board"

class Player
	attr_accessor :color

	def initialize(color) #color true == black false == white
		@color = color
		@name = color == true ? "Solid" : "Clear"
	end

	def select(board)
		valid = %w{a b c d e f g h}
		cord_array = []

		puts "#{@name}'s Turn, select a piece to move or resign."

		while cord_array.empty?
			move = gets.downcase.chomp
			input_array = move.split(//)			
			if valid.include?(input_array[0]) && input_array[1].to_i > 0 && input_array[1].to_i < 9
				cord_array = [valid.index(input_array[0]), input_array[1].to_i - 1]
			elsif input_array.join == "resign"
				return true
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

	def move(board)


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
		
		while !game_end

			@board.display
			selector = @p_white.select(@board.piece_loc) 
			#returns cord of selected piece | or false if wrong selection | or true if they resign *use if/else statement here to select player.


			if @board.piece_loc[selector].class == Pawn #check type of piece *use case statement here?				
			   @board.valid_movement_highlight(@board.piece_loc[selector].moves(selector, @board.piece_loc))
			   gets
			   @board.clear_movement_highlight

			end


			# @board.display
			# puts @p_black.select(@board.piece_loc)
			# @board.display
			# puts @p_white.select(@board.piece_loc)
		end
	end

end

game = MainGame.new
game.game_loop

