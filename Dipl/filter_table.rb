while line = gets
	arr = line.split(' ').map do |x|
		x.to_f > 0 ? x.to_f.round(5).to_s : x
	end
	puts arr.join(' ')
end
