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
end
