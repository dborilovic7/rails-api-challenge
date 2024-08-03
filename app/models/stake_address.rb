class StakeAddress < ApplicationRecord
  self.table_name = "stake_address"

  has_many :epoch_stakes,
            primary_key: :id,
            foreign_key: :addr_id
end
