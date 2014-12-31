class Piece

	attr_accessor :sym

	def initialize
		@sym = " "
	end

	def moves(x, y, board)
		@board = board
		@pos = [x, y]
		@valid_moves = []
	end

end

class King < Piece
	attr_reader :color

	def initialize(color)
		@color = color
		@sym = color == true ? "\u265A" : "\u2654"
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

	def initialize(color)
		@color = color
		@sym = color == true ? "\u265C" : "\u2656"
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
	attr_reader :color

	def initialize(color)
		@color = color
		@sym = color == true ? "\u265F" : "\u2659"
	end

	def moves(x, y, board)
		super(x, y, board)	
	end
end