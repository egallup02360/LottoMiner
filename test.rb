require 'socket'
require 'json'

api_command = ARGV[0].split("|")

if ARGV.length == 3
	api_ip = ARGV[1]
	api_port = ARGV[2]
elsif ARGV.length == 2
	api_ip = ARGV[1]
	api_port = 4028
else
	api_ip = "192.168.1.13"
	api_port = 4028
end

s = TCPSocket.open(api_ip, api_port)

if api_command.count == 2
	s.write({ :command => api_command[0], :parameter => api_command[1]}.to_json)
else
	s.write({ :command => api_command[0]}.to_json)
end

response = s.read.strip
response = JSON.parse(response)

puts response
s.close
