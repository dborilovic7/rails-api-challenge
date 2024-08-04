require_relative("../../app/helpers/rate_helper")

desc "Get latest ADA/EUR and ADA/USD exchange rates"
task :get_rates do
  RateHelper.fetch_rates
end