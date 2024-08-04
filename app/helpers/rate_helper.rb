module RateHelper
  require "json"
  require "coinapi/ruby-rest/coinapi_v1"

  def self.read_rates
    file = File.read("app/rates.json")
    eur, usd = JSON.parse(file)
    @@ada_eur = eur["rate"]
    @@ada_usd = usd["rate"]
  end
  self.read_rates

  def self.fetch_rates
    api_key = Rails.application.credentials.dig(:coinapi, :market_data_api_key)
    @@coinapi_client ||= CoinAPIv1::Client.new(api_key: api_key)

    ada_eur = @@coinapi_client.exchange_rates_get_specific_rate(asset_id_base: "ADA", asset_id_quote: "EUR")
    ada_usd = @@coinapi_client.exchange_rates_get_specific_rate(asset_id_base: "ADA", asset_id_quote: "USD")

    File.open("app/rates.json", "w") do |f|
      array = [ada_eur, ada_usd].to_json
      f.write(array)
    end

    self.read_rates
  end

  def self.ada_eur
    @@ada_eur
  end

  def self.ada_usd
    @@ada_usd
  end

  def self.amount_in_eur(amount)
    (amount * @@ada_eur).round(2)
  end

  def self.amount_in_usd(amount)
    (amount * @@ada_usd).round(2)
  end
end
