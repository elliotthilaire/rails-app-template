
# Enable UUID extension
generate :migration, "enable_uuid_extension"
enable_uuid_extension_migration_path = Dir.glob("db/migrate/*_enable_uuid_extension.rb").last
insert_into_file enable_uuid_extension_migration_path, :after => "  def change" do
  "\n    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')"
end

# Generate User model
generate :model, "user"
gsub_file Dir.glob("db/migrate/*_create_users.rb").last,
  "create_table :users do |t|", "create_table :users, id: :uuid do |t|"

# Generate EmailAddress model
generate :model, "email_address email_address:string:uniq user:uuid:references"

# Create index controller
generate :controller, "welcome index"
route "root to: 'welcome#index'"

append_to_file ".gitignore" do
".envrc"
end

file '.envrc', <<-CODE
#export KEY=value
CODE
