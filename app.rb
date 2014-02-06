require 'sinatra'
require 'oauth2'
require 'json'
require 'date'

# access tokens will be stored in the session
enable :sessions
set    :session_secret, 'super secret'

helpers do
  def format_date(date_str)
    Date.parse(date_str).strftime("%B %d, %Y")
  end
end

def client
  OAuth2::Client.new(
    ENV['MOVES_CLIENT_ID'],
    ENV['MOVES_CLIENT_SECRET'],
    :site => 'https://api.moves-app.com',
    :authorize_url => 'moves://app/authorize',
    :token_url => 'https://api.moves-app.com/oauth/v1/access_token')
end

get "/" do
  if !session[:access_token].nil?
    erb :index
  else
    @moves_authorize_uri = client.auth_code.authorize_url(:redirect_uri => redirect_uri, :scope => 'activity')
    erb :signin
  end
end

get '/moves/logout' do
  session[:access_token]  = nil
  redirect '/'
end

get '/auth/moves/callback' do
  new_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
  session[:access_token]  = new_token.token
  redirect '/'
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/auth/moves/callback'
  uri.query = nil
  uri.to_s
end

def access_token
  OAuth2::AccessToken.new(client, session[:access_token], :refresh_token => session[:refresh_token])
end

get '/moves/profile' do
  @json = access_token.get("/api/1.1/user/profile").parsed
  erb :profile, :layout => !request.xhr?
end

get '/moves/recent' do
  @json = access_token.get("/api/1.1/user/summary/daily?pastDays=7").parsed
  @steps = @json.map { |day|
    unless day["summary"].nil?
      (day["summary"].find { |a| a["group"] == "walking"})["steps"]
    else
      0
    end
  }
  erb :recent, :layout => !request.xhr?
end


