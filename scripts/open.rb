require 'socket'
require 'rubygems'
require 'timeout'
require 'net/ssh'
require 'highline/import'

hosts = []
time  = 7

['unix%02d.andrew.cmu.edu', 'ghc%02d.ghc.andrew.cmu.edu'].each do |pat|
  (0..99).each{ |i|
    host = pat % i
    puts "Trying: #{host}"
    begin
      Timeout::timeout(0.5) { TCPSocket.new(host, 22).close }
      hosts << host
    rescue Timeout::Error, SocketError
    end
  }
end

puts "Available hosts: #{hosts.inspect}"

user     = ask('User: ')
password = ask('Password: ') { |q| q.echo = '*' }

max = File.readlines('movies.lst').size + 10
size = max / hosts.size

threads = []

hosts.each_with_index do |host, i|
  start = i * size
  last  = start + size - 1

  threads << Thread.start {
    Net::SSH.start(host, user, :password => password) do |ssh|
      (start..last).each { |index|
        printf "%s: %.02f%% done\n", host, ((index - start).to_f / size) * 100
        puts "#{host}: on #{index} in (#{start} - #{last})"
        cmd = "cd movies && nice ./find #{index} #{time}"
        ssh.exec!(cmd) do |channel, stream, data|
          puts "#{host}: #{stream} => #{data}"
        end
      }
    end
  }
end

threads.each(&:join)
