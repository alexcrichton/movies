require 'socket'
require 'rubygems'
require 'timeout'
require 'net/ssh'
require 'highline/import'

hosts = []
time  = 10
depth = 7
ticket = (ARGV[0] || 0).to_i

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

max = File.readlines('movies.lst').size + 1
lock = Mutex.new

threads = []

hosts.each do |host|
  threads << Thread.start {
    Net::SSH.start(host, user, :password => password) do |ssh|
      root = nil
      loop {
        lock.synchronize {
          root = ticket
          ticket += 1
        }
        break if ticket > max
        cmd = "cd movies && nice ./find #{root} #{time} #{depth}"
        ssh.exec!(cmd) do |channel, stream, data|
          puts "#{host}: #{stream}(#{root}/#{ticket}) => #{data}"
        end
      }
    end
  }
end

threads.each(&:join)
