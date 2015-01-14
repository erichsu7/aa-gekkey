require 'uri'

module Phase5
  class Params
    def initialize(req, route_params = {})
      @params = ([req.query_string, req.body].compact.map { |el|
        parse_www_encoded_form(el) } + [route_params]).inject(&:merge)
    end

    def [](key)
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    def parse_www_encoded_form(www_encoded_form)
      tree = {}
      URI::decode_www_form(www_encoded_form).each do |k, v|
        node = tree
        keys = parse_key(k)

        keys[0...-1].each do |k|
          node[k] ||= {}
          node = node[k]
        end
        node[keys[-1]] = v

      end
      tree
    end

    def parse_key(key)
      key.split(/\[|\]\[?/)
    end
  end
end
