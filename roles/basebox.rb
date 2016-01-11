name "basebox"

description "Basic infrastructure for all servers."

run_list [
  "recipe[apt]",
  "recipe[base]"
  # "recipe[shell]",
  # "recipe[users]"
]

default_attributes(
  # recipe[base]
  "rbenv" => {
    :install_prefix =>  "/usr/local",
    :install_ruby   => ["1.9.3-p484"],
    :global_ruby    =>  "1.9.3-p484"
  },
  # "ruby_build" => {
  #   :git_revision => "9cd77be141e066b968b4a7e72d0628c671e067e4",
  #   :version => "20140110.1"
  # },
  :nodejs => {
    :install_method => "package"
  },
  # recipe[users]
  :users => {
    :deployer => {
      :auth_keys => {
        :admins => ["atk", "roman", "evadne", "oleh" ]
      }
    }
  },
  # recipe[sudo]
  :authorization => {
    :sudo => {
      :sudoers_defaults => [
        '!env_reset',
        'secure_path="/usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'],
      :groups => [ "admin", "deployer" ],
      :passwordless => true,
      :include_sudoers_d => true
    }
  }
)
