require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      @name = "_rails_lite_app"
      a = req.cookies.find { |c| c.name == @name }
      @cookies = a ? a.value && JSON.parse(a.value) : {}
    end

    def [](key)
      @cookies[key]
    end

    def []=(key, val)
      @cookies[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new(@name, JSON.generate(@cookies))
    end
  end
end
