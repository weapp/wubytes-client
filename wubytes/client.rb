require 'oauth2'
require 'json'

module Wubytes
  class Client < OAuth2::Client
    def initialize(client_id, client_secret, opts={}, &block)
      default_opts = {token_url: '/oauth/authorize', :site => 'http://wubytes.com', raise_errors: false}
      super(client_id, client_secret, default_opts.merge(opts), &block)
    end

    def token_from_string(access_token)
      hash = {"scope"=>"read write", "access_token"=> access_token, "refresh_token"=>nil, "expires_at"=>nil, :header_format=>"OAuth %s"}
      auth_code_token_from_hash hash
    end

    def auth_code_authorize_url(params={})
      params = {'response_type' => 'code', 'client_id' => id}.merge(params)
      authorize_url(params)
    end

    def auth_code_get_token(code, params={}, opts={})
      params = {'grant_type' => 'authorization_code', 'code' => code, 'client_id' => id, 'client_secret' => secret}.merge(params)
      opts = {header_format: 'OAuth %s'}.merge(opts)
      get_token(params, opts)
    end

    def password_get_token(username, password, params={}, opts={})
      opts = {header_format: 'OAuth %s'}.merge(opts)
      self.password.get_token(username, password, params, opts)
    end

    def request(verb, url, opts={})
      if url.start_with? "/api/"
        JSON.load(super(verb, url, opts).body)
      else
        super(verb, url, opts)
      end
    end

    private
      def auth_code_token_from_hash(hash)
        hash[:header_format] = 'OAuth %s' # TODO fix this on Oauth2 repo
        token = OAuth2::AccessToken.from_hash(self, hash)
      end

  end
end
