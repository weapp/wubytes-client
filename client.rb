require 'sinatra'
require 'json'
require './wubytes/client'

# sina.tra/
key = '3zqyaun8js8lyczaaf8d3j53j8emxmo'
secret = 'qeualuw1pb8pntu7fxqauxf20oqjq94'

client = Wubytes::Client.new(key, secret, :site => 'http://localhost:9292')

get '/' do
  redirect client.authorize_url(:redirect_uri => 'http://sina.tra/oauth2/callback', scope: 'read write')
end

get '/oauth2/callback' do
  token = client.get_token(params[:code], :redirect_uri => 'http://sina.tra/oauth2/callback')
  redirect 'http://sina.tra/with_token?token=%s' % token.token
end

get '/with_token' do
  token = client.token_from_string(params[:token])

  response = {
    datetime: {
      date: Date.today,
      time: Time.now.strftime('%T')
    },
    err: token.get('/api/err'),
    me: token.get('/api/me'),
    #post: token.post('/api/wbs', params: {data: 3, title: 'example-title', slug: 'example-title'}),
    q: token.get('/api/wbs', params: {q: "weapp:titulo,manu:asf,asf-2"})

  }

  user = response[:me]["id"]

  response[:me_wbs] = token.get('/api/users/%s/wbs' % user)

  response[:wbs] = token.get('/api/wbs')


  return JSON.dump(response)
end
