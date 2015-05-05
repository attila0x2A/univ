require_relative 'ellipse.rb'
require 'cairo'


module Drawer
	private
	def path(*pairs)
		@cr.move_to(*pairs[0])
		pairs.each do |c|
			@cr.line_to(*c)
		end
		@cr.close_path
	end

	public

	# arr = [[xi,yi]]
	# todo
	#  add margin
	#  take account that y is in unnatural dir
	def draw(arr)
		exit(1) unless arr.is_a? Array

		xs = []
		ys = []
		arr.each do |a|
			a.each do |x,y|
				xs << x
				ys << y
			end
		end
		minX, maxX = xs.minmax
		minY, maxY = ys.minmax

		w = h = 768
		#margin = 50
		surface = Cairo::ImageSurface.new(w,h)
		@cr = Cairo::Context.new(surface)
		@cr.scale(w, h)
		nw = maxX - minX
		nh = maxY - minY
		@cr.scale(1.0 / nw, 1.0 / nh)
		@cr.translate(-minX, -minY)

		@cr.set_line_cap(Cairo::LINE_CAP_ROUND)

		# Background
		@cr.set_source_rgba([0,0,0])
		@cr.paint

		arr.each do |obj|
			color = obj.size == 1 ? [0,255,0] : [255,255,255]
			width = obj.size == 1 ? 0.2 : 0.02
			@cr.set_source(color)
			@cr.set_line_width(width)
			@cr.stroke_preserve
			path(*obj)
			@cr.stroke
		end

		@cr.target.write_to_png("test.png")

	end
end

