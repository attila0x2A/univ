require 'gnuplot'
require_relative 'function.rb'

class Drawer
  def initialize
    @fs = []
  end

  def add_function(x)
    unless x.is_a? Function
      throw 'Not a function'
    end
    @fs << x
  end

  def flush
    Gnuplot.open do |gp|
      Gnuplot::Plot.new(gp) do |plot|
        @fs.each do |f|
          f.plot_data(plot)
        end
      end
    end
  end
end
