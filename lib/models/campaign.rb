require 'active_record'

# Set up a database connection
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'coding_assignment.db')

# Set up database tables and columns
ActiveRecord::Schema.define do
  create_table :campaigns, force: true do |t|
    t.string :job_id
    t.string :status
    t.string :external_reference
    t.string :ad_description
  end
end

class Campaign < ActiveRecord::Base
end