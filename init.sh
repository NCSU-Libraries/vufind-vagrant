#!/bin/sh

[[ ! -d vufind ]] && git clone https://github.com/vufind-org/vufind

vagrant up --provider virtualbox 
