default['apache']['keepalive'] = 'Off'
default['mysql']['initial_root_password'] = 'mysqlsuperadmin'
default['phpbox']['user'] = 'deployer'
default['phpbox']['user_group'] = 'deployer'
default['phpbox']['projects'] = []
default['rbenv']['install_ruby'] = '2.2.2'

# default['php']['install_method'] = 'package'
# default['php']['packages'] = %w(php5-imagick php5-curl php5-gd php5-memcache php5-mysql php5-cli)

# default['authorization']['sudo'] = {
#   "groups" => ["admin", "wheel"],
#   "users" => ["deployer", "atk"],
#   "passwordless" => true
# }