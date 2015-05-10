#1:
#
#def make_seq(str)
#	m = {
#		'A' => [1.0,0.8],
#		'G' => [1.0,0.6],
#		'C' => [1.0,0.4],
#		'T' => [1.0,0.2]
#	}
#	p = [0]*2
#	arr = []
#	str.chars.each do |c|
#		p = p.zip(m[c]).to_a.map { |x,y| x+y }
#		arr << p
#	end
#	arr
#end


#2:

def make_seq(str)
	m = {
		'A' => [1.0,0.8],
		'G' => [1.0,0.6],
		'C' => [1.0,0.4],
		'T' => [1.0,0.2]
	}
	xs = []
	ys = []
	yn = 0
	lst = 0;
	str.chars.each do |c|
		lst = lst+m[c][0]
		xs << lst
		yn = yn+m[c][1]
		ys << m[c][1]
	end
	n = str.size
	p = []
	xs.zip(ys) do |x,y|
		p << (x-y) / ((n*(n+1)/2) - yn)
	end
	p
end
