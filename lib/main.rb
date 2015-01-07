require_relative 'board'
# require './board'

class Player
	attr_accessor :color
	attr_reader :name

	def initialize(color) #color true == black false == white
		@color = color
		@name = color == true ? "Solid" : "Clear"
	end

	def select(board)
		valid = %w{a b c d e f g h}
		cord_array = []
		while cord_array.empty?
			puts "#{@name}'s Turn, select a piece to move, 'save' to save the game and exit, or 'resign' to quit."

			while cord_array.empty?
				move = gets.downcase.chomp
				input_array = move.split(//)			
				if valid.include?(input_array[0]) && input_array[1].to_i > 0 && input_array[1].to_i < 9
					cord_array = [valid.index(input_array[0]), input_array[1].to_i - 1]
				elsif input_array.join == "resign"
					cord_array.push(:resign)
				elsif input_array.join == "save"
					cord_array.push(:resign)
				else
					puts "Please input a valid location e.g. 'g6'"
				end
			end

			if cord_array.length == 2
				unless board[[cord_array[0],cord_array[1]]].color == @color
					puts "Please select a valid piece."
					cord_array = []
				end
			end
		end
		cord_array
	end

	def move(valid_moves)
		puts "Enter a location to move piece, or 'back' to select another."

		valid = %w{a b c d e f g h}
		cord_array = []
		while cord_array.empty?
			while cord_array.empty?
				move = gets.downcase.chomp
				input_array = move.split(//)
				if valid.include?(input_array[0]) && input_array[1].to_i > 0 && input_array[1].to_i < 9
					cord_array = [valid.index(input_array[0]), input_array[1].to_i - 1]
				elsif input_array.join == "back"
					cord_array.push(:back)
				else
					puts "Please input a valid location."
				end
			end

			if cord_array.length == 2
				unless valid_moves.include?(cord_array)
					puts "Please select a valid move."
					cord_array = []
				end
			end
		end
		cord_array
	end

end

class MainGame 
	def initialize
		@board = ChessBoard.new
		@p_black = Player.new(true)
		@p_white = Player.new(false)
	end

	def local_game
		# DEFINE START PARAMS HERE
		player_flag = false #Sets white as first player. Flip to start as black
		game_end = false
		turn_counter = 1

		until game_end
			player = player_switch(player_flag)
			if @board.checkmate?(player.color) == false
				game_end = turn_loop(player)
				turn_counter += 1
				player_flag = !player_flag
			elsif @board.checkmate?(player.color) == :draw
				@board.clear_movement_highlight
				@board.display
				puts "Stalemate, Draw Game on turn #{turn_counter}"
				game_end = true
			else
				player = player_switch(!player_flag)
				@board.clear_movement_highlight
				@board.display
				puts "Checkmate on turn# #{turn_counter} | #{player.name} wins!!"
 				game_end = true
			end
		end
		puts "** Thanks for playing! **"
	end

	private

	def turn_loop(player)
		player_turn_complete = false
		until player_turn_complete
			@board.clear_movement_highlight
			@board.display
			selected = player.select(@board.piece_loc) #Player selects piece
			
			if selected.length == 2
				valid_moves = @board.piece_loc[selected].moves(selected, @board)
				
				@board.valid_movement_highlight(valid_moves) #updates the display with visual prompt to help player							
				player_turn_complete = move_check(selected, valid_moves, player) #make sure the move isn't putting the player in check and move if it's ok	  
			elsif selected.first == :save
				#Put save code here
			elsif selected.first == :resign
				return true
			end
		end
		return false
	end

	def move_check(selected, valid_moves, player)
		move_ok = false
		move_pos = []
		
		until move_ok || move_pos.first == :back
			move_pos = player.move(valid_moves)
			
			unless move_pos.first == :back				
				move_ok = @board.test_move?(selected,move_pos,player.color)
				if move_ok == false
					puts "Your king is in check! Try something else."
					@board.display
				end
			end
		end

		if move_pos.first != :back			
			@board.move_piece(selected,move_pos)
			piece_conditions(move_pos)
			return true
		end
		false

	end

	def piece_conditions (selected) 
		selected_piece = @board.piece_loc[selected]
		case selected_piece.class.to_s #apply special conditions for pieces
			when "King"
				selected_piece.moved = true
			when "Rook"
				selected_piece.moved = true
			when "Pawn"
				selected_piece.moved = true
			else
				#puts "SOMETHING WENT WRONG BR0"
		end
	end

	def player_switch (player_flag)		
		if player_flag == true
			player = @p_black
		else
			player = @p_white
		end
		player
	end

end



 game = MainGame.new
 game.local_game