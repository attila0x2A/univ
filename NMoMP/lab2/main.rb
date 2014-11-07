require_relative 'drawer.rb'
require_relative 'function.rb'
require_relative 'vars.rb'
require_relative 'solver.rb'

#n = ARGV.size > 0 ? ARGV[0].to_i : 10000
drawer = Drawer.new
output = File.open("output", "w")

m = Solver.new 0.01
m.solve

xs, ys = m.solution
us = xs.map { |x| m.precise_solution.call(x) }

output.puts m.step
xs.zip(ys, us) do |x,y,u|
  output.puts "%2.12f %2.12f %2.12f %2.12f" %  [x,y,u,y-u]
end
output.close

func = Function.new.tap do |x|
  x.from = m.a
  x.to = m.b
  x.func = m.solution
  x.title = m.class
end
exact = Function.new.tap do |x|
  x.from = m.a
  x.to = m.b
  x.func = m.precise_solution
  x.title = "#{m.class} precise"
end
drawer.add_function(func)
drawer.add_function(exact)

drawer.flush

