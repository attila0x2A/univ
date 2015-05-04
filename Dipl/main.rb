require_relative 'draw.rb'
require_relative 'ellipse.rb'

x = Ellipse.new.tap do |y|
	y.centre=[1,2]
	y.axes=[10,3]
	y.phi = Math::PI/10
end

include Drawer

draw([x, [3,4]])
