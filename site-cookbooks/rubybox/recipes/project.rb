require 'securerandom'

pg_conn = node['postgresql'] && {
  :host => "127.0.0.1",
  :port => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

mysql_conn = node['mysql'] && {
  :host => "127.0.0.1",
  :username => 'root',
  :password => node['mysql']['initial_root_password']
}

def setup_postgresql_database(conn, dbconfig)
  postgresql_database_user dbconfig['username'] do
    connection conn
    password dbconfig['password']
    action :create
  end

  postgresql_database dbconfig["database"] do
    connection conn
    action :create
  end

  postgresql_database_user dbconfig['username'] do
    connection conn
    action :grant
    privileges    [:all]
    database_name dbconfig["database"]
  end
end

def setup_mysql_database(conn, dbconfig)
  mysql_database dbconfig['database'] do
    connection conn
    action :create
  end

  mysql_database_user dbconfig['username'] do
    connection conn
    password dbconfig['password']
    privileges [:all]
    database_name dbconfig['database']
    action :grant
  end
end

directory "/srv" do
  owner node['rubybox']['user']
  group node['rubybox']['user_group']
  action :create
end

node['rubybox']['projects'].each do |identifier, project|
  directory "/srv/#{identifier}" do
    owner node['rubybox']['user']
    group node['rubybox']['user_group']
  end

  directory "/srv/#{identifier}/shared" do
    owner node['rubybox']['user']
    group node['rubybox']['user_group']
  end

  directory "/srv/#{identifier}/shared/config" do
    owner node['rubybox']['user']
    group node['rubybox']['user_group']
  end

  # template "/srv/#{identifier}/shared/config/secrets.yml" do
  #   source "secrets.yml.erb"
  #   mode '0660'
  #   owner node['rubybox']['user']
  #   group node['rubybox']['user_group']
  #   variables(:environment => project['environment'], secret_key_base: SecureRandom.hex(64))
  #   not_if do
  #     File.exist?('/srv/#{identifier}/shared/config/secrets.yml')
  #   end
  # end

  databases = Array(project['databases'])

  if databases.any?
    databases.each do |dbconfig|
      case dbconfig['adapter']
      when 'postgres', 'postgresql'
        setup_postgresql_database(pg_conn, dbconfig)
      when /mysql/
        setup_mysql_database(mysql_conn, dbconfig)
      else
        raise "Not Support: #{dbconfig['adapters']}"
      end
      # postgresql_database_user dbconfig['user'] do
      #   connection conn
      #   password dbconfig['password']
      #   action :create
      # end

      # postgresql_database dbconfig["name"] do
      #   connection conn
      #   action :create
      # end

      # postgresql_database_user dbconfig['user'] do
      #   connection conn
      #   # password '8_#Uc6aZajAk'
      #   action :grant
      #   privileges    [:all]
      #   database_name dbconfig["name"]
      # end
    end

    dbconfig = databases.detect { |d| d['environment'] == project['environment'] }

    template "/srv/#{identifier}/shared/config/database.yml" do
      source "database.yml.erb"
      mode '0660'
      owner node['rubybox']['user']
      group node['rubybox']['user_group']
      variables(:environment => project['environment'], :config => dbconfig)
    end
  end

  template "/etc/nginx/sites-available/#{identifier}" do
    source "nginx_vhost.erb"
    mode '0660'
    owner 'root'
    group 'root'
    variables(:identifier => identifier, environment: project['environment'], :vhost => project['vhost'])
  end

  nginx_site identifier

  # Install required packages

  Array(project['packages']).each do |p|
    package p
  end
end

# mysql_connection_info = {:host => "127.0.0.1",
#                          :username => 'root',
#                          :password => node['mysql']['initial_root_password']}

# Array(node['rubybox']['mysql']).each do |mysql|

#   mysql_database mysql['dbname'] do
#     connection mysql_connection_info
#     action :create
#   end

#   mysql_database_user mysql['username'] do
#     connection mysql_connection_info
#     password mysql['password']
#     privileges [:all]
#     database_name mysql['dbname']
#     action :grant
#   end
# end

# mysql_connection_info = {:host => "127.0.0.1",
#                          :username => 'root',
#                          :password => node['mysql']['initial_root_password']}

# node['phpbox']['projects'].each do |name, project|

#   if conf = project['mysql']
#     mysql_database conf['dbname'] do
#       connection mysql_connection_info
#       action :create
#     end

#     mysql_database_user conf['username'] do
#       connection mysql_connection_info
#       password conf['password']
#       privileges [:all]
#       database_name conf['dbname']
#       action :grant
#     end
#   end


#   # Apache2 vhost
#   template "/etc/apache2/sites-available/#{project['identifier']}.conf" do
#     source "apache2_vhost.conf.erb"
#     mode '0660'
#     owner 'root'
#     group 'root'
#     variables(:name => name, :vhost => project['apache2_vhost'])
#   end

#   apache_site project['identifier'] do
#     enable true
#   end

#   directories = project['apache2_vhost']['document_root'].gsub(/^\/|\/$/,'').split('/')

#   directories.size.times do |i|
#     dir = directories[0,i+1].join('/')
#     directory "/#{dir}" do
#       mode '0755'
#       owner node['current_user']
#       group node['current_user']
#     end
#   end
# end