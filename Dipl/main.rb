require_relative 'draw.rb'
require_relative 'ellipse.rb'

x = Ellipse.new.tap do |y|
	y.centre=[1,2]
	y.axes=[10,3]
	y.phi = Math::PI/10
end

test_data = Array.new(2) { Array.new(20) { Random.rand(10) } }

include Drawer

draw([x, test_data])
