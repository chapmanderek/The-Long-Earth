class Map
	attr_reader :rows, :cols, :map

	def initialize(args)
		@rows = args['rows'].to_i
		@cols = args['cols'].to_i
		@map = Array.new(@rows) {Array.new(@cols)}
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

	def print_map()
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


class Game
	attr_reader :map_east, :map_datum, :map_west

	def initialize()
		@map_east = Map.new({"rows" => 5, "cols" => 5})
		@map_datum = Map.new({"rows" => 10, "cols" => 10})
		@map_west = Map.new({"rows" => 20, "cols" => 20})

		a1 = Unit.new({"name" => "A1", "player" => 1})
		place_unit_on_map({"unit" => a1, "x" => 0, "y" => 0, "which_map" => "datum"})
		a2 = Human.new({"name" => "A2", "player" => 1})
		place_unit_on_map({"unit" => a2, "x" => 0, "y" => 1, "which_map" => "datum"})
		a3 = Human.new({"name" => "A3", "player" => 1})
		place_unit_on_map({"unit" => a3, "x" => 0, "y" => 2, "which_map" => "datum"})
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

	def print_map(args)
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

	def tests()
		#output should be true --> false --> 0, 2 --> A2
		puts @map_datum.haveunit?("A1")
		puts @map_datum.haveunit?("C5")
		puts @map_datum.unit_location("A3")
		testunit = @map_datum.get_unit("A2")
		puts testunit.name

		#output should be datum map, then with datum map and pieces moved around
		print_map({"which_map" => "datum"})
		move_unit({"unit_name" => "A1", "new_x" => 2, "new_y" => 2, "to_map" => "datum"})
		move_unit({"unit_name" => "A2", "new_x" => 4, "new_y" => 5, "to_map" => "datum"})
		print_map({"which_map" => "datum"})
	end
end


game = Game.new()
game.tests()