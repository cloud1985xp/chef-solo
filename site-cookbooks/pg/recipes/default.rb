include_recipe "postgresql::default"
include_recipe "postgresql::server"
include_recipe "database::postgresql"

include_recipe "postgresql::server_conf"

# postgresql_database_user "isis" do
#   connection(
#     :host => "127.0.0.1",
#     :port => node['postgresql']['config']['port'],
#     :username => 'postgres',
#     :password => node['postgresql']['password']['postgres']
#   )
#   password bag_pwd
#   action :create
# end

conn = {
  :host => "127.0.0.1",
  :port => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

postgresql_database_user 'nexalon' do
  connection conn
  password 'guangdaKB'
  action :create
end

postgresql_database "nexalon_staging" do
  connection conn
  action :create
end

postgresql_database_user 'nexalon' do
  connection conn
  password 'guangdaKB'
  action :grant
  privileges    [:all]
  database_name 'nexalon_staging'
end

# vhosts = node['nginx']['vhosts'] || [""]
# vhosts.each do |v|
#   # pg_database "isis_#{project_env}#{v}" do
#   #   owner "isis"
#   #   encoding "utf8"
#   #   template "template0"
#   #   locale "en_US.UTF8"
#   # end
#   postgresql_database "isis_#{project_env}#{v}" do
#     connection(
#       :username => "isis",
#       :password => bag_pwd
#     )
#     action :create
#   end
# end