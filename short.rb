require 'sinatra'
require 'securerandom'
require 'pstore'

store = PStore.new('urls.store')

get '/' do
  "Test"
end

get '/s/:key' do
  store.transaction do
    store[params[:key]] = 'stored'
  end
end

get '/k/:key' do
store.transaction { store.fetch(params[:key], "Not found")}
end

