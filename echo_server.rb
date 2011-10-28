require 'rubygems'
require 'rack'

class EchoServer
  def initialize(options = {})
    Dir.mkdir('log') unless File.exists?('log')
  end

  def call(env)
    begin
      log(env)
    rescue Exception => e
      File.open('log/server.log', 'a') do |f|
        f.write("[#{Time.now}] #{e.class}: #{e.message}\n")
        e.backtrace.each {|line| f.write("  #{line}\n") }
      end
    end
    [200, {"Content-Type" => "text/plain"}, env.inspect]
  end

private
  
  def log(hash, level = 0, file = nil)
    root_call = file.nil?
    if root_call
      file = File.open('log/server.log', 'a')
      file.write("[#{Time.now}]\n")
    end
    
    hash.keys.each do |key|
      if hash[key].is_a?(Hash)
        log(hash[key], (level + 1), file)
      else
        if key == 'rack.input'
          value = hash[key].read
        else
          value = hash[key]
        end
        file.write("  #{' ' * level}#{key} => #{value}\n")
      end
    end

    file.close if root_call
  end
end