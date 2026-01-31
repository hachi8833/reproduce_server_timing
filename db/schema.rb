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

ActiveRecord::Schema[8.1].define(version: 2026_01_31_011408) do
  create_table "patterns", force: :cascade do |t|
    t.integer "category"
    t.text "comment"
    t.datetime "created_at", null: false
    t.string "display_name"
    t.integer "hit_count"
    t.text "memorandum"
    t.text "nega_sample"
    t.text "posi_sample"
    t.integer "redos_status"
    t.string "regex"
    t.datetime "updated_at", null: false
  end
end
