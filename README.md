# Aaron's Chef-Solo

using Knife Solo and Berkshelf

## Install Gems and Cookbooks

```
gem install knife-solo
bundle install
berks install
```

# Update Vagrantfile

Add the box of the site, for Example:

```
config.vm.define :zealotv do |a|
  a.vm.network "forwarded_port", guest: 80, host: 8082
  a.vm.network "private_network", ip: "192.168.33.52"
  a.vm.host_name = 'zealotv'
end
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