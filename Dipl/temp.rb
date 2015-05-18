fd = File.open('res_fin.csv')
all = []
cur = []
while line = fd.gets
	if line.to_i > 0
		all << cur if cur.size > 0
		cur = []
	else
		cur << line.split(',').map { |x| (Float(x) != nil rescue false) ? x.to_f : x }
	end
end
all << cur

all.each do |cur|
	print '\begin{tabular}{|c|c|c|c|c|c|c|}' + "\n"
	puts '\hline'
	cur.each do |r|
		r.each do |x|
			if x.is_a? Numeric
				print("%0.10f & " % x)
			else
				print("#{x} & ")
			end
		end
		print '\\\\ \hline' + "\n"
	end
	print '\end{tabular}' + "\n"
end
