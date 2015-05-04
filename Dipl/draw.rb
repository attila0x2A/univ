require_relative 'ellipse.rb'
#require_relative 'exept.rb'
require 'gnuplot.rb'

module Drawer
	def draw(objs)
		Gnuplot.open { |gp|
			Gnuplot::Plot.new( gp ) { |plot|
				#plot.output "testgnu.pdf"
				#plot.terminal "pdf colour size 27cm,19cm"
				#plot.xrange "[-10:10]"
				#plot.title  "Sin Wave Example"

				plot.ylabel "x"
				plot.xlabel "y"

				objs.each do |obj|
					if obj.is_a? Ellipse
						plot.data << Gnuplot::DataSet.new(obj.get_draw_data) do |ds|
							ds.with = "lines"
							ds.linewidth = 2
						end
					elsif obj.is_a?(Array) && obj.size == 2
						plot.data << Gnuplot::DataSet.new([[obj[0]], [obj[1]]]) do |ds|
							ds.with = "linespoints"
							ds.linewidth = 2
						end
					else
						throw Exeption.new("Ah!:(")
					end
				end

			}
		}
	end
end
