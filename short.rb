require 'sinatra'
require 'securerandom'
require 'pstore'
require 'pry'

store = PStore.new('urls.store')

get '/' do
  haml :form
end

get '/*' do
  key = @params[:splat][0]
  url = store.transaction {store[key]}
  if !url
    redirect to('/')
  else
    redirect url
  end
end

post '/s' do
  @key = SecureRandom.urlsafe_base64(7)
  url =  params[:url]
  store.transaction do
    store[@key] = url
  end
  haml :response
end

get '/k/:key' do
  store.transaction { store.fetch(params[:key], "Not found")}
end

