include_recipe 'nginx::default'
nginx_site 'default' do
  action :disable
end