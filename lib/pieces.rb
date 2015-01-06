class Piece
	attr_accessor :sym, :color

	def initialize
		@sym = " "
	end

	def moves(pos, board)
		@board = board.piece_loc
		@pos = pos
		@valid_moves = []
	end

	def pot_attacks(pos, board)
		@board = board.piece_loc
		@pos = pos
	end
end

class King < Piece
	attr_reader :color
	attr_accessor :move  

	def initialize(color)
		@color = color
		@sym = color == true ? "\u265A" : "\u2654"
		@move = false
	end

	def moves(pos, board)
		super
		directions = [[0,1],[1,0],[0,-1],[-1,0],[-1,1],[1,1],[1,-1],[-1,-1]]

		directions.each do |cord|
			x = pos[0]
			y = pos[1]

			x += cord[0]
			y += cord[1]

			if @board[[x,y]].class == Piece
				@valid_moves.push([x,y])
			elsif @board[[x,y]] != nil && @board[[x,y]].color != @color
				@valid_moves.push([x,y])
			end
		end

		#remove moves that would put in check
		checked_pos = board.danger_loc(color)
		@valid_moves.delete_if { |cord| checked_pos.include?(cord) }
		@valid_moves
	end

	def pot_attacks(pos, board)
		super
		directions = [[0,1],[1,0],[0,-1],[-1,0],[-1,1],[1,1],[1,-1],[-1,-1]]
		potential_attk = []
		directions.each do |cord|
			x = pos[0]
			y = pos[1]

			x += cord[0]
			y += cord[1]

			if @board[[x,y]].class == Piece
				potential_attk.push([x,y])
			elsif @board[[x,y]] != nil
				potential_attk.push([x,y])
			end
		end
		potential_attk
	end
end

class Queen < Piece
	attr_reader :color

	def initialize(color)
		@color = color		
		@sym = color == true ? "\u265B" : "\u2655"
	end

	def moves(pos, board)
		super
		directions = [[0,1],[1,0],[0,-1],[-1,0],[-1,1],[1,1],[1,-1],[-1,-1]]

		directions.each do |cord|
			x = pos[0]
			y = pos[1]

			x += cord[0]
			y += cord[1]

			while @board[[x,y]].class == Piece
				@valid_moves.push([x,y])
				x += cord[0]
				y += cord[1]
			end

			if @board[[x,y]] != nil && @board[[x,y]].color != @color
				@valid_moves.push([x,y])
			end
		end
		@valid_moves
	end

	def pot_attacks(pos, board)
		super
		directions = [[0,1],[1,0],[0,-1],[-1,0],[-1,1],[1,1],[1,-1],[-1,-1]]
		potential_attk = []
		directions.each do |cord|
			x = pos[0]
			y = pos[1]

			x += cord[0]
			y += cord[1]

			while @board[[x,y]].class == Piece
				potential_attk.push([x,y])
				x += cord[0]
				y += cord[1]
			end

			if @board[[x,y]] != nil
				potential_attk.push([x,y])
			end
		end
		potential_attk
	end
end

class Rook < Piece 
	attr_reader :color
	attr_accessor :move

	def initialize(color)
		@color = color
		@sym = color == true ? "\u265C" : "\u2656"
		@move = false
	end

	def moves(pos, board)
		super
		directions = [[0,1],[1,0],[0,-1],[-1,0]]

		directions.each do |cord|
			x = pos[0]
			y = pos[1]

			x += cord[0]
			y += cord[1]

			while @board[[x,y]].class == Piece
				@valid_moves.push([x,y])
				x += cord[0]
				y += cord[1]
			end

			if @board[[x,y]] != nil && @board[[x,y]].color != @color
				@valid_moves.push([x,y])
			end
		end
		@valid_moves
	end

	def pot_attacks(pos, board)
		super
		directions = [[0,1],[1,0],[0,-1],[-1,0]]
		potential_attk = []
		directions.each do |cord|
			x = pos[0]
			y = pos[1]

			x += cord[0]
			y += cord[1]

			while @board[[x,y]].class == Piece
				potential_attk.push([x,y])
				x += cord[0]
				y += cord[1]
			end

			if @board[[x,y]] != nil
				potential_attk.push([x,y])
			end
		end
		potential_attk
	end
end

