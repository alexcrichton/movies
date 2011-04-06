s = STDIN.read.split("\n").last.split(' ')
lines = File.read("movies.lst").split("\n")

puts s.map{ |i| lines[i.to_i] }.join("\n")