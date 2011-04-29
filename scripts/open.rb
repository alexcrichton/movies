require 'socket'
require 'rubygems'
require 'timeout'
require 'net/ssh'
require 'highline/import'

hosts = [
  'angelshark.ics.cs.cmu.edu',
  'bambooshark.ics.cs.cmu.edu',
  'baskingshark.ics.cs.cmu.edu',
  'blueshark.ics.cs.cmu.edu',
  'carpetshark.ics.cs.cmu.edu',
  'catshark.ics.cs.cmu.edu',
  'hammerheadshark.ics.cs.cmu.edu',
  'houndshark.ics.cs.cmu.edu',
  'lemonshark.ics.cs.cmu.edu',
  'makoshark.ics.cs.cmu.edu'
]

time   = 5
depth  = 10
ticket = (ARGV[0] || 0).to_i

['unix%02d.andrew.cmu.edu', 'ghc%02d.ghc.andrew.cmu.edu'].each do |pat|
  (0..99).each{ |i| hosts << (pat % i) }
end

hosts = hosts.reject do |host|
  puts "Trying: #{host}"
  begin
    Timeout::timeout(0.5) { TCPSocket.new(host, 22).close }
    false
  rescue Timeout::Error, SocketError
    true
  end
end

puts "Available hosts: #{hosts.inspect}"

user     = ask('User: ')
password = ask('Password: ') { |q| q.echo = '*' }

max     = File.readlines('movies.lst').size + 1
lock    = Mutex.new
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
        break if root > max
        cmd = "cd movies && nice ./find #{root} #{time} #{depth}"
        ssh.exec!(cmd) do |channel, stream, data|
          puts "#{host}: #{stream}(#{root}/#{ticket}) => #{data}"
        end
      }
    end
  }
end

threads.each(&:join)
