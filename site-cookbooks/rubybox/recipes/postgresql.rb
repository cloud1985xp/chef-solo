include_recipe 'build-essential'
include_recipe "postgresql::default"
include_recipe "postgresql::server"
# include_recipe "database::postgresql"
include_recipe "postgresql::server_conf"
include_recipe "postgresql::ruby"