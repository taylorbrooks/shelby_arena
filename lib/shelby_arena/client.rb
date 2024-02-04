require 'faraday'

Dir[File.expand_path('../resources/*.rb', __FILE__)].each { |f| require f }
require File.expand_path('../response/base.rb', __FILE__)
Dir[File.expand_path('../response/*.rb', __FILE__)].each { |f| require f }

module ShelbyArena
  class Client
    include ShelbyArena::Client::Batch
    include ShelbyArena::Client::Fund
    include ShelbyArena::Client::Person
    include ShelbyArena::Client::Contribution

    attr_reader :url, :username, :password, :logger, :connection, :adapter, :ssl, :api_key, :api_secret, :api_session

    def initialize(url:, username:, password:, api_key:, api_secret:, logger: true, adapter: Faraday.default_adapter, ssl: nil)
      if username.nil? && password.nil?
        raise ArgumentError, 'either username and password'
      end

      @url      = "#{url}/api.svc/"
      @username = username
      @password = password
      @api_key  = api_key
      @api_secret  = api_secret
      @logger   = logger
      @adapter  = adapter
      @ssl      = ssl
      @api_session = fetch_api_session
    end

    def delete(path, options = {})
      connection.delete(path, options).body
    end

    def get(path, options = {})
      connection.get(path, options).body
    end

    def patch(path, options = {})
      connection.patch(path, options).body
    end

    def post(path, options = {})
      connection.post(path, options).body
    end

    def json_post(path, options = {})
      connection(true).post(path, options).body
    end

    def put(path, options = {})
      connection.put(path, options).body
    end

    private

    def fetch_api_session
      params = {
        username: username,
        password: password,
        api_key: api_key
      }

      res = post('login', **params)

      res.dig('ApiSession', 'SessionID')
    end

    def generate_api_sig(path, options = {})
      options[:api_session] = api_session
      params = Faraday::FlatParamsEncoder.encode(options)
      thing_to_hash = "#{api_secret}_#{path}?#{params}".downcase
      Digest::MD5.hexdigest(thing_to_hash)
    end

    def connection(json = false)
      headers = {
        accept: 'application/json',
        'User-Agent' => "shelby-arena-ruby-gem/v#{ShelbyArena::VERSION}"
      }

      headers['Content-Type'] = 'application/json' if json

      client_opts = {
        url: url,
        headers: headers
      }

      client_opts[:ssl] = ssl if ssl

      Faraday.new(client_opts) do |conn|
        conn.request   :url_encoded
        conn.response  :logger if logger
        conn.response  :xml
        conn.use       FaradayMiddleware::ShelbyArenaErrorHandler
        conn.adapter   adapter
      end
    end
  end
end
