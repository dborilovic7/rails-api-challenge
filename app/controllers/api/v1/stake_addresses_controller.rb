class Api::V1::StakeAddressesController < ApplicationController
  def index
    set_addresses
    render json: @addresses
  end

  private

  def set_addresses
    @addresses = StakeAddress.display
    @addresses.each { |address| address.ada_amount /= 1_000_000 }
  end
end
