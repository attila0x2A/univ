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

data = {}
all.each.with_index do |cur,num|
	ind = {}
	cur[0].each.with_index do |x,i|
		if x != '-'
			data[x.strip] = {}
			ind[i-1] = x.strip
		end
	end

	p num+1
	cur[1..-1].each do |ar|
		item = ar[0]
		ar[1..-1].each.with_index do |x,i|
			if x!='-'&&x!="-\n"
				data[item][ind[i]] = x
			else
				#data[item]
			end
		end
	end
	
	res = {}

	data.each do |k,v|
		v.each do |k1,d|
			res[d] = [k,k1]
		end
	end
	keys = res.keys
	keys.sort.each do |k|
		puts res[k][0]+' '+res[k][1]+' '+k.to_s
	end
	puts '-'*72
end
