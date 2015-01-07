require 'spec_helper'

describe King do
	let(:board)  { ChessBoard.new }
	let(:emptyb) { ChessBoard.new(true)}
	let(:king) { King.new(false) }

	describe "#moves" do
		it "returns no moves when on normal start" do
			array = king.moves([4,0],board)
			expect(array.length).to eql 0
		end

		it  "returns 8 when centered on empty board" do
			emptyb.piece_loc[[3,3]] = king
			array = king.moves([3,3],emptyb)
			expect(array.length).to eql 8
		end

		it  "returns 3 when in corner on empty board" do
			emptyb.piece_loc[[0,0]] = king
			array = king.moves([0,0],emptyb)
			expect(array.length).to eql 3
		end

		it "includes attackable pieces" do
			emptyb.piece_loc[[0,0]] = king
			emptyb.piece_loc[[1,1]] = Pawn.new(true)
			array = king.moves([0,0],emptyb)
			expect(array.length).to eql 3
		end

		it "disallows movement into check" do
			emptyb.piece_loc[[2,4]] = king
			emptyb.piece_loc[[1,0]] = Rook.new(true)
			array = king.moves([2,4],emptyb)
			expect(array.length).to eql 5
		end
	end
end

describe Queen do
	let(:board)  { ChessBoard.new }
	let(:emptyb) { ChessBoard.new(true)}
	let(:queen) { Queen.new(false) }

	describe "#moves" do
		it "returns no moves when on normal start" do
			array = queen.moves([3,0],board)
			expect(array.length).to eql 0
		end

		it  "returns 27 when centered on empty board" do
			emptyb.piece_loc[[3,3]] = queen
			array = queen.moves([3,3],emptyb)
			expect(array.length).to eql 27
		end

		it  "returns 21 when in corner on empty board" do
			emptyb.piece_loc[[0,0]] = queen
			array = queen.moves([0,0],emptyb)
			expect(array.length).to eql 21
		end

		it "includes attackable pieces" do
			emptyb.piece_loc[[0,0]] = queen
			emptyb.piece_loc[[0,3]] = Pawn.new(true)
			array = queen.moves([0,0],emptyb)
			expect(array.length).to eql 17
		end

	end
end


describe Rook do
	let(:board)  { ChessBoard.new }
	let(:emptyb) { ChessBoard.new(true)}
	let(:rook) { Rook.new(false) }

	describe "#moves" do
		it "returns no moves when on normal start" do
			array = rook.moves([0,0],board)
			expect(array.length).to eql 0
		end

		it  "returns 14 when centered on empty board" do
			emptyb.piece_loc[[3,3]] = rook
			array = rook.moves([3,3],emptyb)
			expect(array.length).to eql 14
		end

		it  "returns 14 when in corner on empty board" do
			emptyb.piece_loc[[0,0]] = rook
			array = rook.moves([0,0],emptyb)
			expect(array.length).to eql 14
		end

		it "includes attackable pieces" do
			emptyb.piece_loc[[0,0]] = rook
			emptyb.piece_loc[[0,3]] = Pawn.new(true)
			array = rook.moves([0,0],emptyb)
			expect(array.length).to eql 10
		end
	end

	describe "#castle_check" do
		it "returns king's location if true left rook" do
			emptyb.piece_loc[[0,0]] = rook			
			emptyb.piece_loc[[4,0]] = King.new(false)
			expect(rook.castle_check([0,0], emptyb.piece_loc)).to eql [4,0]
		end

		it "returns king's location if true right rook" do
			emptyb.piece_loc[[7,0]] = Rook.new(false) 
			emptyb.piece_loc[[4,0]] = King.new(false)
			expect(rook.castle_check([7,0], emptyb.piece_loc)).to eql [4,0]
		end

		it "returns nothing if a king has moved" do
			emptyb.piece_loc[[7,0]] = rook 
			emptyb.piece_loc[[4,0]] = King.new(false)
			emptyb.piece_loc[[4,0]].moved = true
			expect(rook.castle_check([7,0], emptyb.piece_loc)).to be_nil
		end

		it "returns nothing if the rook has moved" do
			emptyb.piece_loc[[0,0]] = rook
			emptyb.piece_loc[[0,0]].moved = true
			emptyb.piece_loc[[4,0]] = King.new(false)			
			expect(rook.castle_check([0,0], emptyb.piece_loc)).to be_nil
		end

		it "returns nothing if there is a piece between them"  do
			expect(board.piece_loc[[0,0]].castle_check([0,0], board.piece_loc)).to be_nil			
		end

	end
end

describe Bishop do
	let(:board)  { ChessBoard.new }
	let(:emptyb) { ChessBoard.new(true)}
	let(:bishop) { Bishop.new(false) }

	describe "#moves" do
		it "returns no moves when on normal start" do
			array = bishop.moves([2,0],board)
			expect(array.length).to eql 0
		end

		it  "returns 13 when centered on empty board" do
			emptyb.piece_loc[[3,3]] = bishop
			array = bishop.moves([3,3],emptyb)
			expect(array.length).to eql 13
		end

		it  "returns 7 when in corner on empty board" do
			emptyb.piece_loc[[7,7]] = bishop
			array = bishop.moves([7,7],emptyb)
			expect(array.length).to eql 7
		end

		it "includes attackable pieces" do
			emptyb.piece_loc[[0,0]] = bishop
			emptyb.piece_loc[[3,3]] = Pawn.new(true)
			array = bishop.moves([0,0],emptyb)
			expect(array.length).to eql 3
		end

	end
end

describe Knight do
	let(:board)  { ChessBoard.new }
	let(:emptyb) { ChessBoard.new(true)}
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
				array = knight.moves([4,2],board)
				expect(array.length).to eql 4
			end
		end
	end

	context "attackable pieces" do
		describe "#moves" do
			it "returns 8 places if at [4,4]" do
				array = knight.moves([4,4],board)
				expect(array.length).to eql 8
			end

			it "returns 7 when friendly piece in move zone" do
				board.piece_loc[[5,2]] = Rook.new(false)
				array = knight.moves([4,4],board)
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
				array = board.piece_loc[[1,1]].moves([1,1], board)
				expect(array.length).to eql 2
			end

			it "returns one position if it has moved" do
				board.piece_loc[[1,1]].moved = true
				array = board.piece_loc[[1,1]].moves([1,1], board)
				expect(array.length).to eql 1
			end

			it "returns one position if there are same team pieces in attack squares" do
				board.piece_loc[[1,1]].moved = true
				board.piece_loc[[0,2]] = Pawn.new(false)
				board.piece_loc[[2,2]] = Pawn.new(false)
				array = board.piece_loc[[1,1]].moves([1,1], board)
				expect(array.length).to eql 1
			end

			it "returns no positions if there is a blocking piece" do
				board.piece_loc[[1,2]] = Pawn.new(true)
				array = board.piece_loc[[1,1]].moves([1,1], board)
				expect(array.length).to eql 0
			end
		end
	end

	context "attackable pieces" do
		describe "#moves" do
			it "returns 3 positions if there is an attackable piece" do 
				board.piece_loc[[2,2]] = Rook.new(true)
				array = board.piece_loc[[1,1]].moves([1,1], board)
				expect(array.length).to eql 3
			end

			it "returns 4 positions if there are 2 attackable pieces" do
				board.piece_loc[[0,2]] = Pawn.new(true)
				board.piece_loc[[2,2]] = Rook.new(true)
				array = board.piece_loc[[1,1]].moves([1,1], board)
				expect(array.length).to eql 4
			end			
		end
	end
end
