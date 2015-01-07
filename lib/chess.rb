require_relative 'main'
menu = 0
game = MainGame.new

while menu != 4
	puts "** RUBY CHESS **"
	puts "1. NEW GAME"
	puts "2. LOAD GAME"
	puts "3. NETWORKED GAME"
	puts "4. EXIT"
	menu = gets.chomp


	case menu.to_i
	when 1		
	  game.local_game
	when 2
	  load = game.loadgame
	  game.local_game(load[0],load[1])
	when 3
		# Todo

	when 4
		menu = menu.to_i
	else
	puts "Please select a choice."
	end
end


