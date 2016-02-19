require 'sinatra'
require 'securerandom'
require 'pstore'
require 'pry'
require 'uri'

URI::DEFAULT_PARSER.regexp[:ABS_URI]

store = PStore.new('urls.store')

get '/' do
  haml :form
end

get '/*' do
  key = @params[:splat][0]
  url = store.transaction {store[key]}
  if !url
    raise Sinatra::NotFound
  else
    redirect url
  end
end

post '/s' do
  @key = SecureRandom.urlsafe_base64(7)
  url =  params[:url]
  @path = gen_url(url)
  store.transaction do
    store[@key] = @path
  end
  haml :response
end

error Exception do
  "That's a bad url"
end


## Best effort to make a valid url
def gen_url(url)
  begin
    if url =~ /\A#{URI::regexp(['http', 'https'])}\z/
      return url
    else
      return URI::HTTP.build(host: url).to_s
    end
  rescue
    redirect 404
  end
end

