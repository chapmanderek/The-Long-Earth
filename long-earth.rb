attr_reader :squaresize, :title_text_size, :square_text_size, :chess_piece_image, :background_color, :player1_color, :player2_color, :redraw, :game

def setup
 	size 1100, 600  
 	@squaresize = 40
 	@title_text_size = 20
 	@square_text_size = 10
 	@background_color = color(100, 100, 100)
 	@current_starting_x = 5
	@current_starting_y = 25
	@board_padding = 25
 	@player1_color = color(255, 10, 10)
 	@player2_color = color(10, 10, 255)
 	background(@background_color)
 	textAlign(CENTER, CENTER)

 	all_args = {"squaresize" => @squaresize, "square_text_size" => @square_text_size, "title_text_size" => @title_text_size}
 	@game = Game.new(all_args)
 	@redraw = true
end

def draw
	if(redraw == true)
  		background(@background_color)
  		@game.print_all_maps()
  		@redraw = false
  	end
end

class Game
	attr_reader :map_east, :map_datum, :map_west, :all_args, :title_text_size, :squaresize

	def initialize(all_args)
		@all_args = all_args
		@title_text_size = all_args["title_text_size"]
		@squaresize = all_args["squaresize"]
		@map_east = Map.new({"rows" => 5, "cols" => 5, "squaresize" => all_args["squaresize"], "square_text_size" => all_args["square_text_size"]})
		@map_datum = Map.new({"rows" => 10, "cols" => 10, "squaresize" => all_args["squaresize"], "square_text_size" => all_args["square_text_size"]})
		@map_west = Map.new({"rows" => 5, "cols" => 5, "squaresize" => all_args["squaresize"], "square_text_size" => all_args["square_text_size"]})

		setup_all_units_on_maps()
	end

	def place_unit_on_map(args)
		@which_map = args['which_map']

		case @which_map
		when 'east'
			@map_east.place_unit(args)
		when 'datum'
			@map_datum.place_unit(args)
		when 'west'
			@map_west.place_unit(args)
		end
	end

	def print_all_maps()
		@current_starting_x = 5
		@current_starting_y = 25
		@board_padding = 25

		#print earth west
		args = {"starting_x" => @current_starting_x, "starting_y" => @current_starting_y}
		@map_west.print_map(args)
		fill(255, 0, 0)
		textSize(@title_text_size)
		text("Earth West", (@map_west.rows * @squaresize) / 2 + @current_starting_x, @current_starting_y - 15)

		#print earth datum
		@current_starting_x = @map_west.rows * @squaresize + @current_starting_x + @board_padding
		args = {"starting_x" => @current_starting_x, "starting_y" => @current_starting_y}
		@map_datum.print_map(args)
		fill(100,153,0)
		textSize(@title_text_size)
		text("Datum Earth", (@map_datum.rows * @squaresize) / 2 + @current_starting_x, @current_starting_y - 15)

		#print earth east
		@current_starting_x = @map_datum.rows * @squaresize + @current_starting_x + @board_padding
		args = {"starting_x" => @current_starting_x, "starting_y" => @current_starting_y}
		@map_east.print_map(args)
		fill(255,153,150)
		textSize(@title_text_size)
		text("Earth East", (@map_east.rows * @squaresize) / 2 + @current_starting_x, @current_starting_y - 15)
	end

	def print_map(args)  #defunct
		@which_map = args['which_map']

		case @which_map
		when 'east'
			@map_east.print_map()
		when 'datum'
			@map_datum.print_map()
		when 'west'
			@map_west.print_map()
		end
	end

	def move_unit(args)  #need unit name, new x, new y, new map
		@unit_name = args['unit_name']

		#determine which map unit is on
		#get unit from old location --> put into temperorary holder
		#remove unit from old location
		if(@map_west.haveunit?(@unit_name))
			temp_unit_holder = @map_west.get_unit(@unit_name)
			@map_west.remove_unit(@unit_name)
		elsif(@map_datum.haveunit?(@unit_name))
			temp_unit_holder = @map_datum.get_unit(@unit_name)
			@map_datum.remove_unit(@unit_name)
		elsif(@map_east.haveunit?(@unit_name))
			temp_unit_holder = @map_east.get_unit(@unit_name)
			@map_east.remove_unit(@unit_name)
		end
		
		#put into new locatin
		@new_x = args['new_x']
		@new_y = args['new_y']
		@to_map = args['to_map']
		place_unit_on_map({"unit" => temp_unit_holder, "x" => @new_x, "y" => @new_y, "which_map" => @to_map})
	end

	def setup_all_units_on_maps()
		a1 = Human.new({"name" => "A1", "player" => 1})
		place_unit_on_map({"unit" => a1, "x" => 0, "y" => 9, "which_map" => "datum"})
		a2 = Human.new({"name" => "A2", "player" => 1})
		place_unit_on_map({"unit" => a2, "x" => 1, "y" => 9, "which_map" => "datum"})
		a3 = Human.new({"name" => "A3", "player" => 1})
		place_unit_on_map({"unit" => a3, "x" => 2, "y" => 9, "which_map" => "datum"})
		a4 = Human.new({"name" => "A4", "player" => 1})
		place_unit_on_map({"unit" => a1, "x" => 3, "y" => 9, "which_map" => "datum"})
		a5 = Human.new({"name" => "A5", "player" => 1})
		place_unit_on_map({"unit" => a2, "x" => 5, "y" => 9, "which_map" => "datum"})
		a6 = Human.new({"name" => "A3", "player" => 1})
		place_unit_on_map({"unit" => a3, "x" => 6, "y" => 9, "which_map" => "datum"})
		a7 = Human.new({"name" => "A7", "player" => 1})
		place_unit_on_map({"unit" => a1, "x" => 7, "y" => 9, "which_map" => "datum"})
		a8 = Human.new({"name" => "A8", "player" => 1})
		place_unit_on_map({"unit" => a2, "x" => 8, "y" => 9, "which_map" => "datum"})
		a9 = Human.new({"name" => "A9", "player" => 1})
		place_unit_on_map({"unit" => a3, "x" => 9, "y" => 9, "which_map" => "datum"})

		b1 = LongEarther.new({"name" => "B1", "player" => 2})
		place_unit_on_map({"unit" => b1, "x" => 0, "y" => 0, "which_map" => "west"})
		b2 = LongEarther.new({"name" => "B2", "player" => 2})
		place_unit_on_map({"unit" => b1, "x" => 1, "y" => 0, "which_map" => "west"})
		b3 = LongEarther.new({"name" => "B3", "player" => 2})
		place_unit_on_map({"unit" => b1, "x" => 3, "y" => 0, "which_map" => "west"})
		b4 = LongEarther.new({"name" => "B4", "player" => 2})
		place_unit_on_map({"unit" => b1, "x" => 4, "y" => 0, "which_map" => "west"})
		b5 = LongEarther.new({"name" => "B5", "player" => 2})
		place_unit_on_map({"unit" => b1, "x" => 0, "y" => 1, "which_map" => "west"})
		b6 = LongEarther.new({"name" => "B6", "player" => 2})
		place_unit_on_map({"unit" => b1, "x" => 1, "y" => 1, "which_map" => "west"})
		b7 = LongEarther.new({"name" => "B7", "player" => 2})
		place_unit_on_map({"unit" => b1, "x" => 2, "y" => 1, "which_map" => "west"})
		b8 = LongEarther.new({"name" => "B8", "player" => 2})
		place_unit_on_map({"unit" => b1, "x" => 3, "y" => 1, "which_map" => "west"})
		b9 = LongEarther.new({"name" => "B9", "player" => 2})
		place_unit_on_map({"unit" => b1, "x" => 4, "y" => 1, "which_map" => "west"})

		rock = Terrain.new("rock")
		place_unit_on_map({"unit" => rock, "x" => 2, "y" => 0, "which_map" => "datum"})
		place_unit_on_map({"unit" => rock, "x" => 3, "y" => 0, "which_map" => "datum"})
		place_unit_on_map({"unit" => rock, "x" => 4, "y" => 0, "which_map" => "datum"})
		place_unit_on_map({"unit" => rock, "x" => 5, "y" => 0, "which_map" => "datum"})
		place_unit_on_map({"unit" => rock, "x" => 6, "y" => 0, "which_map" => "datum"})
		place_unit_on_map({"unit" => rock, "x" => 2, "y" => 1, "which_map" => "datum"})
		place_unit_on_map({"unit" => rock, "x" => 3, "y" => 1, "which_map" => "datum"})
		place_unit_on_map({"unit" => rock, "x" => 4, "y" => 1, "which_map" => "datum"})
		place_unit_on_map({"unit" => rock, "x" => 5, "y" => 1, "which_map" => "datum"})
		place_unit_on_map({"unit" => rock, "x" => 6, "y" => 1, "which_map" => "datum"})
		place_unit_on_map({"unit" => rock, "x" => 1, "y" => 4, "which_map" => "west"})
		place_unit_on_map({"unit" => rock, "x" => 2, "y" => 4, "which_map" => "west"})
		place_unit_on_map({"unit" => rock, "x" => 3, "y" => 4, "which_map" => "west"})
		place_unit_on_map({"unit" => rock, "x" => 1, "y" => 4, "which_map" => "east"})
		place_unit_on_map({"unit" => rock, "x" => 2, "y" => 4, "which_map" => "east"})
		place_unit_on_map({"unit" => rock, "x" => 3, "y" => 4, "which_map" => "east"})

		p1flag = Flag.new(1)
		place_unit_on_map({"unit" => p1flag, "x" => 4, "y" => 9, "which_map" => "datum"})
		p2flag = Flag.new(2)
		place_unit_on_map({"unit" => p2flag, "x" => 2, "y" => 0, "which_map" => "west"})
	end

	def tests()
		#output should be true --> false --> 0, 2 --> A2
		#puts @map_datum.haveunit?("A1")
		#puts @map_datum.haveunit?("C5")
		#puts @map_datum.unit_location("A3")
		#testunit = @map_datum.get_unit("A2")
		#puts testunit.name

		#output should be datum map, then with datum map and pieces moved around
		#print_map({"which_map" => "datum"})
		#move_unit({"unit_name" => "A1", "new_x" => 2, "new_y" => 2, "to_map" => "datum"})
		#move_unit({"unit_name" => "A2", "new_x" => 4, "new_y" => 5, "to_map" => "datum"})
		#print_map({"which_map" => "west"})
		#print_map({"which_map" => "datum"})
		#print_map({"which_map" => "east"})
	end
