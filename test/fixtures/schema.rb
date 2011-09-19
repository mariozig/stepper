ActiveRecord::Schema.define do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "current_step"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end