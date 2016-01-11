
mysql_connection_info = {:host => "127.0.0.1",
                         :username => 'root',
                         :password => node['mysql']['initial_root_password']}

node['phpbox']['projects'].each do |name, project|

  if conf = project['mysql']
    mysql_database conf['dbname'] do
      connection mysql_connection_info
      action :create
    end  

    mysql_database_user conf['username'] do
      connection mysql_connection_info
      password conf['password']
      privileges [:all]
      database_name conf['dbname']
      action :grant
    end
  end


  # Apache2 vhost
  template "/etc/apache2/sites-available/#{project['identifier']}.conf" do
    source "apache2_vhost.conf.erb"
    mode '0660'
    owner 'root'
    group 'root'
    variables(:name => name, :vhost => project['apache2_vhost'])
  end

  apache_site project['identifier'] do
    enable true
  end

  directories = project['apache2_vhost']['document_root'].gsub(/^\/|\/$/,'').split('/')
  
  directories.size.times do |i|
    dir = directories[0,i+1].join('/')
    directory "/#{dir}" do
      mode '0755'
      owner node['current_user']
      group node['current_user']
    end
  end
end