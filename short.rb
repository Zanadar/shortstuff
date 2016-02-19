require 'sinatra'
require 'securerandom'
require 'pstore'

store = PStore.new('urls.store')

get '/' do
  haml :form
end

post '/' do
  "Success!!!"
end

post '/s' do
  binding.pry
  store.transaction do
    store[params[:key]] = 'stored'
  end
end

get '/k/:key' do
  store.transaction { store.fetch(params[:key], "Not found")}
end

