vufind-vagrant
==============

A [Vagrant](http://www.vagrantup.com/) configuration for [VuFind](http://vufind.org/).

1. `git clone https://github.com/vufind-org/vufind`
2. `pushd puppet && librarian-puppet install && popd`
3. `vagrant up`
4. `xdg-open http://localhost:8080/vufind/Install` (the MySQL root password has been left blank)

