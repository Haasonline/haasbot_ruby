module HaasbotRuby
  class Error < StandardError
  end

  class RequestError < Error
    attr_reader :response

    def initialize(response = nil)
      @response = response
    end

    def self.error_from_code(code)
      case code.to_i
      when 1001
        InvalidRequest
      when 1002
        InvalidSignature
      when 1003
        InvalidBotGuid
      when 1004
        InvalidBotElementGuid
      when 1005
        InvalidAccountGuid
      when 1006
        InvalidMarket
      when 1007
        InvalidEnum
      when 1008
        InvalidParameter
      when 1020
        PriceSourceNotActive
      when 1021
        PriceMarketIsSyncing
      when 1022
        MissingParameter
      when 2000
        UnknownError
      else
        UnknownError
      end
    end

    def error_code
      response['ErrorCode']
    end
  end

  class InvalidRequest < RequestError; end
  class InvalidSignature < RequestError; end
  class InvalidBotGuid < RequestError; end
  class InvalidBotElementGuid < RequestError; end
  class InvalidAccountGuid < RequestError; end
  class InvalidMarket < RequestError; end
  class InvalidEnum < RequestError; end
  class InvalidParameter < RequestError; end
  class PriceSourceNotActive < RequestError; end
  class PriceMarketIsSyncing < RequestError; end
  class MissingParameter < RequestError; end
  class UnknownError < RequestError; end
end