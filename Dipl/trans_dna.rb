
def make_seq(meth,str)
	if meth == 1
		#DNA sequence comparison by a novel probabilistic method
		#1:
		m = {
			'A' => [1.0,0.8],
			'G' => [1.0,0.6],
			'C' => [1.0,0.4],
			'T' => [1.0,0.2]
		}
		p = [0]*2
		arr = []
		str.chars.each do |c|
			p = p.zip(m[c]).to_a.map { |x,y| x+y }
			arr << p
		end
		return arr

	elsif meth == 2
		#2:
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
		return p

	elsif meth == 3
		#2D-dynamic representation of DNA sequences
		#3:
		m = {
			'A' => [-1.0, 0.0],
			'G' => [1.0 , 0.0],
			'C' => [0.0 , 1.0],
			'T' => [0.0 ,-1.0]
		}
		p = [0]*2
		arr = []
		str.chars do |c|
			p = p.zip(m[c]).to_a.map { |a,b| a+b }
			arr << p
		end
		return arr
	elsif meth == 4
		#4:
		#(Hurst) Analysis of Similarity-Dissimilarity of DNA Sequences Based on Chaos Game Representation.pdf
		m = {
			'A' => [0.0, 0.0],
			'C' => [0.0, 1.0],
			'T' => [1.0, 0.0],
			'G' => [1.0, 1.0]
		}
		p = [0.5]*2
		arr = []
		str.chars do |c|
			vec = p.zip(m[c]).to_a.map { |a,b| b-a }.map { |x| x/2 }
			p = p.zip(vec).to_a.map{ |a,b| a+b }
			arr << p
		end
		return arr

	elsif meth == 5
		#5:
		m = {
			'A' => [0.0, 0.0],
			'C' => [0.0, 1.0],
			'T' => [1.0, 0.0],
			'G' => [1.0, 1.0]
		}
		p = [0.5]*2
		arr = []
		acc = [0]*2
		str.chars do |c|
			vec = p.zip(m[c]).to_a.map { |a,b| b-a }.map { |x| x/2 }
			p = p.zip(vec).to_a.map{ |a,b| a+b }
			acc = acc.zip(p).to_a.map { |a,b| a+b }
			arr << acc
		end
		return arr

	elsif meth == 6
		#6:
		m = {
			'A' => [0.0, 0.0],
			'C' => [0.0, 1.0],
			'T' => [1.0, 0.0],
			'G' => [1.0, 1.0]
		}
		pp = [0.5]*2
		arr = []
		str.chars do |c|
			vec = pp.zip(m[c]).to_a.map { |a,b| b-a }.map { |x| x/2 }
			pp = pp.zip(vec).to_a.map{ |a,b| a+b }
			arr << (pp[0]+pp[1])
		end
		return arr

	elsif meth == 7
		#7:ALGORITHM FOR CODING DNA SEQUENCES
		m = {
			'A' => -1.0,
			'C' => -1.0,
			'T' => 1.0,
			'G' => 1.0
		}
		arr = []
		p = 0
		str.chars do |c|
			d = (m[c] - p).abs/2
			p += m[c] > 0 ? d : -d
			arr << p;
		end
		return arr

	end
end
