module HaasbotRuby
  module Api
    module Market
      def get_all_price_sources
        path = '/GetAllPriceSources'

        get(path)
      end

      def get_enabled_price_sources
        path = '/GetEnabledPriceSources'

        get(path)
      end

      # HaasbotRuby::Client.new('127.0.0.1', 8050).get_price_markets(priceSourceName: 'Binance')
      def get_price_markets(priceSourceName:)
        query = { priceSourceName: priceSourceName }
        path = '/GetPriceMarkets'

        get(path, query)
      end

      def get_price_ticker(priceSourceName:, primaryCoin:, secondaryCoin:, contractName: nil)
        get_price_source_for_endpoint(
          endpoint: 'GetPriceTicker',
          priceSourceName: priceSourceName,
          primaryCoin: primaryCoin,
          secondaryCoin: secondaryCoin,
          contractName: contractName
        )
      end

      def get_minute_price_ticker(priceSourceName:, primaryCoin:, secondaryCoin:, contractName: nil)
        get_price_source_for_endpoint(
          endpoint: 'GetMinutePriceTicker',
          priceSourceName: priceSourceName,
          primaryCoin: primaryCoin,
          secondaryCoin: secondaryCoin,
          contractName: contractName
        )
      end

      def get_last_trades(priceSourceName:, primaryCoin:, secondaryCoin:, contractName: nil)
        get_price_source_for_endpoint(
          endpoint: 'GetLastTrades',
          priceSourceName: priceSourceName,
          primaryCoin: primaryCoin,
          secondaryCoin: secondaryCoin,
          contractName: contractName
        )
      end

      def get_orderbook(priceSourceName:, primaryCoin:, secondaryCoin:, contractName: nil)
        get_price_source_for_endpoint(
          endpoint: 'GetOrderbook',
          priceSourceName: priceSourceName,
          primaryCoin: primaryCoin,
          secondaryCoin: secondaryCoin,
          contractName: contractName
        )
      end

      def get_history(priceSourceName:, primaryCoin:, secondaryCoin:, interval:, depth:, contractName: nil)
        query = {
          priceSourceName: priceSourceName,
          primaryCoin: primaryCoin,
          secondaryCoin: secondaryCoin,
          interval: interval,
          depth: depth
        }

        query[:contractName] = contractName unless contractName.nil?

        get('/GetHistory', query)
      end

      private

      def get_price_source_for_endpoint(endpoint:, priceSourceName:, primaryCoin:, secondaryCoin:, contractName: nil)
        query = {
          priceSourceName: priceSourceName,
          primaryCoin: primaryCoin,
          secondaryCoin: secondaryCoin,
        }

        query[:contractName] = contractName unless contractName.nil?

        get("/#{endpoint}", query)
      end
    end
  end
end
