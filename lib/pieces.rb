class Piece

	attr_accessor :sym, :color

	def initialize
		@sym = " "
	end

	def moves(pos, board)
		@board = board
		@pos = pos
		@valid_moves = []

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

	def moves(x, y, board)
		super(x, y, board)

	end
end

class Queen < Piece
	attr_reader :color

	def initialize(color)
		@color = color		
		@sym = color == true ? "\u265B" : "\u2655"
	end

	def moves(x, y, board)
		super(x, y, board)	
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

	def moves(x, y, board)
		super(x, y, board)	
	end
end

class Bishop < Piece
	attr_reader :color

	def initialize(color)
		@color = color
		@sym = color == true ? "\u265D" : "\u2657"
	end

	def moves(x, y, board)
		super(x, y, board)	
	end
end

class Knight < Piece
	attr_reader :color

	def initialize(color)
		@color = color
		@sym = color == true ? "\u265E" : "\u2658"
	end

	def moves(x, y, board)
		super(x, y, board)	
	end
end

class Pawn < Piece
	attr_reader :color, :move
	attr_accessor :move

	def initialize(color)
		@color = color
		@sym = color == true ? "\u265F" : "\u2659"
		@move = false
	end

	def moves(pos, board)
		super
		if color == true 
			if @move == false
				@valid_moves.push([@pos[0], @pos[1]-2])
			end
			@valid_moves.push([@pos[0],@pos[1]-1])
		else
			if @move == false
				@valid_moves.push([@pos[0], @pos[1]+2])
			end
			@valid_moves.push([@pos[0],@pos[1]+1])
		end	
		@valid_moves.each do |cord|
			if @board[cord].class != Piece
				@valid_moves.delete(cord)
			end
		end
		@valid_moves
	end

	def attack(x,y, board)

	end
end