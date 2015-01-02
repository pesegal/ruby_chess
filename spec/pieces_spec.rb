require 'spec_helper'

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
