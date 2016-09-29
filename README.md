# Aaron's Chef-Solo

using Knife Solo and Berkshelf

## Install Gems and Cookbooks

```
gem install knife-solo
bundle install
berks install
```

## Update Vagrantfile

Add the box of the site, for Example:

```
config.vm.define :zealotv do |a|
  a.vm.network "forwarded_port", guest: 80, host: 8082
  a.vm.network "private_network", ip: "192.168.33.52"
  a.vm.host_name = 'zealotv'
end
```

Put the SSH Public key to **conf.d/.ssh/id_rsa.pub**

Under this chef-solo directory:

```
cp ~/.ssh/id_rsa.pub ./conf.d/.ssh/id_rsa.pub
```

Launch the VirtualBox

```
vagrant up zealotv
```

## Using the PHP Box

### Setup the node

Add configuration of the node, ex: nodes/zealotv.json

```
{
  "run_list": ["recipe[phpbox]", "recipe[phpbox::project]"],
  "automatic": { "ipaddress": "zealotw" },
  "phpbox": {
    "user": "vagrant",
    "user_group": "vagrant",
    "projects": {
      "foo": {
        "identifier": "foo.com",
        "apache2_vhost": {
          "server_name": "www.foo.com",
          "server_admin": "admin@foo.com",
          "document_root": "/srv/foo/current/public"
        },
        "mysql": {
          "username": "foo",
          "password": "database_password",
          "dbname": "database_name"
        }
      }
    }
  }
}
```

## Run Knife Solo

```
knife solo prepare zealotv
knife solo cook zealotv
```

## TODO

Install Passenger to existed nginx, followed:
https://www.phusionpassenger.com/library/install/nginx/install/oss/trusty/

Ref:
https://supermarket.chef.io/cookbooks/nginx
https://github.com/jamesotron/cookbooks/blob/master/passenger/recipes/install.rb
https://coderwall.com/p/r4lv7w/how-to-install-nginx-with-passenger-using-chef
https://github.com/miketheman/nginx/blob/2.7.x/templates/default/modules/passenger.conf.erb
https://github.com/miketheman/nginx/blob/2.7.x/recipes/passenger.rb