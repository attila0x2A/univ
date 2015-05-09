require_relative 'draw.rb'
require_relative 'p_stat.rb'
require_relative 'ellipse.rb'

def make_seq(str)
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
	arr
end

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

matr = [['-']+spec]
(0..spec.size-1).each do |i|
	row = []
	row << spec[i]
	(i+1).times { row << '-' }
	(i+1..spec.size()-1).each do |j|
		t1 = make_seq(gen[spec[i]])
		t2 = make_seq(gen[spec[j]])
		puts "#{t1.size()} & #{t2.size()}"
		stat = p_stat(t1, t2)
		row << stat
		puts "#{spec[i]} , #{spec[j]}  : #{stat}"
	end
	matr << row
end

matr.each do |row|
	row.each { |el| print "#{el}, " }
	print "\n"
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
