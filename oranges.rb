class OrangeGrove
  attr_accessor :trees, :total_oranges, :soil_quality

  def initialize
    @trees = [OrangeTree.new]
    @total_oranges = 0
    @soil_quality = 10.0
  end

  def one_year_passes
    @soil_quality = 10.0/@trees.length
    @trees.each do |tree|
      if !tree.dead
        tree.one_year_passes
        if tree.max_age < 120
          tree.max_age += (soil_quality) ** (-1)
        end
        if tree.orangeCount < 400 && !tree.dead
          tree.orangeCount *= (0.1 * ((@soil_quality) ** -1))
          tree.orangeCount = tree.orangeCount.to_i
        end
        tree.height += (@soil_quality) ** (-1)
      end
    end
  end

  def count_all_oranges
    oranges = 0
    @trees.each do |tree|
      oranges += tree.orangeCount
    end
    oranges
  end

  def group_trees
    if @trees.length % 3 > 0
      rows = (@trees.length / 3) + 1
    else
      rows = (@trees.length / 3)
    end
    ts_in_row = []
    (1..rows).each do |num|
      row = @trees[num..num+2]
      ts_in_row << row
    end
    return ts_in_row
  end

  def draw_row(row)
    row_canopy = []
    row_trunk = []
    row.each do |tree|
      row_canopy << compose_canopy(tree)
      row_trunk << compose_soil * 2
      row_trunk << compose_trunk(tree)
      row_trunk << compose_soil * 2
    end
    puts row_canopy.join()
    puts row_trunk.join()
  end

  def compose_canopy(tree)
    if tree.orangeCount < 10
      return "   #{tree.orangeCount}   "
    elsif tree.orangeCount > 99
      return "  #{tree.orangeCount}  "
    else
      return "   #{tree.orangeCount}  "
    end
  end

  def compose_trunk(tree)
    if tree.dead
      return "_!_"
    elsif (tree.age == 1) || (tree.max_age - tree.age == 1)
      return "_1_"
    else
      return "<|>"
    end
  end

  def compose_soil
    if @soil_quality < 0.4
      return "_"
    elsif @soil_quality >= 0.4 && @soil_quality <= 0.6
      return "."
    elsif @soil_quality > 0.6
      return ","
    end
  end


  def to_s
    puts
    puts "_"* 21
    puts
    rows = group_trees
    rows.each do |row|
      draw_row(row)
      puts "_"* 21
      puts
    end
  end

  class OrangeTree
    attr_accessor :height, :age, :orangeCount, :max_age, :dead

    def initialize
      @age = 0
      @height = 1.0
      @orangeCount = 0
      @max_age = 105
      @dead = false
    end

    def plant_on(grove)
      grove.trees << OrangeTree.new
      grove.soil_quality = (10.0 / grove.trees.length)
      if rand(1000) * grove.soil_quality < 75
        grove.trees[-1].dead = true
      end
    end

    def one_year_passes
      @age += 1
      if @age >= @max_age
        @dead = true
      end
      if @height < 35 && !@dead
        height_increase = (-0.0001) * (@age + 44) * (@age - 46) + 1
        if height_increase >= 0
          @height += height_increase
        else
          @height = @height
        end
      end
      if (@age < 5) || @dead
        @orangeCount = 0
      else
        @orangeCount = (-0.07 * (@age - 5) * (@age - 105) + 55).to_i
      end
    end

    def count_the_oranges
      @orangeCount
    end

    def pickAnOrange
      if @orangeCount >0
        @orangeCount -=1
        puts "Yum yum, what a delcious orange!"
      else
        puts "There are no oranges on this tree."
      end
    end

  end

end

og = OrangeGrove.new

puts "How many trees do you want?"
raw_input = gets.chomp
input = raw_input.to_i

if input == 0 && raw_input == "0"
  puts "Why are you running this program then? Toodles!"
  abort
elsif input == 0 && raw_input != "0"
  puts "A number, please. Let's quit and try again."
  abort
end

(1..input - 1).each do
  og.trees[0].plant_on(og)
end

puts "How many years should pass?"
raw_input = gets.chomp
input = raw_input.to_i

if input == 0 && raw_input == "0"
  puts "Why are you running this program then? Toodles!"
  abort
elsif input == 0 && raw_input != "0"
  puts "A number, please. Let's quit and try again."
  abort
end

(1..input).each do
  og.one_year_passes
end

puts "You have #{og.count_all_oranges} oranges."

og.to_s
