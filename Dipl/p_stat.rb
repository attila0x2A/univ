require_relative 'ellipse.rb'

# Takes variation seq with ellipses in 2d
#  si = [[el,pi]]  2d
#  si = [pi]       1d
def p_stat(s1, s2)
	m = 10000
	g = 3.0
	if s1[0].is_a? Array
		s1 = petunin(s1)
		s2 = petunin(s2)
		#Ellipses
		#  n = si.size
		#  Aij in Ej out Ei
		#  pij = (j-1) / (n+1)
		#  pij(1) , pij(2) from hij
		#  hij count Aij in m tests
		#  Iij = (pij(1), pij(2))
		#  L = count Iij : pij in Iij
		#  N = n(n-1)/2
		#  dist = L/N
		n = s1.size
		ll = 0
		n.times do |i|
			(n-i-1).times do |j|
				j += i+1
				elj = s1[j][0]
				eli = s1[i][0]
				h = 0
				m.times do
					k = Random.rand(n)
					x = s2[k][1]
					h += 1 if in_ellipse?(elj,x) && !in_ellipse?(eli,x)
				end
				h = h.to_f/m
				p1 = (h*m + g**2/2-g*Math.sqrt(h*(1-h)*m+g**2/4))/(m+g**2)
				p2 = (h*m + g**2/2+g*Math.sqrt(h*(1-h)*m+g**2/4))/(m+g**2)
				p = (j-i)/(n+1).to_f
				ll += 1 if p1 <= p && p <= p2
			end
		end
		nn = n*(n-1)/2.0
		return ll/nn
	else
		s1.sort!
		s2.sort!
		n = s1.size
		ll = 0
		n.times do |i|
			(n-i-1).times do |j|
				j += i+1
				h = 0
				m.times do
					k = Random.rand(n)
					x = s2[k]
					h += 1 if s1[i] <= x && x <= s1[j]
				end
				h = h.to_f/m
				p1 = (h*m + g**2/2-g*Math.sqrt(h*(1-h)*m+g**2/4))/(m+g**2)
				p2 = (h*m + g**2/2+g*Math.sqrt(h*(1-h)*m+g**2/4))/(m+g**2)
				p = (j-i)/(n+1).to_f
				ll += 1 if p1 <= p && p <= p2
			end
		end
		nn = n*(n-1)/2.0
		return ll/nn
	end
end
