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
    command     => '/usr/bin/docker build --tag=livegrep:web .',
  } ~>

  docker::run { 'codesearch_worker':
    image           => 'livegrep:codesearch_worker',
    use_name        => true,
    volumes         => ['/disk/blob/home/nibz/sandbox/livegrep/git_repos:/git_repos', '/disk/blob/home/nibz/sandbox/livegrep/indexes:/indexes'],
    dns             => ['8.8.8.8', '8.8.4.4'],
    restart_service => true,
  } ~>

  docker::run { 'web':
    image           => 'livegrep:web',
    use_name        => true,
    links           => ['codesearch_worker:codesearch_worker'],
    volumes         => ['/disk/blob/home/nibz/sandbox/livegrep/git_repos:/git_repos', '/disk/blob/home/nibz/sandbox/livegrep/indexes:/indexes'],
    dns             => ['8.8.8.8', '8.8.4.4'],
    ports           => ['131.252.216.15:8910:8910'],
    restart_service => true,
  }


#}

