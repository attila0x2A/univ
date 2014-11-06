require 'matrix'
require_relative 'vars.rb'

class Collocation
  include Vars

  private 
    def build_system
      n = @number_of_collocation_points
      matr = []
      b = []
      h = (@b-@a)/(n.to_f+1)
      xs = (1..n).to_a.map { |i| @a + i*h }
      xs.each.with_index do |x|
        row = []
        n.times do |i|
          row << lhs(i,x)
        end
        matr << row
        b << rhs(x)
      end
      [matr,b]
    end
end

