require 'rubygems'
require 'rack'

class EchoServer
  def call(env)
    [200, {"Content-Type" => "text/plain"}, env.inspect]
  end
end