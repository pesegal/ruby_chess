require_relative 'board'
require 'pstore'
require 'socket'

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
					cord_array.push(:save)
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

	# Networked game loops
	def server_game(port = 2000, player_flag = false, board_locations = nil)

		board_deserialization(board_locations) if board_locations != nil

		server = TCPServer.open(port)
		p "SERVER STARTED AWATING CONNECTION..."
		client = server.accept
		puts "Success! Connected to: #{client.peeraddr[3]}"
		client.puts "Success! Connected to: #{IPSocket.getaddress(Socket.gethostname)}"
		#Game Loop Start
		game_end = false
		first_move = true 
		until game_end
			if first_move && player_flag == false
				game_state = turn_loop(@p_white, true)
				if game_state == :resign || game_state == :save
					game_end = true
				end
				send = game_state.to_s + ":"
				send << board_serialization
				client.puts send

				first_move = false
			elsif first_move && player_flag == true
				# @board.display
				# puts "Waiting for player to move..."
				send = game_state.to_s + ":"
				send << board_serialization
				client.puts send
				first_move = false
			else				
				game_end = network_loop(client, @p_white, @p_black)			
			end			
		end
		puts "** Game over! Thanks for playing! **\n\n"
		server.close

		p "end of connection for server"
	end

	def client_game(host = 'localhost', port = 2000)
		puts "JOINING..."
		s = TCPSocket.new(host,port)
		puts s.gets.chomp

		#Game Loop Start
		game_end = false
		until game_end
			game_end = network_loop(s, @p_black, @p_white)						
		end
		puts "** Game over! Thanks for playing! **\n\n"
		s.close
		p "connection closed for client"
	end

	def network_loop(net, player, opponent)
		game_end = false
		@board.clear_movement_highlight
		@board.display
		puts "Waiting for other player to move..."
		received = net.gets
		puts "Move received!"	
		received = received.split(":")		
		case received[0]
		when "resign"
			@board.clear_movement_highlight
			@board.display
			puts "Client has resigned the game, you win."
			game_end = true
		when "save"
			@board.clear_movement_highlight
			@board.display
			puts "Client has saved the game. To continue host or join from saved game."
			board_deserialization(received[1])
			save_game(opponent)
			game_end = true
		when "draw"
			@board.clear_movement_highlight
			@board.display
			puts "Game ended in a draw."
			game_end = true
		when "checkmate"
			@board.clear_movement_highlight
			@board.display
			puts "Checkmate! You win congratulations!"
			game_end = true
		else
			board_deserialization(received[1])

			if @board.checkmate?(player.color) == false
				game_state = turn_loop(player, true)
			elsif @board.checkmate?(player.color) == :draw
				@board.clear_movement_highlight
				@board.display
				puts "Game ended in a draw."
				game_state = :draw
				game_end = true
			else
				@board.clear_movement_highlight
				@board.display
				puts "Checkmate! You have lost."
				game_state = :checkmate
				game_end = true
			end

			game_end = true if game_state == :resign || game_state == :save

			send = game_state.to_s + ":"
			send << board_serialization << "\n"
			net.puts send
			game_end
		end
	end

	# Local Game Loop
	def local_game (player_flag = false, board_locations = nil)
		# DEFINE START PARAMS HERE
		#Sets white as first player. Flip to start as black
		board_deserialization(board_locations) if board_locations != nil
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
		puts "** Thanks for playing! **\n\n"
	end

	#Save and load Functions
	def loadgame
		loadgame = []
		store = PStore.new("savedgame.pstore")
		store.transaction do
			loadgame = store[:game]
		end
		loadgame
	end

	def save_game(player) 
		store = PStore.new("savedgame.pstore")
		store.transaction do
			store[:game] = Array.new
			store[:game].push(player.color)
			store[:game].push(board_serialization)
		end
	end

	private

	def turn_loop(player, network = false)
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
				save_game(player)
				puts "Game saved on: #{player.name}'s turn!!"
				return :save if network
				return true
			elsif selected.first == :resign
				player = player_switch(!player.color)
				puts "You have conceded, #{player.name} wins!!"
				return :resign if network
				return true
			end
		end
		return :continue if network
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

	def board_serialization
		ser_array = []
		@board.piece_loc.each do |key, value|
			#cord
			string = key.join
			#Type
			case value.class.to_s
			when "Piece"
				string << "0"
			when "King"
				string << "1"
			when "Queen"
				string << "2"
			when "Rook"
				string << "3"
			when "Bishop"
				string << "4"
			when "Knight"
				string << "5"
			when "Pawn"
				string << "6"
			end
			#color
			if value.color
				string << "1"
			else
				string << "0"
			end
			#moved
			if value.class == King || value.class == Rook || value.class == Pawn
				if value.moved
					string << "1"
				else
					string << "0"
				end
			end
			string << " "
			ser_array.push(string)
		end
		ser_array.join
	end

	def board_deserialization(string)
		blocks = string.split
		blocks.each do |block|
			piece_code = block.split(//)
			color = nil
			piece = nil
			
			if piece_code[3] == "0"
				color = false
			else
				color = true
			end

			case piece_code[2]
			when "0"
				piece = Piece.new
			when "1"
				piece = King.new(color)
				piece.moved = true if piece_code[4] == "1"
			when "2"
				piece = Queen.new(color)
			when "3"
				piece = Rook.new(color)
				piece.moved = true if piece_code[4] == "1"
			when "4"
				piece = Bishop.new(color)
			when "5"
				piece = Knight.new(color)
			when "6"
				piece = Pawn.new(color)
				piece.moved = true if piece_code[4] == "1"
			end
			x = piece_code[0].to_i
			y = piece_code[1].to_i
			@board.piece_loc[[x,y]] = piece
		end
	end
end
