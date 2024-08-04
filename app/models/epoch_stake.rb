class EpochStake < ApplicationRecord
  self.table_name = "epoch_stake"

  has_one :stake_address,
          primary_key: :addr_id,
          foreign_key: :id

  scope :time_range, ->(start_time, end_time) do
    joins("INNER JOIN epoch ON epoch.no = epoch_stake.epoch_no")
    .where("epoch.start_time >= ?", start_time)
    .where("epoch.end_time <= ?", end_time)
  end

  scope :stake_amount_range, ->(min, max) { where("amount >= ?", min).where("amount <= ?", max) }
end
