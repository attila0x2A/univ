require_relative 'function.rb'
require_relative 'vars.rb'

class Solver
  include Vars

  def step
    return (@b-@a).to_f / @number_of_points if @number_of_points.is_a?(Fixnum) 
    @number_of_points
  end

  def solve
    if @number_of_points.is_a?(Fixnum)
      n = @number_of_points
      h = (@b-@a).to_f / n
    else
      h = @number_of_points
      n = ((@b-@a) / h).to_i + 1
    end
    @xs = []
    n.times { |i| @xs << (@a + i*h) }
    b_plus = lambda do |x|
      0.5*(-p(x) + (p(x)).abs)/k(x)
    end
    b_minus = lambda do |x|
      0.5*(-p(x) - (p(x)).abs)/k(x)
    end
    hi = lambda do |x|
      r = h/2 * (p(x)).abs / k(x)
      1 / (1+r)
      
    end
    phi = lambda do |x|
      0.5*(rhs(x - h/2) + rhs(x + h/2))
    end
    d = lambda do |x|
      0.5*(q(x - h/2) + q(x + h/2))
    end
    a = lambda { |x| k(x-h/2) }
    aa, bb, cc, ff = [[],[],[],[]]
    @xs[1..-2].each do |x|
      aa << (a.call(x) / (h**2) * (hi.call(x) - h*b_minus.call(x)))
      bb << (a.call(x+h) / (h**2) * (hi.call(x) + h*b_plus.call(x)))
      cc << (-aa[-1] - bb[-1] - d.call(x))
      ff << (-phi.call(x))
    end
    ff[0]  = ff[0] - aa[0]*@al
    ff[-1] = ff[-1] - bb[-1]*@ga
    aa[0] = bb[-1] = 0
    @ys = [@al]
    @ys = @ys + progonka(aa,bb,cc,ff)
    @ys << @ga
  end

  def solution
    throw 'No Solution yet' unless @ys
    [@xs, @ys]
  end

  def discrepacy
    res = 0
    @xs.zip(@ys).each do |x,y|
      res += (y - precise_solution().call(x))**2
    end
    res
  end

  private
    # solving equatin of form:
    # a[i]*x[i-1] + c[i]*x[i] + b[i]*x[i+1] = f[i] , i = 0..n
    # in assumtion that a[0] = 0, b[n-1] = 0 where n = c.size
    # Note: x[-1] and x[n] are undefined but coeficient with it are zeros
    def progonka(a,b,c,f)
      a,b,c,f = [a,b,c,f].map { |ar| ar.map(&:to_f) }
      al = [0]
      be = [0]
      n = a.size
      (0..n-1).each do |i|
        al << (-b[i] / (al[i]*a[i] + c[i]))
        be << ((f[i] - a[i] * be[i]) / (a[i] * al[i] + c[i]))
      end
      x = Array.new n
      x[n-1] = ( f[n-1] - a[n-1]*be[n-1] ) / (c[n-1] + a[n-1]*al[n-1])
      (n - 2).downto(0) do |i|
        x[i] = al[i+1]*x[i+1] + be[i+1]
      end
      x
    end
end

# Little test
##x = Solver.new
##a = [0, 3, -4]
##c = [5, -7, 7]
##b = [4, 1, 0]
##f = [13, -14, -29]
##res = x.progonka(a,b,c,f)
##p res
##puts 
##puts (5*res[0] + 4*res[1])
##puts (3*res[0] - 7*res[1] + res[2])
##puts (-4*res[1] + 7*res[2])
