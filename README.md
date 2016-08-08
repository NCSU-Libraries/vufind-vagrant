# vufind-vagrant-TRLN

A [Vagrant](http://www.vagrantup.com/) configuration for [VuFind](http://vufind.org/) for use in TRLN 

Derived from https://github.com/quartsize/vufind-vagrant This has been updated for CentOS 7/systemd on the guest.

## Requirements (Host OS):

vagrant w/Virtualbox and puppet installed on the host OS.  Once you have succcessfully provisioned the box, you can save it with

`vagrant package --output trln-vufind-quickstart.box`

That will create a large file, but you can provide it to Windows users (or ''nix users that do not have all the requirements -- you still need Vagrant and Virtualbox) and it may work.  This generates a large file (~700MB), which is why we cannot yet provide fully setup boxes and have to rely on provisioning.

## Setup

`./init.sh` -- this clones the vufind repository (see command below) and
attempts to initialize and provision the box.  Most of this is done via puppet, which OS packages, runs composer to fetch VuFind's PHP dependencies, installs files to run the services, starts Apache and Solr daemons, and configures the firewall.

VuFind's files will be in the `vufind` directory which is mounted as `/usr/local/vufind` on the guest.

## Usage

Vufind runs under apache/port 80 on the *guest* OS, exported to port 8080 on the host.  `http://localhost:8080/vufind/Install` will allow you to continue configuration.

Solr runs on port `8080` on the guest, exported to `8088` on the host.  Acccessible via `http://localhost:8088/solr`

1. `git clone https://github.com/vufind-org/vufind`

