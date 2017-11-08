require "spec_helper"
require_relative "../lib/game.rb"

describe Game do

  describe "#new" do

    context "when no board seed is passed in" do

      it "creates a Game object with width 1 and height 1 and an empty board" do
        game = Game.new(1, 1)

        expect(game.width).to eq(1)
        expect(game.height).to eq(1)
        expect(game.board).to eq([[false]])
      end

      it "creates a Game object with width 3 and height 3 and an empty board" do
        game = Game.new(3, 3)

        expect(game.width).to eq(3)
        expect(game.height).to eq(3)
        expect(game.board).to eq([
          [false, false, false],
          [false, false, false],
          [false, false, false]
        ])
      end

      it "creates a Game object with width 5 and height 3 and an empty board" do
        game = Game.new(5, 3)

        expect(game.width).to eq(5)
        expect(game.height).to eq(3)
        expect(game.board).to eq([
          [false, false, false, false, false],
          [false, false, false, false, false],
          [false, false, false, false, false]
        ])
      end

    end

    context "when a seeded board is passed in" do

      it "creates a game board matching the passed in board" do
        board = [
          [false, true, false, false, false],
          [false, true, true, true, false],
          [false, false, false, true, false]
        ]
        game = Game.new(5, 3, board: board)

        expect(game.board).to eq(board)
      end

    end

  end

  before :all do
    @game = Game.new(5, 3, board: [
          [false, true, false, false, false],
          [false, true, true, true, false],
          [false, false, false, true, false]
      ])
  end

  describe ".cells" do
    it "should return a flattened array of cells" do
      expect(@game.cells).to eq([false, true, false, false, false, false, true, true, true, false, false, false, false, true, false])
    end
  end

  describe ".cell_at" do
    it "should return the value of the cell" do
      expect(@game.cell_at(0,0)).to be false
      expect(@game.cell_at(0,1)).to be false
      expect(@game.cell_at(0,2)).to be false
      expect(@game.cell_at(1,1)).to be true
      expect(@game.cell_at(2,2)).to be false
      expect(@game.cell_at(3,2)).to be true
    end
  end

  describe ".alive?" do
    it "should return true if the value of the cell is true" do
      expect(@game.alive?(0,0)).to be false
      expect(@game.alive?(0,1)).to be false
      expect(@game.alive?(0,2)).to be false
      expect(@game.alive?(1,1)).to be true
      expect(@game.alive?(2,2)).to be false
      expect(@game.alive?(3,2)).to be true
    end
  end

  describe ".dead?" do
    it "should return true if the value of the cell is false" do
      expect(@game.dead?(0,0)).not_to be false
      expect(@game.dead?(0,1)).not_to be false
      expect(@game.dead?(0,2)).not_to be false
      expect(@game.dead?(1,1)).not_to be true
      expect(@game.dead?(2,2)).not_to be false
      expect(@game.dead?(3,2)).not_to be true
    end
  end

  describe ".mark_alive" do
    it "should set the value of the cell to true" do
      expect(@game.cell_at(0,0)).to be false
      @game.mark_alive(0,0)
      expect(@game.cell_at(0,0)).to be true
    end
  end

  describe ".mark_dead" do
    it "should set the value of the cell to false" do
      @game.mark_alive(0,0)
      expect(@game.cell_at(0,0)).to be true
      @game.mark_dead(0,0)
      expect(@game.cell_at(0,0)).to be false
    end
  end

  describe ".toggle_state" do
    it "should toggle the value of the cell to the inverse" do
      expect(@game.cell_at(0,0)).to be false
      @game.toggle_state(0,0)
      expect(@game.cell_at(0,0)).to be true
      @game.toggle_state(0,0)
      expect(@game.cell_at(0,0)).to be false
    end
  end

  describe ".neighbors" do
    # [false, true, false, false, false],
    # [false, true, true, true, false],
    # [false, false, false, true, false]
    it "should return a list of neighbors" do
      expect(@game.neighbors(1,1)).to eq([false, true, false, false, true, false, false, false])
      expect(@game.neighbors(2,0)).to eq([false, false, true, true, false, true, true, true])
      expect(@game.neighbors(4,2)).to eq([true, false, false, true, false, false, false, false])
      expect(@game.neighbors(2,2)).to eq([true, true, true, false, true, true, false, false])
      @game.mark_alive(0,0)
      expect(@game.neighbors(4,2)).to eq([true, false, false, true, false, false, false, true])
    end
  end

  describe ".next_cell_state" do
    let :spinner_middle do
      Game.new(5, 3, board: [
          [false, false, false, false, false],
          [false, true, true, true, false],
          [false, false, false, false, false]
      ])
    end

    context "when the cell is dead and it has exactly 3 live neighbors" do
      it "should come alive" do
        expect(spinner_middle.next_cell_state(2,0)).to be true
        expect(spinner_middle.next_cell_state(2,2)).to be true
      end
    end

    context "when the cell is dead and it has fewer than 3 live neighbors" do
      it "should stay dead" do
        expect(spinner_middle.next_cell_state(0,2)).to be false
      end
    end

    context "when the cell is alive and it has 2 live neighbors" do
      it "should come alive" do
        expect(spinner_middle.next_cell_state(2,1)).to be true
      end
    end

    context "when the cell is alive and it has 3 live neighbors" do
      it "should come alive" do
        test_game = Game.new(5, 3, board: [
            [false, false, false, false, false],
            [true, true, true, true, false],
            [false, true, false, false, false]
        ])
        expect(test_game.next_cell_state(1,1)).to be true
      end
    end

    context "when the cell is alive and it has fewer than 2 live neighbors" do
      it "should die" do
        expect(spinner_middle.next_cell_state(1,1)).to be false
      end
    end

    context "when the cell is alive and it has more than 3 live neighbors" do
      it "should die" do
        test_game = Game.new(5, 3, board: [
            [false, false, false, false, false],
            [true, true, true, true, false],
            [false, true, true, false, false]
        ])
        expect(test_game.next_cell_state(1,2)).to be false
      end
    end

  end

  describe ".next_state" do
    let :spinner_middle do
      Game.new(5, 3, board: [
          [false, false, false, false, false],
          [false, true, true, true, false],
          [false, false, false, false, false]
      ])
    end

    let :spinner_top do
      Game.new(5, 3, board: [
          [false, true, true, true, false],
          [false, false, false, false, false],
          [false, false, false, false, false]
      ])
    end

    let :spinner_side do
      Game.new(5, 3, board: [
          [false, false, false, false, true],
          [false, false, false, false, true],
          [false, false, false, false, true]
      ])
    end

    it "returns the next game state" do
      expect(spinner_middle.next_state).to eq([
          [false, false, true, false, false],
          [false, false, true, false, false],
          [false, false, true, false, false]
      ])

      expect(spinner_top.next_state).to eq([
          [false, false, true, false, false],
          [false, false, true, false, false],
          [false, false, true, false, false]
      ])

      expect(spinner_side.next_state).to eq([
          [true, false, false, true, true],
          [true, false, false, true, true],
          [true, false, false, true, true]
      ])
    end
  end

  describe ".advance" do
    let :spinner_middle do
      Game.new(5, 3, board: [
          [false, false, false, false, false],
          [false, true, true, true, false],
          [false, false, false, false, false]
      ])
    end

    it "advances the game state and updates the internal board to the next_state" do
      spinner_middle.advance
      expect(spinner_middle.board).to eq([
          [false, false, true, false, false],
          [false, false, true, false, false],
          [false, false, true, false, false]
      ])

      spinner_middle.advance
      expect(spinner_middle.board).to eq([
          [false, true, true, true, false],
          [false, true, true, true, false],
          [false, true, true, true, false]
      ])
    end
  end

end
