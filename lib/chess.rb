require_relative 'main'
menu = 0
game = MainGame.new

def host_setup(game)
	menu = 0
	while menu != 3
		puts "** HOST A GAME **"
		puts "1. HOST NEW GAME"
		puts "2. HOST SAVED GAME"
		puts "3. BACK"

		menu = gets.chomp

		case menu.to_i
		when 1
			game.server_game
		when 2
			load = game.loadgame
	 		game.server_game(2000, load[0],load[1])
		when 3
			menu = menu.to_i
		else
			puts "Please select a choice."
		end
	end 
end

def client_setup(game)
	puts "** JOIN A GAME **"
	puts "Enter Host's IP Address or 'back'"
	ip = gets.chomp.downcase
	valid = ip_valid?(ip)
	while valid == false && ip != "back"
	p "Please enter valid ip address or 'back'"
	ip = gets.chomp.downcase
	valid = ip_valid?(ip)
	end

	if valid == true
		game.client_game(ip)
	end

end

def ip_valid?(ip)
	arr = ip.split(".")
	if arr.length == 4
		return true
	else
		return false
	end
end

while menu != 5
	puts "** RUBY CHESS **"
	puts "1. NEW GAME"
	puts "2. LOAD GAME"
	puts "3. NETWORKED GAME"
	puts "4. HELP & INFO"
	puts "5. EXIT"
	menu = gets.chomp

	case menu.to_i
	when 1		
	  game.local_game
	when 2
	  load = game.loadgame
	  game.local_game(load[0],load[1])
	when 3
		menu = 0
		while menu != 3
			puts "** RUBY CHESS MULTIPLAYER **"
			puts "1. HOST GAME"
			puts "2. JOIN GAME"
			puts "3. BACK"
			menu = gets.chomp
			case menu.to_i
			when 1
				host_setup(game)
			when 2
				client_setup(game)
			when 3
				menu = menu.to_i
			else
				puts "Please select a choice."
			end

		end	
	when 4
		puts "\n** HELP & INFORMATION **\n\n"
		puts "To castle select rook first then move on top of king."
		puts "When a pawn is moved to the other side of the board there will be a prompt for pawn promotion.\n\n"
		puts "Default networking port is 2000. You might need to port forward to connect correctally."
	when 5
		menu = menu.to_i
	else
		puts "Please select a choice."
	end
end

