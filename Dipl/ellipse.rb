
class Line
	attr_accessor :a, :b, :c

	def initialize(*args)
		x,y = args
		if x.nil? || y.nil?
			@a = @b = @c = 0
		else
			@a = y[1] - x[1]
			@b = x[0] - y[0]
			@c = x[1]*(y[0] - x[0]) - x[0]*(y[1] - x[1])
		end
	end

	def parallel(x)
		l1 = Line.new
		l1.a = @a
		l1.b = @b
		l1.c = -@a*x[0] - @b*x[1]
		l1
	end

	def orthogonal(x)
		l1 = Line.new
		l1.a = @b
		l1.b = -@a
		l1.c = -l1.a*x[0] - l1.b*x[1]
		l1
	end

	def dev(x)
		d = @a * x[0] + @b * x[1] + @c
		d > 0 ? 1
		: d < 0 ? -1
		: 0
	end

	def dist(x)
		(@a * x[0] + @b * x[1] + c).abs / Math.sqrt(@a**2 + @b**2)
	end
end

class Ellipse
	attr_accessor :centre, :axes, :phi

	def initialize
		@centre = [0,0]
		@axes = [0,0]
		@phi = 0
	end

	def rotate(phi)
		@phi -= phi
		x = @centre[0]
		y = @centre[1]
		cphi = Math.cos(phi)
		sphi = Math.sin(phi)
		@centre = [ x*cphi + y*sphi,
							  -x*sphi + y*cphi]
	end

	def translate(dx,dy)
		@centre = [@centre[0] + dx, @centre[1] + dy]
	end

	def scale(kx,ky)
		@axes = [@axes[0] * kx, @axes[1] * ky]
		@centre = [@centre[0] * kx, @centre[1] * ky]
	end

	def get_draw_data
		res = []
		a = @axes[0]
		b = @axes[1]
		cphi = Math.cos(@phi)
		sphi = Math.sin(@phi)
		t = 0
		while t <= 2*Math::PI
			x = @centre[0] + a*Math.cos(t) * cphi - b*Math.sin(t) * sphi
			y = @centre[1] + a*Math.cos(t) * sphi + b*Math.sin(t) * cphi
			res << [x,y]
			t += 0.01
		end
		res
	end
end

def dist(x,y)
	Math.sqrt((y[0]-x[0])**2 + (y[1]-x[1])**2)
end

def diameter(points)
	best = [0, [], []]
	points.each do |x|
		points.each do |y|
			if best[0] < dist(x,y)
				best = [dist(x,y), x, y]
			end
		end
	end
	[best[1], best[2]]
end

def farthest(line, points, dev)
	exit 1 unless line.is_a? Line
	best = [0, []]
	points.each do |x|
		tmp = line.dev(x)
		if (tmp == 0 || tmp == dev) && line.dist(x) > best[0]
			best = [line.dist(x), x]
		end
	end
	best[1]
end

def intersect(l1,l2)
	if l1.a == 0
		l1,l2 = l2,l1
	end
	tmp = l2.b*l1.a - l2.a*l1.b
	if tmp == 0 || l1.a == 0
		exit 1
	end
	y = (l2.a * l1.c - l1.a * l2.c) / tmp
	x = (-l1.c - l1.b * y) / l1.a
	[x,y]
end

def find_rect(points)
	x0,y0 = diameter(points)
	line = Line.new(x0,y0)
	x = farthest(line, points, 1)
	y = farthest(line, points, -1)
	lx = line.parallel(x)
	ly = line.parallel(y)
	lx0 = line.orthogonal(x0)
	ly0 = line.orthogonal(y0)
	[intersect(lx, lx0),
	intersect(lx0, ly),
	intersect(ly, ly0),
	intersect(ly0, lx),
	]
end

def translate(points,dx,dy)
	points.map do |x|
		x = [x[0]+dx, x[1]+dy]
	end
end

def rotate(points, phi)
	cphi = Math.cos(phi)
	sphi = Math.sin(phi)
	points.map do |p|
		x = p[0]
		y = p[1]
		[ x*cphi + y*sphi,
		-x*sphi + y*cphi]
	end
end

def scale(points,kx,ky)
	points.map do |x|
		[x[0]*kx, x[1]*ky]
	end
end

def get_transf_coef(rect)
	x = rect[0]
	rect[1..-1].each do |y|
		if (y[1] < x[1] || y[1] == x[1] && y[0] < x[0])
			x = y
		end
	end
	i = rect.index(x)
	j = (i+1) % rect.size
	k = (i-1) % rect.size
	if rect[j][0] < rect[k][0]
		j = k;
	end
	y = rect[j]
	vec = y.zip(x).to_a.map { |a,b| a-b }
	phi = Math.acos(vec[0] / dist(vec, [0,0]))

	a = dist(rect[0], rect[1])
	b = dist(rect[1], rect[2])
	coef = a/b
	if (b - dist(vec, 0) < 1e-6)
		coef = 1.0 / coef
	end

	[x, phi, coef] # traslate, rotate, scale
end

# You should care:
# points must be float!
def petunin(points)
	if points.size() < 4
		puts "Error on #{__LINE__} in #{__FILE__}"
		exit(1)
	end
	#return [x,x0,y,y0]
	rect = find_rect(points)
	dx, phi, coef = get_transf_coef(rect)

	#rect = translate(rect, -dx[0], -dx[1])
	rect = rotate(rect, phi)
	rect = scale(rect, 1.0, coef)

	#points = translate(points, -dx[0], -dx[1])
	points = rotate(points,phi)
	points = scale(points, 1, coef)

	centre = rect[0].zip(rect[2]).to_a.map { |u,v| (u+v)/2 }
	rs = []
	points.each do |p|
		rs << dist(p, centre)
	end
	rs = rs.sort.reverse

	el = Ellipse.new
	el.centre = centre
	el.axes = [rs[0]]*2

	#back
	rect = scale(rect, 1, 1/coef)
	points = scale(points, 1, 1/coef)
	el.scale(1, 1/coef)

	rect = rotate(rect, -phi)
	points = rotate(points, -phi)
	el.rotate(-phi)

	#rect = translate(rect, dx[0], dx[1])
	#points = translate(points, dx[0], dx[1])
	#el.translate(dx[0],dx[1])

	points.map! { |x| [x] }
	
	[el.get_draw_data] + points + [rect]
end
