#!/bin/bash -e

apt-get -y -q install canboat

systemctl disable canboat.service
