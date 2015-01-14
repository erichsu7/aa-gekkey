module Phase2
  class ControllerBase
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res)
      @req, @res = req, res
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      @built || false
    end

    # Set the response status code and header
    def redirect_to(url)
      is_response!
      res.status = 302
      res['location'] = url
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, type)
      is_response!
      res.content_type = type
      res.body = content
    end

    private
    def is_response!
      raise if @built
      @built = true
    end
  end
end
