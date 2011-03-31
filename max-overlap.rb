words = File.read('movies.lst').split("\n").reject{ |s| s == '' }
@hash = {}
words.map!{ |w|
  ary = w.split(' ')
  ary.each{ |s|
    if @hash[s.hash] && @hash[s.hash] != s
      raise 'foo'
    end
    @hash[s.hash] = s
  }
  ary.map{ |s| s.hash }
}

@max_length = 0
@max_words = []

def overlap w1, w2
  (1..w1.length).each { |i|
    equal = true
    (0...i).each{ |j|
      if w1[w1.length - i + j] != w2[j]
        equal = false
        break
      end
    }
    next unless equal
    
    if i > @max_length
      @max_length = i
      @max_words = [[w1.map{ |a| @hash[a] }.join(' '),
                    w2.map{ |a| @hash[a] }.join(' ')]]
    elsif i == @max_length
      @max_words << [w1.map{ |a| @hash[a] }.join(' '),
                    w2.map{ |a| @hash[a] }.join(' ')]
    end
  }
end

words.each_with_index do |s, i|
  puts "#{i}: max:#{@max_length}, words:#{@max_words.inspect}"
  next if s.length < @max_length
  words.each_with_index do |s2, j|
    next if i == j || s2.length < @max_length
    overlap s, s2
  end
end
