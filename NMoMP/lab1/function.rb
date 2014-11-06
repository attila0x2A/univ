class Function
  attr_accessor :title, :func, :from, :to, :n

  def initialize
    @title = "Unchanged"
    @func = nil
    @from = -1
    @to = 1
    @n = 100
  end

  def plot_data(plot)
    case @func
    when String
      plot.xrange "[#{@from}:#{@to}]"
      plot.data << Gnuplot::DataSet.new( @func ) do |ds|
        ds.title = @title
      end
    when Proc
      h = (@to - @from) / @n.to_f
      xs = (0..n).map { |i| @from + i*h }
      ys = xs.map { |x| @func.call(x) }
      plot.data << Gnuplot::DataSet.new( [xs,ys] ) do |ds|
        ds.title = @title
        ds.with = 'lines'
      end
    end
  end
end
