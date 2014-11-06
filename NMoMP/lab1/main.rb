require_relative 'collocation.rb'
require_relative 'drawer.rb'
require_relative 'function.rb'
require_relative 'vars.rb'
require_relative 'ritz.rb'

n = 5
collocation = Collocation.new(n).solve
ritz = Ritz.new(n).solve
drawer = Drawer.new

methods = [ritz, collocation]
methods.each do |m|
  puts "R(#{m.class}) = #{m.discrepacy}"
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

