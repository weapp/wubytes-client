require 'json'
require './wubytes/client'
require 'pp'

# sina.tra/
key = '3zqyaun8js8lyczaaf8d3j53j8emxmo'
secret = 'qeualuw1pb8pntu7fxqauxf20oqjq94'

client = Wubytes::Client.new(key, secret, :site => 'http://localhost:9292')


# get the token params in the callback and
#token = OAuth2::AccessToken.from_kvform(client, query_string)

print "email: "
email = gets.strip
print "password: "
password = gets.strip

token = client.password_get_token(email, password)

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

#response[:me_wbs] = token.get('/api/users/%s/wbs' % user)

#response[:wbs] = token.get('/api/wbs')


pp response
