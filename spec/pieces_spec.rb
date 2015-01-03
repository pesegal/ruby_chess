require 'spec_helper'

describe King do
	let(:board)  { ChessBoard.new }
	let(:emptyb) { board.piece_loc.each_key { |key| board.piece_loc[key] = Piece.new }}
	let(:king) { King.new(false) }

	describe "#moves" do
		it "returns no moves when on normal start" do
			array = king.moves([4,0],board.piece_loc)
			expect(array.length).to eql 0
		end

		it  "returns 8 when centered on empty board" do
			emptyb[[3,3]] = king
			array = king.moves([3,3],emptyb)
			expect(array.length).to eql 8
		end

		it  "returns 3 when in corner on empty board" do
			emptyb[[0,0]] = king
			array = king.moves([0,0],emptyb)
			expect(array.length).to eql 3
		end

		it "includes attackable pieces" do
			emptyb[[0,0]] = king
			emptyb[[0,1]] = Pawn.new(true)
			array = king.moves([0,0],emptyb)
			expect(array.length).to eql 3
		end

	end
end

describe Queen do
	let(:board)  { ChessBoard.new }
	let(:emptyb) { board.piece_loc.each_key { |key| board.piece_loc[key] = Piece.new }}
	let(:queen) { Queen.new(false) }

	describe "#moves" do
		it "returns no moves when on normal start" do
			array = queen.moves([3,0],board.piece_loc)
			expect(array.length).to eql 0
		end

		it  "returns 27 when centered on empty board" do
			emptyb[[3,3]] = queen
			array = queen.moves([3,3],emptyb)
			expect(array.length).to eql 27
		end

		it  "returns 21 when in corner on empty board" do
			emptyb[[0,0]] = queen
			array = queen.moves([0,0],emptyb)
			expect(array.length).to eql 21
		end

		it "includes attackable pieces" do
			emptyb[[0,0]] = queen
			emptyb[[0,3]] = Pawn.new(true)
			array = queen.moves([0,0],emptyb)
			expect(array.length).to eql 17
		end

	end
end


describe Rook do
	let(:board)  { ChessBoard.new }
	let(:emptyb) { board.piece_loc.each_key { |key| board.piece_loc[key] = Piece.new }}
	let(:rook) { Rook.new(false) }

	describe "#moves" do
		it "returns no moves when on normal start" do
			array = rook.moves([0,0],board.piece_loc)
			expect(array.length).to eql 0
		end

		it  "returns 14 when centered on empty board" do
			emptyb[[3,3]] = rook
			array = rook.moves([3,3],emptyb)
			expect(array.length).to eql 14
		end

		it  "returns 14 when in corner on empty board" do
			emptyb[[0,0]] = rook
			array = rook.moves([0,0],emptyb)
			expect(array.length).to eql 14
		end

		it "includes attackable pieces" do
			emptyb[[0,0]] = rook
			emptyb[[0,3]] = Pawn.new(true)
			array = rook.moves([0,0],emptyb)
			expect(array.length).to eql 10
		end

	end
end

describe Bishop do
	let(:board)  { ChessBoard.new }
	let(:emptyb) { board.piece_loc.each_key { |key| board.piece_loc[key] = Piece.new }}
	let(:bishop) { Bishop.new(false) }

	describe "#moves" do
		it "returns no moves when on normal start" do
			array = bishop.moves([2,0],board.piece_loc)
			expect(array.length).to eql 0
		end

		it  "returns 13 when centered on empty board" do
			emptyb[[3,3]] = bishop
			array = bishop.moves([3,3],emptyb)
			expect(array.length).to eql 13
		end

		it  "returns 7 when in corner on empty board" do
			emptyb[[7,7]] = bishop
			array = bishop.moves([7,7],emptyb)
			expect(array.length).to eql 7
		end

		it "includes attackable pieces" do
			emptyb[[0,0]] = bishop
			emptyb[[3,3]] = Pawn.new(true)
			array = bishop.moves([0,0],emptyb)
			expect(array.length).to eql 3
		end

	end
end

describe Knight do
	let(:board)  { ChessBoard.new }
	let(:emptyb) { board.piece_loc.each_key { |key| board.piece_loc[key] = Piece.new }}
	let(:knight) { Knight.new(false) }

	context "no attackable pieces" do
		describe "#moves" do
			it "returns 8 places if nothing is blocking" do				
				array = knight.moves([4,4],emptyb)
				expect(array.length).to eql 8
			end

			it "returns 2 if the knight is in the corner" do
				array = knight.moves([0,0],emptyb)
				expect(array.length).to eql 2
			end

			it "returns 4 if at [4,2]" do
				array = knight.moves([4,2],board.piece_loc)
				expect(array.length).to eql 4
			end
		end
	end

	context "attackable pieces" do
		describe "#moves" do
			it "returns 8 places if at [4,4]" do
				array = knight.moves([4,4],board.piece_loc)
				expect(array.length).to eql 8
			end

			it "returns 7 when friendly piece in move zone" do
				board.piece_loc[[5,2]] = Rook.new(false)
				array = knight.moves([4,4],board.piece_loc)
				expect(array.length).to eql 7
			end
		end
	end
end

describe Pawn do
	let(:board) { ChessBoard.new }

	context "no attackable pieces" do
		describe "#moves" do
			it "returns two positions if it has not moved." do
				array = board.piece_loc[[1,1]].moves([1,1], board.piece_loc)
				expect(array.length).to eql 2
			end

			it "returns one position if it has moved" do
				board.piece_loc[[1,1]].moved = true
				array = board.piece_loc[[1,1]].moves([1,1], board.piece_loc)
				expect(array.length).to eql 1
			end

			it "returns one position if there are same team pieces in attack squares" do
				board.piece_loc[[1,1]].moved = true
				board.piece_loc[[0,2]] = Pawn.new(false)
				board.piece_loc[[2,2]] = Pawn.new(false)
				array = board.piece_loc[[1,1]].moves([1,1], board.piece_loc)
				expect(array.length).to eql 1
			end

			it "returns no positions if there is a blocking piece" do
				board.piece_loc[[1,2]] = Pawn.new(true)
				array = board.piece_loc[[1,1]].moves([1,1], board.piece_loc)
				expect(array.length).to eql 0
			end
		end
	end

	context "attackable pieces" do
		describe "#moves" do
			it "returns 3 positions if there is an attackable piece" do 
				board.piece_loc[[2,2]] = Rook.new(true)
				array = board.piece_loc[[1,1]].moves([1,1], board.piece_loc)
				expect(array.length).to eql 3
			end

			it "returns 4 positions if there are 2 attackable pieces" do
				board.piece_loc[[0,2]] = Pawn.new(true)
				board.piece_loc[[2,2]] = Rook.new(true)
				array = board.piece_loc[[1,1]].moves([1,1], board.piece_loc)
				expect(array.length).to eql 4
			end			
		end
	end
end
