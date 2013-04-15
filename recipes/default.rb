#
# Cookbook Name:: xdebug
# Recipe:: default
#
# Author:: David King, xforty technologies <dking@xforty.com>
# Contributor:: Patrick Connolly, Myplanet Digital <patrick@myplanetdigital.com>
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

include_recipe "php"

package "make" do
  action :install
end

# install xdebug apache module
php_pear "xdebug" do
  version node['xdebug']['version']
  action :install
end

cookbook_file "/usr/share/php5/10_xdebug_disabled.ini" do
  owner "root"
  group "root"
  mode 0644
  source "10_xdebug_disabled.ini"
  action :create
end

cookbook_file "/usr/local/bin/xdebug" do
  owner "root"
  group "root"
  mode 0755
  source "xdebug"
  action :create
end

# copy over xdebug.ini to node
#template "#{node['php']['ext_conf_dir']}/xdebug.ini" do
template "/usr/share/php5/10_xdebug_enabled.ini" do
  source "10_xdebug_enabled.ini.erb"
  owner "root"
  group "root"
  mode 0644
  # TODO: Move logic from template to recipe later?
  # variable( :extension_dir => node['php']['php_extension_dir'] )
  notifies :restart, resources("service[apache2]"), :delayed
end

execute "set-up-xdebug" do
  command "cp /usr/share/php5/10_xdebug_disabled.ini /etc/php5/conf.d"
  #path "/usr/bin:/usr/sbin:/bin:/usr/local/bin:/sbin"
  not_if "test -f /etc/php5/conf.d/10_xdebug_disabled.ini || test -f /etc/php5/conf.d/10_xdebug_enabled.ini"
  action :run
end




file node['xdebug']['remote_log'] do
  owner "root"
  group "root"
  mode "0777"
  action :create_if_missing
  not_if { node['xdebug']['remote_log'].empty? }
end

# TODO: somehow add this line to php.ini (is this necessary?)
# zend_extension="/usr/local/php/modules/xdebug.so"

