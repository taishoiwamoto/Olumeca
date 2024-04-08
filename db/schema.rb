# このファイルは、Active Record（RailsのORM）を用いて、データベースのスキーマ（テーブルの構造や関係性など）を管理するためのものです。
# このスキーマファイルはデータベースの現在の状態を表し、Railsアプリケーションのモデルとデータベースのテーブルを同期させるために使用されます。
# ファイル内の指示に従ってデータベースのスキーマを定義し、
# bin/rails db:schema:load コマンドを使用して新しいデータベースを作成するときにこの定義に基づいてテーブルが作成されます。

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_23_150357) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # active_storage関連のテーブルの作成
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  # カテゴリーテーブルの作成
  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  # お気に入りテーブルの作成
  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "service_id"
  end

  # 注文テーブルの作成
  create_table "orders", force: :cascade do |t|
    t.integer "buyer_id"
    t.integer "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.bigint "service_id"
    t.index ["service_id"], name: "index_orders_on_service_id"
  end

  # レビューテーブルの作成
  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_id"
    t.index ["service_id"], name: "index_reviews_on_service_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  # サービステーブルの作成
  create_table "services", force: :cascade do |t|
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "detail"
    t.datetime "deleted_at"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_services_on_category_id"
    t.index ["created_at"], name: "index_services_on_created_at"
    t.index ["deleted_at", "created_at"], name: "index_services_on_deleted_at_and_created_at"
  end

  # ユーザーテーブルの作成
  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number"
    t.string "name"
    t.datetime "deleted_at"
    t.index ["email", "deleted_at"], name: "index_users_on_email_and_deleted_at", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  # 外部キー制約の追加
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "reviews", "services"
  add_foreign_key "services", "categories"
end
