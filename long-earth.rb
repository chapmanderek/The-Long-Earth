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
				if(@map[x][y] == @find_unit)
					have = true
				end
			end
		end


		return have
	end

	def print_map()
		0.upto(@rows-1) do |x|
			0.upto(@cols-1) do |y|
				if(@map[x][y] == nil)
					print "0"
				else
					print @map[x][y].name
				end
				print "|"
			end
			puts
		end
	end
end

class Unit
	attr_reader :movement_speed, :attack_power, :name
	def initialize(args)
		@name = args['name']
		@movement_speed = 1
		@attack_power = 1
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

		a1 = Unit.new({"name" => "A1"})
		place_unit({"unit" => a1, "x" => 0, "y" => 0, "which_map" => "datum"})
		a2 = Human.new({"name" => "A2"})
		place_unit({"unit" => a2, "x" => 0, "y" => 1, "which_map" => "datum"})
		a3 = Human.new({"name" => "A3"})
		place_unit({"unit" => a3, "x" => 0, "y" => 2, "which_map" => "datum"})
	end

	def place_unit(args)
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

	def move_unit(args)
		@unit = args['unit']
		@new_x = args['new_x']
		@new_y = args['new_y']
		@to_map = args['to_map']
		place_unit({"unit" => @unit, "x" => @new_x, "y" => @new_y, "which_map" => @new_map})

		#need to get rid of unit being held at old location
	end

end


game = Game.new()
game.print_map({'which_map' => "datum"})
#game.move_unit({"unit" => a1, "new_x" => 2, "new_y" => 2, "to_map" => "datum"})