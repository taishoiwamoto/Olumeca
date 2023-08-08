class RenameHourToServiceTimeInServices < ActiveRecord::Migration[7.0]
  def change
    rename_column :services, :hour, :service_time
  end
end
