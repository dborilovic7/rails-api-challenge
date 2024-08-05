class Api::V1::StakeAddressesController < ApplicationController
  def index
    set_addresses
    render json: @output
  end

  private

  def set_addresses
    @output = { stake_addresses: [] }

    page = addresses_params[:page] || 1
    addresses = StakeAddress.display.paginate(page: page)
    total_pages = addresses.total_pages

    addresses_hash = addresses.as_json
    addresses_hash.each do |address|
      address["ada_amount"] /= 1_000_000
      address["ada_amount_in_eur"] = RateHelper.amount_in_eur(address["ada_amount"])
      address["ada_amount_in_usd"] = RateHelper.amount_in_usd(address["ada_amount"])
    end

    @output[:stake_addresses] = addresses
    @output[:ada_to_eur_exchange_rate] = RateHelper.ada_eur
    @output[:ada_to_usd_exchange_rate] = RateHelper.ada_usd
    @output[:page] = page
    @output[:pages_count] = total_pages
    @output[:per_page] = StakeAddress.per_page
  end

  def addresses_params
    params.permit(:page)
  end
end
