#!/usr/bin/env ruby

require_relative "lib/game"

# simple cli to run the Game

# Example Input:
# 14  # num_states
# 3 3 # width, height
# 0 0 0
# 0 1 0
# 0 0 0
num_states = $stdin.gets.chomp.to_i
width, height = $stdin.gets.chomp.split(" ").map(&:to_i)

initial_board = []
height.times do
  initial_board << $stdin.gets.chomp.split(" ").map { |c| c == "1" ? true : false }
end

# Main Program

# create the game
game = Game.new(width, height, board: initial_board)

# run the game
num_states.times do
  game.advance
  game.print
end
