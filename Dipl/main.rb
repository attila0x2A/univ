require_relative 'draw.rb'
require_relative 'p_stat.rb'
require_relative 'ellipse.rb'
require_relative 'trans_dna.rb'

gen = {}
spec = []
test_dir = 'test_data'
test_files = Dir.entries(test_dir)
test_files.each do |file|
	if file[0] != '.'
		gen[file] = File.read(test_dir + '/' + file).lines[1..-1].join.delete("\n")
		spec << file
	end
end

fd = File.open("results", 'w')
METHODS = 7
bad_meth = [2]
#(1..METHODS).each do |meth|
bad_meth.each do |meth|
	matr = [['-']+spec]
	(0..spec.size-1).each do |i|
		row = []
		row << spec[i]
		j=i
		#(i+1).times { row << '-' }
		#(i+1..spec.size()-1).each do |j|
			t1 = make_seq(meth, gen[spec[i]])
			t2 = make_seq(meth, gen[spec[j]])

			if (t1.sort.uniq.size != t1.size ||
					t2.sort.uniq.size != t2.size)
				puts "Method ##{meth} generates sequences with duplicating elements"
			end

			puts "#{t1.size()} & #{t2.size()}"
			stat = p_stat(t1, t2)
			row << stat
			puts "#{spec[i]} , #{spec[j]}  : #{stat}"
		#end
		matr << row
	end

	fd.puts meth
	matr.each do |row|
		row.each { |el| fd.print "#{el}, " }
		fd.print "\n"
	end
end


#p1 = Array.new(20) { Array.new(2) { Random.rand(10).to_f } }
#p2 = Array.new(20) { Array.new(2) { Random.rand(10).to_f } }
#p p_stat(p1, p2)
#
#include Drawer
#points = Array.new(20) { Array.new(2) { Random.rand(10).to_f } }
#test_data = points.map { |y| [y] }
#els = petunin(points).map { |x,y| x }.inject([]) { |sum,x| sum + [x.get_draw_data] }
#draw(els + test_data)
