#!/usr/bin/env bash

sudo docker rm -f hills

sudo docker build -t mowat27/hills /vagrant/services/hills \
&& sudo docker run --name hills --network host -d mowat27/hills
