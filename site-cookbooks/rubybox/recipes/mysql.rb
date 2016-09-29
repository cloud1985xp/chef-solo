mysql_service 'default' do
  port '3306'
  version '5.5'
  initial_root_password node['mysql']['initial_root_password']
  action [:create, :start]
end

mysql2_chef_gem 'default' do
  action :install
end

link '/var/run/mysqld-default' do
  to '/var/run/mysqld'
  action :create
  owner 'root'
  group 'root'
end