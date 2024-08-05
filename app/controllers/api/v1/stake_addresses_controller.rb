class Api::V1::StakeAddressesController < ApplicationController
  def index
    set_addresses
    render json: @output
  end

  private

  def set_addresses
    @output = { stake_addresses: [] }

    page = addresses_params[:page] || 1
    addresses = StakeAddress.search(addresses_params).paginate(page: page)
    total_pages = addresses.total_pages

    addresses = addresses.as_json
    addresses.each do |address|
      address["ada_amount"] /= 1_000_000.0
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
    params.permit(:page, :address, :min_ada_amount, :max_ada_amount, :min_ada_amount_in_eur,
                  :max_ada_amount_in_eur, :min_ada_amount_in_usd, :max_ada_amount_in_usd)
  end
end
