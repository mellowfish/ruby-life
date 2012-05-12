#! /usr/bin/env ruby

require 'terminfo'

def clear()
	puts "e[H\e[2J"
end

def show(board) 
  clear
  board.each do |row|
    puts row.map{|cell|" +#"[cell]}.join
  end
end

def alive?(cell)
  cell==2?1:0 
end

def count_neighbors(board, x, y)
  right_edge = board[0].length-1;
  bottom_edge = board.length-1
  _x = (x > 0)?(x - 1):right_edge
  x_ = (x < right_edge)?(x+1):0
  _y = (y > 0)?(y - 1):bottom_edge
  y_ = (y < bottom_edge)?(y + 1):0
  
  alive?(board[_y ][_x ]) + alive?(board[_y ][ x ]) + alive?(board[_y ][ x_]) + \
  alive?(board[ y ][_x ])                           + alive?(board[ y ][ x_]) + \
  alive?(board[ y_][_x ]) + alive?(board[ y_][ x ]) + alive?(board[ y_][ x_])
end

def step(board)
  board.each_with_index.map do |row,y|
    row.each_with_index.map do |cell,x|
      neighbors = count_neighbors board, x, y
      case(cell)
      when 2
        case(neighbors) 
        when 2,3 
          2
        else
          1
        end
      when 0,1
        neighbors==3?2:0
      end
    end
  end
end

def rand_life(total=7,alive=6)
  if rand(total) < alive
    0
  else
    2
  end
end

def gen_world(width, height)
  world=[]
  height.times do
    row=[]
    width.times do
      row << rand_life
    end
    world << row
  end
  world
end

height, width = TermInfo.screen_size
world = gen_world width, (height - 1)
loop do
	show world
	world = step world
	sleep 0.05
end
