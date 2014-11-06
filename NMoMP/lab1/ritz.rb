require_relative 'vars.rb'

class Ritz
  include Vars
  def p(x)
    0
  end

  private 
    def build_system
      n = @number_of_collocation_points
      matr = []
      b = []
      n.times do |j|
        row = []
        n.times do |i|
          func = lambda { |x| lhs(i,x)*phi(j,x) }
          row << integrate(@a,@b, &func)
        end
        func = lambda { |x| rhs(x)*phi(j,x) }
        b << integrate(@a, @b, &func)
        matr << row
      end
      [matr,b]
    end

end
