require 'net/http'
require 'rexml/document'

# Initial setup - api endpoint, user details and serial number (mac address) of your nabaztag
api_url = 'http://ojn-server.somewhere.org'
login = 'user'
pass = 'pass'
sn = 'deadbeefcafe'

function = ARGV[0]
# The message to be sent via text to speech
# Send a test message if nothing provided via commandline
text = 'message test' if ARGV.length == 0
text = ARGV[1].to_s if ARGV.length > 0

# The actual hard work
xml_data = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/accounts/auth?login=#{login}&pass=#{pass}")).body
doc = REXML::Document.new(xml_data)
token = doc.root[0][0]
print 'Token='
puts token;
case function
when "say"
	response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/tts/say?token=#{token}&text=#{URI.escape(text)}")).body
	responsedoc = REXML::Document.new(response)
	puts responsedoc.root[0][0]
when "sleep"
	response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/sleep/sleep?token=#{token}")).body
	responsedoc = REXML::Document.new(response)
	puts responsedoc.root[0][0]
when "wake"
	response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/sleep/wakeup?token=#{token}")).body
	responsedoc = REXML::Document.new(response)
	puts responsedoc.root[0][0]
when "status"
	response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/sleep/status?token=#{token}")).body
	responsedoc = REXML::Document.new(response)
	puts responsedoc.root[0][0]
when "getColour"
	response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/colorbreathing/getColor?token=#{token}")).body
	responsedoc = REXML::Document.new(response)
	puts responsedoc.root[0][0]
when "listColour"
	response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/colorbreathing/getColorList?token=#{token}")).body
	responsedoc = REXML::Document.new(response)
      	puts REXML::XPath.match(responsedoc,'.//text()')
when "getInsomniac"
	response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/getInsomniac?token=#{token}")).body
	responsedoc = REXML::Document.new(response)
	puts responsedoc.root[0][0]
when "listStations"
	response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/webradio/listpreset?token=#{token}")).body
	responsedoc = REXML::Document.new(response)
	temp = (REXML::XPath.match(responsedoc,"//key").map {|e| e.text })
	temp.each{|c| c[0..3] = ''}
	puts temp
when "listCasts"
	response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/webradio/listwebcast?token=#{token}")).body
	responsedoc = REXML::Document.new(response)
	puts responsedoc
when "play"
	response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/webradio/play?token=#{token}&name=#{URI.escape(text)}")).body
	responsedoc = REXML::Document.new(response)
        puts responsedoc.root[0][0]
when "MoveEar"
        response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/test/moveEar?token=#{token}&left=#{URI.escape(ARGV[1])}&right=#{URI.escape(ARGV[2])}")).body
        responsedoc = REXML::Document.new(response)
        puts responsedoc.root[0][0]
when "ambient"
	response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/test/test?token=#{token}&type=#{URI.escape("ambient")}")).body
when "chor"
	response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/test/test?token=#{token}&type=#{URI.escape("chor")}")).body
end
