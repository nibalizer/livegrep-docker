#class openstack_project::livegrep (
#)
#{

#  user { 'livegrep':
#    ensure => present,
#  } ->
#  group { 'livegrep':
#    ensure => present,
#  } ->
  #include docker

  vcsrepo { "/tmp/livegrep":
    ensure   => latest,
    provider => git,
    revision => 'master',
    source   => 'https://github.com/nibalizer/livegrep.git',
  } ~>

  exec { 'build docker for livegrep base':
    provider    => 'shell',
    #refreshonly => true, #disabled for testing
    cwd         => '/disk/blob/home/nibz/sandbox/livegrep',
    command     => '/usr/bin/docker build --tag=livegrep .',
  } ~>

  exec { 'build docker for codesearch_worker':
    provider    => 'shell',
    #refreshonly => true,
    cwd         => '/disk/blob/home/nibz/sandbox/livegrep/codesearch_worker',
    command     => '/usr/bin/docker build --tag=livegrep:codesearch_worker .',
  } ~>

  exec { 'build docker for livegrep_web':
    provider    => 'shell',
    #refreshonly => true,
    cwd         => '/disk/blob/home/nibz/sandbox/livegrep/livegrep_web',
    command     => '/usr/bin/docker build --tag=livegrep:livegrep_web .',
  } ~>

  docker::run { 'livegrep:codeesearch_worker':
    image           => 'livegrep:codesearch_worker',
    command         => '/bin/sh -c "while true; do echo hello world; sleep 1; done"', 
    expose          => ['9999'],
    dns             => ['8.8.8.8', '8.8.4.4'],
    restart_service => true,
  } ~>

  docker::run { 'livegrep:livegrep_web':
    image           => 'livegrep:livegrep_web',
    command         => '/bin/sh -c "while true; do echo hello world; sleep 1; done"', 
    expose          => ['9999'],
    dns             => ['8.8.8.8', '8.8.4.4'],
    restart_service => true,
  }


#}

