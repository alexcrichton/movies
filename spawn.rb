require 'timeout'
require 'eventmachine'

module Runner
  attr_accessor :next

  def receive_data data
    puts data
  end

  def unbind
    if @last == File.readlines('movies.lst').size
      return EM.stop_event_loop 
    end

    EM.popen("./find #{@next} 5", Runner) { |p| p.next = @next + 1 }
  end
end

EM::run {
  EM.popen("./find 0 5", Runner){ |p| p.next = 0 }
}
