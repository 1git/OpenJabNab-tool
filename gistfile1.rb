require 'net/http'
require 'rexml/document'

# Initial setup - api endpoint, user details and serial number (mac address) of your nabaztag
api_url = 'http://openjabnab.fr'
login = 'myusername'
pass = 'myawesomepassword'
sn = 'deadbeefcafe'

# The message to be sent via text to speech
# Send a test message if nothing provided via commandline
text = 'message de test' if ARGV.length == 0
text = ARGV[0].to_s if ARGV.length > 0

# The actual hard work
xml_data = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/accounts/auth?login=#{login}&pass=#{pass}")).body
doc = REXML::Document.new(xml_data)
token = doc.root[0][0]
response = Net::HTTP.get_response(URI.parse("#{api_url}/ojn_api/bunny/#{sn}/tts/say?token=#{token}&text=#{URI.escape(text)}")).body
responsedoc = REXML::Document.new(response)
puts responsedoc.root[0][0]