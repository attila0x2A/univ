require_relative 'drawer.rb'
require_relative 'function.rb'
require_relative 'solver.rb'

drawer = Drawer.new
#output = File.open("output", "w")

m = Solver.new
res = m.solve
res[0..-1].each do |rr|
  func = Function.new.tap do |x|
    x.from = 0
    x.to = 1
    x.func = rr
  end
  drawer.add_function(func)
end

drawer.flush

