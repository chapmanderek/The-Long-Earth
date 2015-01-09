attr_reader :background_color, :player1_color, :player2_color, :redraw, :game

def setup
 	size 1100, 600  
 	@background_color = color(100, 100, 100)
 	background(@background_color)
 	textAlign(CENTER, CENTER)

 	@game = Game.new()
 	@redraw = true

 	@player1_color = color(255, 10, 10)
 	@player2_color = color(10, 10, 255)
end

def draw
	if(redraw == true)
  		background(@background_color)
  		@game.print_all_maps()
  		@redraw = false
  	end
end

def mouseClicked
	game.mouse_clicked(mouseX, mouseY)
end

class Game
	BOARD_PADDING = 25
	BOARD_PADDING_Y = 40
	TITLE_TEXT_SIZE = 30
	TITLE_TEXT_Y = 20

	attr_reader :map_east, :map_datum, :map_west

	def initialize()
		@map_east = Map.new({"rows" => 5, "cols" => 5})
		@map_datum = Map.new({"rows" => 10, "cols" => 10})
		@map_west = Map.new({"rows" => 5, "cols" => 5})

		setup_all_units_on_maps()
	end

	def place_unit_on_map(args)
		@which_map = args['which_map']

		case @which_map
		when 'west'
			args["padding_factor"] = (1 * BOARD_PADDING)
			@map_west.place_unit(args)
		when 'datum'
			args["padding_factor"] = (2 * BOARD_PADDING) + (@map_east.rows * Map::SQUARE_SIZE)
			@map_datum.place_unit(args)
		when 'east'
			args["padding_factor"] = (3 * BOARD_PADDING) + (@map_east.rows * Map::SQUARE_SIZE) + (@map_datum.rows * Map::SQUARE_SIZE)
			@map_east.place_unit(args)
		end
	end

	def print_all_maps()
		@current_starting_x = BOARD_PADDING
		@current_starting_y = BOARD_PADDING_Y

		#print earth west
		args = {"starting_x" => @current_starting_x, "starting_y" => @current_starting_y}
		puts "printing west"
		@map_west.print_map(args)
		fill(255, 0, 0)
		textSize(TITLE_TEXT_SIZE)
		text("Earth West", (@map_west.rows * Map::SQUARE_SIZE) / 2 + @current_starting_x, @current_starting_y - TITLE_TEXT_Y)

		#print earth datum
		@current_starting_x = @map_west.rows * Map::SQUARE_SIZE + @current_starting_x + BOARD_PADDING
		args = {"starting_x" => @current_starting_x, "starting_y" => @current_starting_y}
		puts "printing datum"
		@map_datum.print_map(args)
		fill(100,153,0)
		textSize(TITLE_TEXT_SIZE)
		text("Datum Earth", (@map_datum.rows * Map::SQUARE_SIZE) / 2 + @current_starting_x, @current_starting_y - TITLE_TEXT_Y)

		#print earth east
		@current_starting_x = @map_datum.rows * Map::SQUARE_SIZE + @current_starting_x + BOARD_PADDING
		args = {"starting_x" => @current_starting_x, "starting_y" => @current_starting_y}
		puts "printing east"
		@map_east.print_map(args)
		fill(255,153,150)
		textSize(TITLE_TEXT_SIZE)
		text("Earth East", (@map_east.rows * Map::SQUARE_SIZE) / 2 + @current_starting_x, @current_starting_y - TITLE_TEXT_Y)
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
		
		#put into new location
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
		place_unit_on_map({"unit" => a4, "x" => 3, "y" => 9, "which_map" => "datum"})
		a5 = Human.new({"name" => "A5", "player" => 1})
		place_unit_on_map({"unit" => a5, "x" => 5, "y" => 9, "which_map" => "datum"})
		a6 = Human.new({"name" => "A6", "player" => 1})
		place_unit_on_map({"unit" => a6, "x" => 6, "y" => 9, "which_map" => "datum"})
		a7 = Human.new({"name" => "A7", "player" => 1})
		place_unit_on_map({"unit" => a7, "x" => 7, "y" => 9, "which_map" => "datum"})
		a8 = Human.new({"name" => "A8", "player" => 1})
		place_unit_on_map({"unit" => a8, "x" => 8, "y" => 9, "which_map" => "datum"})
		a9 = Human.new({"name" => "A9", "player" => 1})
		place_unit_on_map({"unit" => a9, "x" => 9, "y" => 9, "which_map" => "datum"})

		b1 = LongEarther.new({"name" => "B1", "player" => 2})
		place_unit_on_map({"unit" => b1, "x" => 0, "y" => 0, "which_map" => "west"})
		b2 = LongEarther.new({"name" => "B2", "player" => 2})
		place_unit_on_map({"unit" => b2, "x" => 1, "y" => 0, "which_map" => "west"})
		b3 = LongEarther.new({"name" => "B3", "player" => 2})
		place_unit_on_map({"unit" => b3, "x" => 3, "y" => 0, "which_map" => "west"})
		b4 = LongEarther.new({"name" => "B4", "player" => 2})
		place_unit_on_map({"unit" => b4, "x" => 4, "y" => 0, "which_map" => "west"})
		b5 = LongEarther.new({"name" => "B5", "player" => 2})
		place_unit_on_map({"unit" => b5, "x" => 0, "y" => 1, "which_map" => "west"})
		b6 = LongEarther.new({"name" => "B6", "player" => 2})
		place_unit_on_map({"unit" => b6, "x" => 1, "y" => 1, "which_map" => "west"})
		b7 = LongEarther.new({"name" => "B7", "player" => 2})
		place_unit_on_map({"unit" => b7, "x" => 2, "y" => 1, "which_map" => "west"})
		b8 = LongEarther.new({"name" => "B8", "player" => 2})
		place_unit_on_map({"unit" => b8, "x" => 3, "y" => 1, "which_map" => "west"})
		b9 = LongEarther.new({"name" => "B9", "player" => 2})
		place_unit_on_map({"unit" => b9, "x" => 4, "y" => 1, "which_map" => "west"})

		rock1 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock1, "x" => 2, "y" => 0, "which_map" => "datum"})
		rock2 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock2, "x" => 3, "y" => 0, "which_map" => "datum"})
		rock3 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock3, "x" => 4, "y" => 0, "which_map" => "datum"})
		rock4 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock4, "x" => 5, "y" => 0, "which_map" => "datum"})
		rock5 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock5, "x" => 6, "y" => 0, "which_map" => "datum"})
		rock6 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock6, "x" => 2, "y" => 1, "which_map" => "datum"})
		rock7 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock7, "x" => 3, "y" => 1, "which_map" => "datum"})
		rock8 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock8, "x" => 4, "y" => 1, "which_map" => "datum"})
		rock9 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock9, "x" => 5, "y" => 1, "which_map" => "datum"})
		rock10 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock10, "x" => 6, "y" => 1, "which_map" => "datum"})
		rock11 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock11, "x" => 1, "y" => 4, "which_map" => "west"})
		rock12 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock12, "x" => 2, "y" => 4, "which_map" => "west"})
		rock13 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock13, "x" => 3, "y" => 4, "which_map" => "west"})
		rock14 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock14, "x" => 1, "y" => 4, "which_map" => "east"})
		rock15 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock15, "x" => 2, "y" => 4, "which_map" => "east"})
		rock16 = Terrain.new("rock")
		place_unit_on_map({"unit" => rock16, "x" => 3, "y" => 4, "which_map" => "east"})

		p1flag = Flag.new(1)
		place_unit_on_map({"unit" => p1flag, "x" => 4, "y" => 9, "which_map" => "datum"})
		p2flag = Flag.new(2)
		place_unit_on_map({"unit" => p2flag, "x" => 2, "y" => 0, "which_map" => "west"})
	end

	def mouse_clicked(x, y)
		@board_clicked = nil
		@board_clicked = which_board_was_clicked(x, y)
		if(@board_clicked != nil)
			which_cell_was_clicked(@board_clicked, x, y)
		end
		
	end

	def which_board_was_clicked(x, y)
		@x = x
		@y = y
		@top_left = Array.new(2)
		@bottom_right = Array.new(2)
		@top_left[0] = @map_west.starting_x
		@top_left[1] = @map_west.starting_y
		@bottom_right[0] = @top_left[0] + (@map_west.rows * Map::SQUARE_SIZE)
		@bottom_right[1] = @top_left[1] + (@map_west.cols * Map::SQUARE_SIZE)
		if(x.between?(@top_left[0], @bottom_right[0]) && y.between?(@top_left[1], @bottom_right[1]))
			return "west"
		end
		
		@top_left[0] = @map_datum.starting_x
		@top_left[1] = @map_datum.starting_y
		@bottom_right[0] = @top_left[0] + (@map_datum.rows * Map::SQUARE_SIZE)
		@bottom_right[1] = @top_left[1] + (@map_datum.cols * Map::SQUARE_SIZE)
		if(x.between?(@top_left[0], @bottom_right[0]) && y.between?(@top_left[1], @bottom_right[1]))
				return "datum"
		end	

		@top_left[0] = @map_east.starting_x
		@top_left[1] = @map_east.starting_y
		@bottom_right[0] = @top_left[0] + (@map_east.rows * Map::SQUARE_SIZE)
		@bottom_right[1] = @top_left[1] + (@map_east.cols * Map::SQUARE_SIZE)
		if(x.between?(@top_left[0], @bottom_right[0]) && y.between?(@top_left[1], @bottom_right[1]))
				return "east"
		end	
	end

	def which_cell_was_clicked(board_clicked, x, y)
		@board_clicked = board_clicked
		@click_x = x
		@click_y = y

		if(@board_clicked == "west")
			0.upto(@map_west.rows-1) do |square_x|
				0.upto(@map_west.cols-1) do |square_y|
					if(@map_west.map[square_x][square_y] != nil)						
						if(@click_x.between?(@map_west.map[square_x][square_y].location_on_screen_x, @map_west.map[square_x][square_y].location_on_screen_x + Map::SQUARE_SIZE) && @click_y.between?(@map_west.map[square_x][square_y].location_on_screen_y, @map_west.map[square_x][square_y].location_on_screen_y + Map::SQUARE_SIZE))
							puts "246 clicked map west #{square_x}, #{square_y} unit = #{@map_west.map[square_x][square_y].name}"
						end
					end
				end
			end
		end

		if(@board_clicked == "datum")
			0.upto(@map_datum.rows-1) do |square_x|
				0.upto(@map_datum.cols-1) do |square_y|
					if(@map_datum.map[square_x][square_y] != nil)						
						if(@click_x.between?(@map_datum.map[square_x][square_y].location_on_screen_x, @map_datum.map[square_x][square_y].location_on_screen_x + Map::SQUARE_SIZE) && @click_y.between?(@map_datum.map[square_x][square_y].location_on_screen_y, @map_datum.map[square_x][square_y].location_on_screen_y + Map::SQUARE_SIZE))
							puts "246 clicked map datum #{square_x}, #{square_y} unit = #{@map_datum.map[square_x][square_y].name}"
						end
					end
				end
			end
		end

		if(@board_clicked == "east")
			0.upto(@map_east.rows-1) do |square_x|
				0.upto(@map_east.cols-1) do |square_y|
					if(@map_east.map[square_x][square_y] != nil)						
						if(@click_x.between?(@map_east.map[square_x][square_y].location_on_screen_x, @map_east.map[square_x][square_y].location_on_screen_x + Map::SQUARE_SIZE) && @click_y.between?(@map_east.map[square_x][square_y].location_on_screen_y, @map_east.map[square_x][square_y].location_on_screen_y + Map::SQUARE_SIZE))
							puts "246 clicked map east #{square_x}, #{square_y} unit = #{@map_east.map[square_x][square_y].name}"
						end
					end
				end
			end
		end
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
	SQUARE_SIZE = 40
	SQUARE_TEXT_SIZE = 10
	attr_reader :rows, :cols, :map, :top, :starting_x, :starting_y

	def initialize(args)
		@rows = args["rows"].to_i
		@cols = args["cols"].to_i
		@map = Array.new(@rows) {Array.new(@cols)}
	end

	def place_unit(args)
		@unit = args['unit']
		@row = args['x']
		@col = args['y']
		@factor = args["padding_factor"]
		@location_x = (Map::SQUARE_SIZE * @row) + @factor
		@location_y = (Map::SQUARE_SIZE * @col) + Game::BOARD_PADDING_Y
		@unit.set_location_on_screen(@location_x, @location_y)
		@map[@row][@col] = @unit
		#puts "292 #{@unit.name} square = #{@row}, #{@col}  #{@unit.get_location_on_screen}"
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
		textSize(SQUARE_TEXT_SIZE)

		0.upto(@rows-1) do |x|
			0.upto(@cols-1) do |y|
				@square_location = {"x" => (x * SQUARE_SIZE + @starting_x), "y" => (y * SQUARE_SIZE + @starting_y)}
				if(both_evens_or_odds?(x, y))
					fill_square({"fill" => 255, "x" => x, "y" => y})

				else
					fill_square({"fill" => 1, "x" => x, "y" => y})
				end					
			end
		end	
	end

	def both_evens_or_odds?(x, y)
		(((x % 2) == 0) && ( (y % 2) == 0)) || ( ( (x % 2) != 0) && ( (y % 2) != 0) )
	end

	def fill_square(args)
		fill(args["fill"])
		rect(@square_location["x"], @square_location["y"], SQUARE_SIZE, SQUARE_SIZE)
		fill(125)
		if(@map[args["x"]][args["y"]] != nil)
			puts "square = #{args["x"]}, #{args["y"]} location = #{@map[args["x"]][args["y"]].location_on_screen_x}, #{@map[args["x"]][args["y"]].location_on_screen_y}"
			text(@map[args["x"]][args["y"]].name, @square_location["x"] + (SQUARE_SIZE/2), @square_location["y"] + (SQUARE_SIZE/2) - 10)
			text(@map[args["x"]][args["y"]].location_on_screen_x, @square_location["x"] + (SQUARE_SIZE/2), @square_location["y"] + (SQUARE_SIZE/2))
			text(@map[args["x"]][args["y"]].location_on_screen_y, @square_location["x"] + (SQUARE_SIZE/2), @square_location["y"] + (SQUARE_SIZE/2) + 10)
		end
	end
end

class Game_piece
	attr_reader :location_on_screen_x, :location_on_screen_y

	def initialize(args)
		@location_on_screen_x = 0
		@location_on_screen_y = 0
	end

	def set_location_on_screen(x, y)
		@location_on_screen_x = x
		@location_on_screen_y = y
	end

	def get_location_on_screen
		return @location_on_screen_x, @location_on_screen_y
	end
end

class Unit < Game_piece
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

class Terrain < Game_piece
	attr_reader :name

	def initialize(name)
		@name = name
	end  # <-- refactor to simplify game piece structure and so that they take similar arguments
end

class Flag < Game_piece
	attr_reader :player, :name
	def initialize(player)
		@player = player
		@name = player.to_s + "flag"
	end
end