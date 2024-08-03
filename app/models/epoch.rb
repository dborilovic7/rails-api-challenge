class Epoch < ApplicationRecord
  self.table_name = "epoch"

  scope :time_range, ->(start_time, end_time) { where("start_time >= ?", start_time).where("end_time <= ?", end_time) }
end
