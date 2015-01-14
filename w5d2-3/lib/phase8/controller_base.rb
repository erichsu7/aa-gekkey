require_relative '../phase6/controller_base'
require_relative './flash'

module Phase8
  class ControllerBase < Phase6::ControllerBase
    # setup the controller
    def flash
      @flash ||= Flash.new(session)
    end
  end
end
