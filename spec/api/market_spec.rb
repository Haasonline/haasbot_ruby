require 'spec_helper'

RSpec.describe HaasbotRuby::Api::Market do
  let(:client) { HaasbotRuby::Client.new('127.0.0.1', 8050) }

  describe '#get_all_price_sources' do
    it 'fetches all price sources' do
      VCR.use_cassette('get_all_price_sources_success') do
        response = client.get_all_price_sources

        expect(response).to include('Binance')
        expect(response).to include('Bitfinex')
        expect(response).to include('BTCe')
        expect(response).to include('CexIO')
        expect(response).to include('OKCoinCOM')
      end
    end
  end

  describe '#get_enabled_price_sources' do
    it 'fetches all enabled price sources' do
      VCR.use_cassette('get_enabled_price_sources_success') do
        response = client.get_enabled_price_sources

        expect(response).to include('Binance')
        expect(response).to include('Bitfinex')
      end
    end
  end

  describe '#get_price_markets' do
    it 'fetches all price markets' do
      VCR.use_cassette('get_price_markets_success') do
        response = client.get_price_markets(priceSourceName: 'Binance')

        first_market = response.first

        expect(first_market['LeverageLevels']).to eq([1.0])
        expect(first_market['AmountDecimals']).to eq(1)
        expect(first_market['PriceDecimals']).to eq(5)
        expect(first_market['MinimumTradeAmount']).to eq(0.1)
        expect(first_market['MinimumTradeVolume']).to eq(1.0)
        expect(first_market['TradeFee']).to eq(10.0)
        expect(first_market['SettlementDate']).to eq(0)
        expect(first_market['AmountViewDecimals']).to eq(1)
        expect(first_market['PriceSource']).to eq(21)
        expect(first_market['PriceMarketType']).to eq(0)
        expect(first_market['DisplayName']).to eq('Binance ADA/BNB')
        expect(first_market['ShortName']).to eq('ADA/BNB')
        expect(first_market['ContractName']).to eq('')
        expect(first_market['PrimaryCurrency']).to eq('ADA')
        expect(first_market['SecondaryCurrency']).to eq('BNB')
      end
    end
  end

  describe '#get_price_ticker' do
    context 'failures' do
      let(:response) {
        client.get_price_ticker(
          priceSourceName: 'Binance',
          primaryCoin: 'ADA',
          secondaryCoin: 'BLERG'
        )
      }

      it 'fails with invalid parameters' do
        VCR.use_cassette('get_price_ticker_fail_1') do
          expect{ response }.to raise_exception(HaasbotRuby::InvalidMarket)
        end
      end
    end

    it 'fetches the correct data' do
      VCR.use_cassette('get_price_ticker_success') do
        response = client.get_price_ticker(
          priceSourceName: 'Binance',
          primaryCoin: 'ADA',
          secondaryCoin: 'BNB'
        )

        expect(response['TimeStamp']).to eq('2018-08-11T18:44:00.000255Z')
        expect(response['UnixTimeStamp']).to eq(1534013040)
        expect(response['CurrentBuyValue']).to eq(0.00956)
        expect(response['CurrentSellValue']).to eq(0.00951)
        expect(response['HighValue']).to eq(0.0095)
        expect(response['LowValue']).to eq(0.0095)
        expect(response['Open']).to eq(0.0095)
        expect(response['Close']).to eq(0.0095)
        expect(response['Volume']).to eq(179.0)
      end
    end
  end

  describe '#get_minute_price_ticker' do
    it 'fetches the correct data' do
      VCR.use_cassette('get_minute_price_ticker_success') do
        response = client.get_minute_price_ticker(
          priceSourceName: 'Binance',
          primaryCoin: 'ADA',
          secondaryCoin: 'BNB'
        )

        expect(response['TimeStamp']).to eq('2018-08-11T18:47:00.000255Z')
        expect(response['UnixTimeStamp']).to eq(1534013220)
        expect(response['CurrentBuyValue']).to eq(0.00961)
        expect(response['CurrentSellValue']).to eq(0.00954)
        expect(response['HighValue']).to eq(0.00952)
        expect(response['LowValue']).to eq(0.00952)
        expect(response['Open']).to eq(0.00952)
        expect(response['Close']).to eq(0.00952)
        expect(response['Volume']).to eq(0.0)
      end
    end
  end

  describe '#get_last_trades' do
    it 'fetches the correct data' do
      VCR.use_cassette('get_last_trades_success') do
        response = client.get_last_trades(
          priceSourceName: 'Binance',
          primaryCoin: 'ADA',
          secondaryCoin: 'BNB'
        )

        expect(response['Timestamp']).to eq('2018-08-11T18:43:39.754492Z')
        expect(response['UnixLastUpdate']).to eq(1534013019)

        last_trade = response['LastTrades'].first

        expect(last_trade['Timestamp']).to eq('2018-08-11T18:38:39')
        expect(last_trade['UnixTimestamp']).to eq(1534012719)
        expect(last_trade['Amount']).to eq(500.7)
        expect(last_trade['Price']).to eq(0.00951)
      end
    end
  end

  describe '#get_orderbook' do
    it 'fetches the correct data' do
      VCR.use_cassette('get_orderbook_success') do
        response = client.get_orderbook(
          priceSourceName: 'Binance',
          primaryCoin: 'ADA',
          secondaryCoin: 'BNB'
        )

        expect(response['Timestamp']).to eq('2018-08-11T18:48:47.569987Z')
        expect(response['UnixLastUpdate']).to eq(1534013327)

        price_market = response['PriceMarket']
        expect(price_market['PriceSource']).to eq(21)
        expect(price_market['PriceMarketType']).to eq(0)
        expect(price_market['DisplayName']).to eq('Binance ADA/BNB')
        expect(price_market['ShortName']).to eq('ADA/BNB')
        expect(price_market['ContractName']).to eq('')
        expect(price_market['PrimaryCurrency']).to eq('ADA')
        expect(price_market['SecondaryCurrency']).to eq('BNB')

        first_bid = response['Bid'].first
        expect(first_bid['Amount']).to eq(2952.7)
        expect(first_bid['Price']).to eq(0.00953)

        first_ask = response['Ask'].first
        expect(first_ask['Amount']).to eq(6122.8)
        expect(first_ask['Price']).to eq(0.00961)
      end
    end
  end

  describe '#get_history' do
    it 'fetches the correct data' do
      VCR.use_cassette('get_history_success') do
        response = client.get_history(
          priceSourceName: 'Binance',
          primaryCoin: 'ADA',
          secondaryCoin: 'BNB',
          interval: 1,
          depth: 100
        )

        expect(response.count).to eq(100)

        history = response.first

        expect(history['TimeStamp']).to eq('2018-08-11T17:14:00')
        expect(history['UnixTimeStamp']).to eq(1534007640)
        expect(history['CurrentBuyValue']).to eq(0.00956)
        expect(history['CurrentSellValue']).to eq(0.00956)
        expect(history['HighValue']).to eq(0.00956)
        expect(history['LowValue']).to eq(0.00956)
        expect(history['Open']).to eq(0.00956)
        expect(history['Close']).to eq(0.00956)
        expect(history['Volume']).to eq(0.0)
      end
    end
  end
end
