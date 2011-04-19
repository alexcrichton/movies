# Takes as input a space delimited list of integers and reconstructs this to the
# list of movies. Output is each movie, one on each line

s = STDIN.read.split("\n").last.split(' ')
lines = File.read(File.expand_path("../../movies.lst", __FILE__)).split("\n")

puts s.map{ |i| lines[i.to_i] }.join("\n")