
class Ellipse
	attr_accessor :centre, :axes, :phi

	def _initialize
		@centre = [0,0]
		@axes = [0,0]
		@phi = 0
	end

	def get_draw_data
		x = []
		y = []
		a = @axes[0]
		b = @axes[1]
		cphi = Math.cos(@phi)
		sphi = Math.sin(@phi)
		t = 0
		while t <= 2*Math::PI
			x << @centre[0] + a*Math.cos(t) * cphi - b*Math.sin(t) * sphi
			y << @centre[1] + a*Math.cos(t) * sphi + b*Math.sin(t) * cphi
			t += 0.01
		end
		[x,y]
	end

end
