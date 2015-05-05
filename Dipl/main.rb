require_relative 'test.rb'
require_relative 'ellipse.rb'

x = Ellipse.new.tap do |y|
	y.centre=[1,2]
	y.axes=[10,3]
	y.phi = Math::PI/10
end

include Drawer
points = Array.new(20) { Array.new(2) { Random.rand(10).to_f } }
test_data = points.map { |y| [y] }
rect = petunin(points)
draw(rect)
#draw(test_data)
