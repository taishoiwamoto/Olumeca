class DropProfiles < ActiveRecord::Migration[7.0]
  def up
    drop_table :profiles
  end

  def down
    create_table "profiles" do |t|
      t.string "nickname"
      t.string "phone"
      t.integer "user_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["user_id"], name: "index_profiles_on_user_id"
    end
  end
end
