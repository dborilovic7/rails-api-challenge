class EpochStake < ApplicationRecord
  self.table_name = "epoch_stake"

  has_one :stake_address,
          primary_key: :addr_id,
          foreign_key: :id
end
