require 'rspec'
require "pry"


class World < Array

  def initialize(x_dim, y_dim, seed_probabily)
    @x_dim, @y_dim = x_dim, y_dim
    @cells = Array.new(@y_dim) {
      Array.new(@x_dim) { 
        Cell.new(seed_probabily) 
      } 
    }
  end

  def cells
    @cells    
  end

  def alive_neighbors(y, x)
    [[-1,-1], [-1, 0], [-1, 1],
     [0, -1],          [0,  1],
     [1, -1], [1,  0], [1,  1]].inject(0) do |sum, position|
      sum + @cells[(y + position[0]) % @y_dim][(x + position[1]) % @x_dim].to_i
    end
  end

  def step!
    @cells.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        cell.neighbors = alive_neighbors(y, x)
      end
    end
    @cells.each do |row|
      row.each do |cell|
        cell.step!
      end
    end
  end
end

class Cell
  attr_writer :neighbors

  def initialize(seed_probabily)
    @alive = seed_probabily < rand
  end

  def to_i
    @alive ? 1 : 0
  end

  def to_s
    @alive ? 'O' : ' '    
  end
end

describe 'the game of life' do 

  describe 'class initialization' do

    it 'world initialization should take dimensions, seed probability and return an array' do
      world = World.new(10, 10, 0.5)

      world.should be_an_instance_of(World)
    end

    it 'cell initialization should take seed probability' do
      cell = Cell.new(0.5)

      cell.should be_an_instance_of(Cell)
    end
  end

  describe 'world methods' do

    it '#alive_neighbors(coordinates) should return number of live neighbors to cell at coordinates' do
      world = World.new(5, 5, 1)
      world.cells[1][1] = 1
      world.alive_neighbors(1, 1).should eq 0
      world.cells[1][0] = 1
      world.alive_neighbors(1, 1).should eq 1
      world.cells[0][1] = 1
      world.alive_neighbors(1, 1).should eq 2
    end

    it '#cells should return an array of the cells in the world' do
      world = World.new(5, 5, 1)

      world.cells.should be_an_instance_of(Array)
      world.cells[1][1] = 1
      world.cells.should be_an_instance_of(Array)
    end

    describe '#step! method' do

      it 'should apply rule 1 of the game' do
        world = World.new(5, 5, 1)
        world.cells[1][1] = 1
        world.step!
        world.cells[1][1].to_i.should eq 0
      end
    end
  end

  describe 'cell methods' do

    it '#to_i should return 1 or 0 depending on life status of the cell' do
      cell_1 = Cell.new(0)
      cell_2 = Cell.new(1)

      cell_1.to_i.should eq 1
      cell_2.to_i.should eq 0
    end

    it '#to_s should return "O" or " " depending on the life status of the cell' do
      cell_1 = Cell.new(0)
      cell_2 = Cell.new(1)

      cell_1.to_s.should eq "O"
      cell_2.to_s.should eq " "
    end
  end
end