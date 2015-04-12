#!/bin/sh
DEVEL_USER="vagrant"
DEVEL_DIR="/home/vagrant"

setenforce 0

yum -y localinstall https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
yum -y localinstall http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
yum -y localinstall https://fedorapeople.org/groups/katello/releases/yum/nightly/katello/RHEL/7/x86_64/katello-repos-latest.rpm
yum -y localinstall http://yum.theforeman.org/nightly/el7/x86_64/foreman-release.rpm

yum -y install foreman-release-scl
yum -y install ruby rubygems rubygem-kafo katello-devel-installer

time katello-devel-installer --user=${DEVEL_USER} --group=${DEVEL_USER} --deployment-dir=${DEVEL_DIR}

#
#   Seeing issue with katello-devel-installer not using 'bundler' gem for user 'vagrant'
#   Looks like a fix for this was put into katello-devel-installer on 4/10/15, but isn't yet in a RPM repo as of 4/13/15
#
#   Might be a workaround of installing bundler and re-running the katello-devel-installer  
#   re-run katello-devel-installer
#
#su -c "gem install bundler" - vagrant
#time katello-devel-installer --user=${DEVEL_USER} --group=${DEVEL_USER} --deployment-dir=${DEVEL_DIR}
