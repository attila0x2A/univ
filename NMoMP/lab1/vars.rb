module Vars
  attr_reader :a, :b
  def initialize(n)
    init(n)
  end

  def precise_solution
    lambda do |x|
      @a1*x**@n1 + @a2*x**@n2 + @a3*x**@n3 + @a4   
    end
  end

  def solution
    throw 'No Solution yet' unless @cs
    lambda do |x|
      res = 0;
      @cs.each.with_index do |c,i|
        res += c*phi(i,x)
      end
      res
    end
  end

  def solve
    m,b = build_system
    m = Matrix[*m]
    @cs = m.lup.solve(b).to_a
    self
  end

  def discrepacy
    integrate @a, @b do |x|
      res = 0
      @cs.each.with_index do |c,i|
        res += lhs(i,x)*c
      end
      (res - rhs(x))**2
    end
  end

  private
    def init(n)
      @number_of_collocation_points = n
      @a = 2.0
      @b = 5.0
      @b1 = 1.0
      @b2 = 2.0
      @b3 = 1.0
      @c1 = 6.0
      @c2 = 3.0
      @c3 = 1.0
      @d1 = 2.0
      @d2 = 1.0
      @d3 = 2.0
      @k1 = 1.0
      @k2 = 1.0
      @p1 = 1.0
      @p2 = 1.0
      @q1 = 1.0
      @q2 = 0.0
      @a1 = 6.0
      @a2 = 3.0
      @a3 = 1.0
      @a4 = 1.0
      @n1 = 2.0
      @n2 = 1.0
      @n3 = 5.0
      @al = @a1*@a**@n1 + @a2*@a**@n2 + @a3*@a**@n3 + @a4
      @ga = @a1*@b**@n1 + @a2*@b**@n2 + @a3*@b**@n3 + @a4
      @be = (@a1*@n1*@a**(@n1-1) + @a2*@n2*@a**(@n2-1) + @a3*@n3*@a**(@n3-1))
      @de = -(@a1*@n1*@b**(@n1-1) + @a2*@n2*@b**(@n2-1) + @a3*@n3*@b**(@n3-1))
      @aa = @b + @ga*(@b - @a)/(2*@ga + @de*(@b-@a))
      @bb = @a + @al*(@a - @b)/(2*@al - @be*(@a-@b))
      @cs = nil
    end

    def phi(k,x)
      case k
      when 0
        (x-@a)**2 * (x-@aa)
      when 1
        (x-@b)**2 * (x-@bb)
      else
        (x-@a)**k * (x-@b)**2
      end
    end

    def d_phi(k,x)
      case k
      when 0
        (x-@a)**2 + 2*(x-@a)*(x-@aa)
      when 1
        (x-@b)**2 + 2*(x-@b)*(x-@bb)
      else
        k*(x-@a)**(k-1)*(x-@b)**2 + 2*(x-@a)**k * (x-@b)
      end
    end

    def d2_phi(k,x)
      case k
      when 0
        4*(x-@a) + 2*(x-@aa)
      when 1
        4*(x-@b) + 2*(x-@bb)
      else
        k*(k-1)*(x-@a)**(k-2)*(x-@b)**2 + 4*k*(x-@a)**(k-1)*(x-@b) + 2*(x-@a)**k
      end
    end

    def k(x)
      @b1*x**@k1 + @b2*x**@k2 + @b3
    end

    def d_k(x)
      @b1*@k1*x**(@k1-1) + @b2*@k2*x**(@k2-1)
    end

    def p(x)
      @c1*x**@p1 + @c2*x**@p2 + @c3
    end

    def q(x)
      @d1*x**@q1 + @d2*x**@q2 + @d3
    end

    def lhs(k, x)
      -d_k(x)*d_phi(k,x) - k(x)*d2_phi(k,x) + p(x)*d_phi(k,x) + q(x)*phi(k,x)
    end

    def rhs(x)
      -k(x)*(@a1*@n1*(@n1-1)*x**(@n1-2) + @a2*@n2*(@n2-1)*x**(@n2-2) + @a3*@n3*(@n3-1)*x**(@n3-2)) -
        d_k(x)*(@a1*@n1*x**(@n1-1) + @a2*@n2*x**(@n2-1) + @a3*@n3*x**(@n3-1))+
        p(x)*(@a1*@n1*x**(@n1-1) + @a2*@n2*x**(@n2-1) + @a3*@n3*x**(@n3-1))+
        q(x)*(@a1*x**@n1 + @a2*x**@n2 + @a3*x**@n3 + @a4)
    end

    def integrate(a,b, &f)
      n = 1000
      h = (b-a)/n.to_f
      xs = (0..n).to_a.map { |i| a + i*h }
      res = -(f.call(a) + f.call(b))/2.0
      res += xs.reduce { |sum,x| sum + f.call(x) }
      res*h
    end
end
