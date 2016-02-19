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
  path = gen_url(url)
  store.transaction do
    store[@key] = path
  end
  haml :response
end

error URI::InvalidComponentError do
  haml :error
end

not_found do
  haml :error
end

## Best effort to make a valid url
def gen_url(url)
  if url =~ /\A#{URI::regexp(['http', 'https'])}\z/
    return url
  else
    return URI::HTTP.build(host: url).to_s
  end
end

