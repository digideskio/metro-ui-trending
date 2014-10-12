require 'uri'
require 'cgi'

# Handles resizing
class Image
	attr_reader :url, :width, :height

	def initialize(original_url, width, height)
		@width = width
		@height = height
		uri = URI.parse(original_url)
		params = CGI.parse(uri.query)
		crop = params['crop'].first
		base = "#{uri.scheme}://#{uri.host}#{uri.path}"

		if crop === '1'
			# Image is auto-cropped (from centre), so we can just specify width and height
			@url = "#{base}?crop=1&w=#{width}&h=#{height}"
		elsif !crop.nil?
			# Manual crop, add resize (for Photon URLs?)
			@url = "#{base}?crop=#{URI.escape(crop)}&resize=#{width}%2C#{height}"
		else
			# Rare: no crop, add crop=1 for auto-crop
			@url = "#{base}?crop=1&w=#{width}&h=#{height}"
		end
	end
end