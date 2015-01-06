require 'spec_helper'

describe ChessBoard do
	let (:board) { ChessBoard.new }
	let (:blank) { ChessBoard.new(true) }

	# describe "#moves" do
	# 	context "pawn_promotion" do
	# 		it "promotes pawn correctally" do
	# 			blank.piece_loc[[1,1]] = Pawn.new(true)
	# 			blank.move_piece([1,1],[1,0])
	# 			allow(blank).to receive(:pawn_promotion) { "\n" }
	# 			expect(blank.piece_loc[[1,0]].class).to eql Queen
	# 		end
	# 	end
	# end


	describe "#checkmate" do
		it "returns true if player is in a checkmate" do
			blank.piece_loc[[7,6]] = King.new(true)
			blank.piece_loc[[7,0]] = Rook.new(false)
			blank.piece_loc[[6,2]] = Queen.new(false)
			expect(blank.checkmate?(true)).to eql true
		end

		it "returns false if king can move out of check" do
			blank.piece_loc[[6,6]] = King.new(true)
			blank.piece_loc[[6,0]] = Rook.new(false)
			blank.piece_loc[[5,2]] = Queen.new(false)
			expect(blank.checkmate?(true)).to eql false
		end

		it "returns false if player can block with another piece" do
			blank.piece_loc[[7,6]] = King.new(true)
			blank.piece_loc[[4,7]] = Bishop.new(true)
			blank.piece_loc[[7,0]] = Rook.new(false)
			blank.piece_loc[[6,2]] = Queen.new(false)
			expect(blank.checkmate?(true)).to eql false
		end

		it "returns false if king can capture piece" do
			blank.piece_loc[[7,6]] = King.new(true)
			blank.piece_loc[[7,0]] = Rook.new(false)
			blank.piece_loc[[6,5]] = Queen.new(false)
			expect(blank.checkmate?(true)).to eql false
		end

		it "returns :draw if it is a stalemate" do
			blank.piece_loc[[7,7]] = King.new(true)
			blank.piece_loc[[5,6]] = Queen.new(false)
			expect(blank.checkmate?(true)).to eql :draw
		end

		it "returns false if not in check" do
			blank.piece_loc[[7,7]] = King.new(true)
			expect(blank.checkmate?(true)).to eql false
		end
	end

	describe "#danger_loc" do
		it "returns an array of potential attackable positions of white" do
			array = board.danger_loc(true)
			expect(array.length).to eql 22
		end

		it "returns an array of potential attackable positions of black" do
			array = board.danger_loc(false)
			expect(array.length).to eql 22
		end

		it "returns the correct number of potential locations" do
			blank.piece_loc[[3,0]] = Rook.new(true)
			blank.piece_loc[[3,4]] = Pawn.new(false)
			array = blank.danger_loc(false)
			expect(array.length).to eql 11
		end
	end

	describe "#in_check?" do
		it "returns true if black king is in check" do
			blank.piece_loc[[0,5]] = King.new(true)
			blank.piece_loc[[0,0]] = Rook.new(false)
			expect(blank.in_check?(true)).to eql true
		end

		it "returns true if white king is in check" do
			blank.piece_loc[[0,5]] = King.new(false)
			blank.piece_loc[[5,0]] = Bishop.new(true)
			expect(blank.in_check?(false)).to eql true
		end

		it "returns false if black or white king is not in check" do
			blank.piece_loc[[0,5]] = King.new(false)
			blank.piece_loc[[5,5]] = King.new(true)
			expect(blank.in_check?(true)).to eql false
			expect(blank.in_check?(false)).to eql false
		end

		it "correctly deals with defender blocks" do
			blank.piece_loc[[3,0]] = Rook.new(true)
			blank.piece_loc[[3,4]] = Pawn.new(false)
			blank.piece_loc[[3,5]] = King.new(false)
			expect(blank.in_check?(false)).to eql false
		end
	end
end 