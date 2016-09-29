# default['redisio']['package_install'] = true

default['rubybox']['user'] = 'deployer'
default['rubybox']['user_group'] = 'deployer'
default['nginx']['source']['modules'] = [
  "passenger"
]

default['mysql']['initial_root_password'] = 'mysqlsuperadmin'

default['postgresql']['pg_hba'] = [
  {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
  {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'md5'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.0/8', :method => 'md5'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '0.0.0.0/0', :method => 'md5'}
]

default['postgresql']['config']['listen_addresses'] = '*'