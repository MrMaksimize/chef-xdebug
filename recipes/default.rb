#
# Author:: David King <dking@xforty.com>
# Cookbook Name:: xdebug
# Recipe:: default
#
# Copyright 2012, xforty technologies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "apache2"
include_recipe "php"

# install xdebug apache module
php_pear "xdebug" do
  action :install
end

# copy over xdebug.ini to node
template "#{node['php']['ext_conf_dir']}/xdebug.ini" do
  source "xdebug.ini.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources("service[apache2]"), :delayed
end

# TODO: somehow add this line to php.ini (is this necessary?)
# zend_extension="/usr/local/php/modules/xdebug.so"