class Bishop < Piece
	attr_reader :color

	def initialize(color)
		@color = color
		@sym = color == true ? "\u265D" : "\u2657"
	end

	def moves(pos, board)
		super
		directions = [[-1,1],[1,1],[1,-1],[-1,-1]]
		directions.each do |cord|
			x = pos[0]
			y = pos[1]

			x += cord[0]
			y += cord[1]

			while @board[[x,y]].class == Piece
				@valid_moves.push([x,y])
				x += cord[0]
				y += cord[1]
			end

			if @board[[x,y]] != nil && @board[[x,y]].color != @color
				@valid_moves.push([x,y])
			end
		end
		@valid_moves
	end

	def pot_attacks(pos, board)
		super
		directions = [[-1,1],[1,1],[1,-1],[-1,-1]]
		potential_attk = []
		directions.each do |cord|
			x = pos[0]
			y = pos[1]

			x += cord[0]
			y += cord[1]

			while @board[[x,y]].class == Piece
				potential_attk.push([x,y])
				x += cord[0]
				y += cord[1]
			end

			if @board[[x,y]] != nil
				potential_attk.push([x,y])
			end
		end
		potential_attk
	end
end

class Knight < Piece
	attr_reader :color

	def initialize(color)
		@color = color
		@sym = color == true ? "\u265E" : "\u2658"
	end

	def moves(pos, board)
		super
		check_space = [[pos[0]-1,pos[1]+2], [pos[0]+1,pos[1]+2], [pos[0]+2,pos[1]+1], [pos[0]+2,pos[1]-1], [pos[0]+1,pos[1]-2], [pos[0]-1,pos[1]-2], [pos[0]-2,pos[1]-1], [pos[0]-2,pos[1]+1]]
		
		check_space.each do |cord|
			if @board[cord].class == Piece || (@board[cord] != nil && @board[cord].color != @color)
				@valid_moves.push(cord)
			end
		end
		@valid_moves
	end

	def pot_attacks(pos, board)
		super
		potential_attk = []
		check_space = [[pos[0]-1,pos[1]+2], [pos[0]+1,pos[1]+2], [pos[0]+2,pos[1]+1], [pos[0]+2,pos[1]-1], [pos[0]+1,pos[1]-2], [pos[0]-1,pos[1]-2], [pos[0]-2,pos[1]-1], [pos[0]-2,pos[1]+1]]
		check_space.each do |cord|
			if @board[cord] != nil
				potential_attk.push(cord)
			end
		end
		potential_attk
	end
end

class Pawn < Piece
	attr_reader :color
	attr_accessor :moved

	def initialize(color)
		@color = color
		@sym = color == true ? "\u265F" : "\u2659"
		@moved = false
	end

	def moves(pos, board)
		super
		if color == true 
			if @moved == false && @board[[@pos[0], @pos[1]-1]].class == Piece
				@valid_moves.push([@pos[0], @pos[1]-2])
			end
			@valid_moves.push([@pos[0],@pos[1]-1])
		else
			if @moved == false && @board[[@pos[0], @pos[1]+1]].class == Piece
				@valid_moves.push([@pos[0], @pos[1]+2])
			end
			@valid_moves.push([@pos[0],@pos[1]+1])
		end	
		@valid_moves.each do |cord|
			if @board[cord].class != Piece
				@valid_moves.delete(cord)
			end
		end

		# Check for attackable pieces
		valid_attacks = attacks(@pos, @board)
		valid_attacks.each { |cord|	@valid_moves.push(cord) }
		
		@valid_moves
	end

	def attacks (pos, board)
		valid_attacks = []
		if @color == true
			check_space = [[pos[0]-1,pos[1]-1],[pos[0]+1,pos[1]-1]]
			check_space.each do |cord|
				if board[cord].class != Piece && board[cord] != nil && board[cord].color == false
					valid_attacks.push(cord)
				end	
			end			
		else
			check_space = [[pos[0]-1,pos[1]+1],[pos[0]+1,pos[1]+1]]
			check_space.each do |cord|
				if board[cord].class != Piece && board[cord] != nil && board[cord].color == true
					valid_attacks.push(cord)
				end	
			end
		end
		valid_attacks
	end

	def pot_attacks(pos, board)
		super
		potential_attk = []
		if @color == true
			check_space = [[pos[0]-1,pos[1]-1],[pos[0]+1,pos[1]-1]]
			check_space.each do |cord|
				if @board[cord] != nil
					potential_attk.push(cord)
				end	
			end			
		else
			check_space = [[pos[0]-1,pos[1]+1],[pos[0]+1,pos[1]+1]]
			check_space.each do |cord|
				if @board[cord] != nil
					potential_attk.push(cord)
				end	
			end
		end
		potential_attk
	end
end