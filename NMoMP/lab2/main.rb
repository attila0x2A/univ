require_relative 'drawer.rb'
require_relative 'function.rb'
require_relative 'vars.rb'
require_relative 'solver.rb'

n = 100000
drawer = Drawer.new

Solver.new(n).tap do |m|
  m.solve
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
end

drawer.flush

