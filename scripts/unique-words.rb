p File.read('movies.lst').split("\n").map{ |s| s.split(' ') }.flatten.uniq.size