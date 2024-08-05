class StakeAddress < ApplicationRecord
  self.table_name = "stake_address"
  self.per_page = 10

  has_many :epoch_stakes,
            primary_key: :id,
            foreign_key: :addr_id

  scope :display, -> do
    select("stake_address.id, stake_address.view as address, epoch_stake.amount as ada_amount")
    .joins(:epoch_stakes).distinct
    .joins("INNER JOIN epoch ON epoch.no = epoch_stake.epoch_no")
    .where("epoch.start_time >= ?", TaskHelper::EPOCH_START_TIME)
    .where("epoch.end_time <= ?", TaskHelper::EPOCH_END_TIME)
    .where("amount >= ?", TaskHelper::LOVELACE_MIN_AMOUNT)
    .where("amount <= ?", TaskHelper::LOVELACE_MAX_AMOUNT)
  end

  scope :search, lambda { |params|
    addresses = display
    addresses = addresses.where("stake_address.view = ?", params[:address]) if params[:address]

    addresses = addresses.where("epoch_stake.amount >= ?", params[:min_ada_amount].to_i * 1_000_000) if params[:min_ada_amount]
    addresses = addresses.where("epoch_stake.amount <= ?", params[:max_ada_amount].to_i * 1_000_000) if params[:max_ada_amount]

    addresses = addresses.where("epoch_stake.amount >= ?", RateHelper.eur_to_ada(params[:min_ada_amount_in_eur].to_f) * 1_000_000) if params[:min_ada_amount_in_eur]
    addresses = addresses.where("epoch_stake.amount <= ?", RateHelper.eur_to_ada(params[:max_ada_amount_in_eur].to_f) * 1_000_000) if params[:max_ada_amount_in_eur]
    addresses = addresses.where("epoch_stake.amount >= ?", RateHelper.usd_to_ada(params[:min_ada_amount_in_usd].to_f) * 1_000_000) if params[:min_ada_amount_in_usd]
    addresses = addresses.where("epoch_stake.amount <= ?", RateHelper.usd_to_ada(params[:max_ada_amount_in_usd].to_f) * 1_000_000) if params[:max_ada_amount_in_usd]
    addresses
  }
end
