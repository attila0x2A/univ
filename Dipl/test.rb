require 'cairo'

w = h = 100
surface = Cairo::ImageSurface.new(w,h)
cr = Cairo::Context.new(surface)

cr.set_source_rgba([0,255,0])
cr.paint

def path(cr,*pairs)
	cr.move_to(*[0,0])
	pairs.each do |c|
		if c == :c
			cr.close_path
		else
			cr.line_to(*c)
		end
	end
end

cr.set_source([255,0,0])
cr.set_line_width(2.2)
cr.stroke_preserve
path(cr, [w/2,0], [2,h], [0,h], :c)
cr.stroke

cr.target.write_to_png("test.png")