end

class Map
	attr_reader :rows, :cols, :map, :squaresize, :square_text_size
#-->
	def initialize(args)
		@rows = args["rows"].to_i
		@cols = args["cols"].to_i
		@map = Array.new(@rows) {Array.new(@cols)}
		@square_text_size = args["square_text_size"]
		@squaresize = args["squaresize"]
	end

	def place_unit(args)
		@unit = args['unit']
		@row = args['y']
		@col = args['x']
		@map[@row][@col] = @unit
	end

	def haveunit?(find_unit)
		have = false
		@find_unit = find_unit

		0.upto(@rows-1) do |x|
			0.upto(@cols-1) do |y|
				if(@map[x][y] != nil)
					if(@map[x][y].name == @find_unit)
						have = true
					end
				end
			end
		end
		return have
	end

	def unit_location(find_unit)
		@find_unit = find_unit

		0.upto(@rows-1) do |x|
			0.upto(@cols-1) do |y|
				if(@map[x][y] != nil)
					if(@map[x][y].name == @find_unit)
						return x, y
					end
				end
			end
		end
		return false, false
	end

	def get_unit(unit_name)
		@unit_name = unit_name
		x, y = unit_location(@unit_name)
		return @map[x][y]
	end

	def remove_unit(unit_name)
		@unit_name = unit_name
		x, y = unit_location(@unit_name)
		@map[x][y] = nil
	end

	def print_map(args)
		@starting_x = args["starting_x"]
		@starting_y = args["starting_y"]
		textSize(@square_text_size)

		0.upto(@rows-1) do |x|
			0.upto(@cols-1) do |y|
					@square_location = {"x" => (x * @squaresize + @starting_x), "y" => (y * @squaresize + @starting_y)}
					if( ( ( (x % 2) == 0) && ( (y % 2) == 0)) || ( ( (x % 2) != 0) && ( (y % 2) != 0) ) )
						fill(255)
						rect(@square_location["x"], @square_location["y"], @squaresize, @squaresize)
						fill(125)
						text("#{x}, #{y}", @square_location["x"] + (@squaresize/2), @square_location["y"] + (@squaresize/2))
					else
						fill(1)
						rect(@square_location["x"], @square_location["y"], @squaresize, @squaresize)
						fill(125)
						text("#{x}, #{y}", @square_location["x"] + (@squaresize/2), @square_location["y"] + (@squaresize/2))
					end	
			end
		end	

=begin
		0.upto(@rows-1) do |x|
			0.upto(@cols-1) do |y|
				if(@map[x][y] == nil)
					print " 0 "
				else
					print @map[x][y].name
					print " "
				end
				print "|"
			end
			puts 
		end
		puts "\n \n"
=end
	end
end

class Unit
	attr_reader :movement_speed, :attack_power, :name, :player
	def initialize(args)
		@name = args['name']
		@movement_speed = 1
		@attack_power = 1
		@player = args['player']
	end
end

class Human < Unit
end

class LongEarther < Unit
end

class Terrain
	attr_reader :name

	def initialize(name)
		@name = name
	end
end

class Flag
	attr_reader :player, :name
	def initialize(player)
		@player = player
		@name = player.to_s + "flag"
	end
end