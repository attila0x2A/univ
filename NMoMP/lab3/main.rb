require_relative 'drawer.rb'
require_relative 'function.rb'
require_relative 'solver.rb'

drawer = Drawer.new
#output = File.open("output", "w")

m = Solver.new(1)
res = m.solve(0.5)
puts m.num_of_iter
res = m.solve(1.0)
puts m.num_of_iter
res[0..-1].each do |rr|
  func = Function.new.tap do |x|
    x.from = 0
    x.to = 1
    x.func, x.title = rr
  end
  drawer.add_function(func)
end

drawer.flush

