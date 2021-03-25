require 'socket'
require 'json'

class CgminerApi
  def self.call(command)
    api_command = command.split("|")

    if Rails.env.development?
    	api_ip = "192.168.1.160"
    	api_port = 4028
    else
      api_ip = "127.0.0.1"
    	api_port = 4028
    end

    begin
      s = TCPSocket.open(api_ip, api_port)
    rescue => e
      system("sh -c 'service cgminer restart'") unless Rails.env.development?
      return "CGMiner is not running. Attempted a restart. #{e}"
    end

    if api_command.count == 2
    	s.write({ :command => api_command[0], :parameter => api_command[1]}.to_json)
    else
    	s.write({ :command => api_command[0]}.to_json)
    end

    response = s.read.strip
    begin
      response = JSON.parse(response)
    rescue => e
      system("sh -c 'service cgminer restart'") unless Rails.env.development?
      return "CGMiner is not running. Attempted a restart. #{e}"
    end

    puts response
    s.close

    return response
  end
end
