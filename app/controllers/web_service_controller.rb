#
# This class provides a framework for XML-RPC services on Rails
#
require 'xmlrpc/server'
class WebServiceController < ApplicationController

  # XML-RPC calls are not session-aware, so always turn this off
  session :off

  def initialize
    @server = XMLRPC::BasicServer.new
    # loop through all the methods, adding them as handlers
    self.class.instance_methods(false).each do |method|
      unless ['index'].member?(method)
        @server.add_handler(method) do |*args|
          self.send(method.to_sym, *args)
        end
      end
    end
  end

  def index
    result = @server.process(request.body)
    puts "\n\n----- BEGIN RESULT -----\n#{result}\n----- END RESULT -----\n"
    render :text => result, :content_type => 'text/xml'
  end
  
end
