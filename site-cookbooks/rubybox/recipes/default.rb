# Base library
# include_recipe "basic_box::default"
include_recipe 'build-essential::default'

%w(
    bison
    openssl
    libreadline6
    libreadline6-dev
    zlib1g
    zlib1g-dev
    libssl-dev
    libyaml-dev 
    libxml2-dev
    libxslt-dev
    autoconf
    libc6-dev
    ncurses-dev
    libxslt1.1
    libxslt1-dev
    libxml2
    libcurl4-openssl-dev
    libapr1-dev
    libaprutil1-dev
    automake
    libtool
    pkg-config
    git
    curl
    vim
    libpq-dev
    nodejs
    screen
    iotop
    htop
  ).each do |p|
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

template "#{ENV['HOME']}/.screenrc" do
  source 'screenrc.erb'
  mode '0600'
  owner node['current_user']
  group node['current_user']
end

include_recipe "users::sysadmins"
include_recipe "sudo::default"

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
rbenv_ruby node['rbenv']['install_ruby'] do
  action :install
  global true
end

rbenv_gem "bundler" do
  ruby_version node['rbenv']['install_ruby']
end

# Nginx
include_recipe 'nginx::default'
nginx_site 'default' do
  action :disable
end

include_recipe "redisio::default"
include_recipe "redisio::enable"
include_recipe "postgresql::client"

directory '/srv' do
  owner node['rubybox']['user']
  group node['rubybox']['user_group']
  mode '0755'
  action :create
end


# service 'nginx' do
#   supports :restart => true, :status => true, :reload => true
#   action [:restart]
# end

# mysql_service 'default' do
#   port '3306'
#   version '5.5'
#   initial_root_password node['mysql']['initial_root_password']
#   action [:create, :start]
# end

# mysql2_chef_gem 'default' do
#   action :install
# end


# directory '/srv' do
#   owner node['rbox']['user']
#   group node['rbox']['user_group']
#   mode '0755'
#   action :create
# end

# # # projects = {
# # #   'kitaiwan' => {
# # #     'database' => {
# # #       'dbname' => 'olivecms_kitaiwan',
# # #       'host' => '127.0.0.1',
# # #       'username' => 'kitaiwan',
# # #       'password' => 'dE9r4DuF'
# # #     }
# # #   }
# # # }

# # # projects.each do |project, data|

# # #   config = data['database']

# # #   mysql_database config['dbname'] do
# # #     connection(
# # #       :host     => config['host'],
# # #       :username => config['username'],
# # #       :password => config['password']
# # #     )
# # #     action :create
# # #   end

# # # end

# # template "#{ENV['HOME']}/.ssh/config" do
# #   source 'ssh_config.erb'
# #   mode '0600'
# #   owner node['current_user']
# #   group node['current_user']
# # end

