# Base library
# include_recipe "basebox::default"
include_recipe 'build-essential::default'

%w(bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev libxslt1.1 libxslt1-dev libxml2 libcurl4-openssl-dev libapr1-dev libaprutil1-dev autoconf automake libtool pkg-config apache2-utils).each do |p|
  package p
end
package 'git'
package 'curl'
package 'vim'
package 'libpq-dev'

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

include_recipe "postgresql::client"
include_recipe "redisio::default"
include_recipe "redisio::enable"
