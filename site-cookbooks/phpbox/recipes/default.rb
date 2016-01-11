# Base library
# include_recipe "basebox::default"
include_recipe 'build-essential::default'

%w(bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev libxslt1.1 libxslt1-dev libxml2 libcurl4-openssl-dev libapr1-dev libaprutil1-dev autoconf automake libtool pkg-config).each do |p|
  package p
end

template '/etc/environment' do
  source 'environment.erb'
  mode '0440'
  owner 'root'
  group 'root'
  variables({
     :sudoers_groups => node[:authorization][:sudo][:groups],
     :sudoers_users => node[:authorization][:sudo][:users]
  })
end

package 'git'
package 'curl'
package 'vim'
package 'screen'
package 'iotop'
package 'htop'
# package 'libpq-dev'

# include_recipe 'mysql::default'

# MySQL
# %w(mysql-server mysql-client libmysqlclient15-dev).each do |name|
#   package name
# end

mysql_service 'default' do
  port '3306'
  version '5.5'
  initial_root_password node['mysql']['initial_root_password']
  action [:create, :start]
end

mysql2_chef_gem 'default' do
  action :install
end

# Apache2
include_recipe "apache2::default"
include_recipe "apache2::mod_rewrite"

apache_module 'mpm_event' do
  enable false
end

apache_module 'mpm_prefork' do
  enable true
end

# PHP5
# include_recipe 'php::default'
# include_recipe 'php::package'
%w(php5 php-pear php5-xcache php5-fpm php5-common php5-curl php5-dev php5-gd 
  php5-imagick php5-mcrypt php5-memcache php5-mhash php5-mysql 
  php5-xmlrpc php5-xsl php5-cli libapache2-mod-php5).each do |name|
  package name
end

directory '/srv' do
  owner node['phpbox']['user']
  group node['phpbox']['user_group']
  mode '0755'
  action :create
end

# projects = {
#   'kitaiwan' => {
#     'database' => {
#       'dbname' => 'olivecms_kitaiwan',
#       'host' => '127.0.0.1',
#       'username' => 'kitaiwan',
#       'password' => 'dE9r4DuF'
#     }
#   }
# }

# projects.each do |project, data|

#   config = data['database']

#   mysql_database config['dbname'] do
#     connection(
#       :host     => config['host'],
#       :username => config['username'],
#       :password => config['password']
#     )
#     action :create
#   end

# end

# rbenv
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
rbenv_ruby node['rbenv']['install_ruby'] do
  action :install
  global true
end

rbenv_gem "bundler" do
  ruby_version node['rbenv']['install_ruby']
end

# include_recipe "postgresql::client"
# include_recipe "redisio::default"
# include_recipe "redisio::enable"

template "#{ENV['HOME']}/.ssh/config" do
  source 'ssh_config.erb'
  mode '0600'
  owner node['current_user']
  group node['current_user']
end

template "#{ENV['HOME']}/.screenrc" do
  source 'screenrc.erb'
  mode '0600'
  owner node['current_user']
  group node['current_user']
end