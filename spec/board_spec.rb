require 'spec_helper'

describe ChessBoard do
	let (:board) {ChessBoard.new}

	describe "#danger_loc" do

		it "returns an array of potential attackable positions of white" do
			array = board.danger_loc(true)
			expect(array.length).to eql 22
		end

		it "returns an array of potential attackable positions of black" do
			array = board.danger_loc(false)
			expect(array.length).to eql 22
		end


	end
end 