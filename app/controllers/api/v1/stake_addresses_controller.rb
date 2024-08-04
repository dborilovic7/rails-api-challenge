class Api::V1::StakeAddressesController < ApplicationController
  def index
    @addresses = StakeAddress.first.as_json
    render json: @addresses
  end
end
