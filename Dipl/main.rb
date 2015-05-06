require_relative 'draw.rb'
require_relative 'p_stat.rb'
require_relative 'ellipse.rb'

include Drawer

p1 = Array.new(20) { Array.new(2) { Random.rand(10).to_f } }
p2 = Array.new(20) { Array.new(2) { Random.rand(10).to_f } }
#el1 = petunin(p1)#.inject([]) { |sum,x| sum + [x[0].get_draw_data] }
#el2 = petunin(p2)
#p p_stat(el1,el2)
p p_stat(p1, p2)

#test_data = points.map { |y| [y] }
#draw(els + test_data)
