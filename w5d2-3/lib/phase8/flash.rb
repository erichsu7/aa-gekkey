module Phase8
  class FlashNow
    def initialize(session)
      @flash = s = session['_flash'] ? s.dup : {}
    end

    def [](key)
      @flash[key.to_s]
    end

    def []=(key, value)
      @flash[key.to_s] = value
    end
  end

  class Flash
    def initialize(session)
      # pulls from the req, saves to res.cookies
      @session = session
      @flash = FlashNow.new(session)
      session['_flash'] = {}
    end

    def now
      @flash
    end

    def [](key)
      @flash[key.to_s]
    end

    def []=(key, value)
      session['_flash'].merge!({key => value })
    end

    private
    def session
      @session
    end
  end
end
