require 'sinatra'
require 'open-uri'
require 'json'
require './image'

API_BASE = 'http://api.metro.co.uk/news-feed/?path=home&number=5&post-type=post&sort-by=trending'

def process_fragment()
	headers 'Cache-Control' => 'max-age=60'
	headers 'Access-Control-Allow-Origin' => '*'
	json_str = open(API_BASE) { |io| io.read }
	data = JSON.parse(json_str)
	erb :fragment, :locals => {:data => data, :layout => params['layout']}
end

get '/' do
	process_fragment()
end

get '/embedded' do
    erb :embedded, :locals => {:fragment => process_fragment()}
end

helpers do
	# Useful for including inline CSS
	def get_file_content(path)
		File.read(File.expand_path(path))
	end

  	def esc_quotes(str)
  		return (str.nil?) ? nil : str.sub('"', "&quot;")
  	end

  	def get_image(post, layout)
  		url = post['attachments']['landscape_16_9']['URL']

  		case layout
  		when 'small'
  			return nil
  		when 'medium'
  			return Image.new(url, 229, 305)
  		else
  			return Image.new(url, 235, 313)
  		end
  	end
end
