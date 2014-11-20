#
# Cookbook Name:: tomcat
# Recipe:: ark
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Copyright 2010, Opscode, Inc.
# Copyright 2012, Bryan W. Berry
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

include_recipe "ark"

version = node['tomcat']['version'].to_s
tomcat_version = "tomcat#{node['tomcat']['version'].to_s}"
distro = "debian"

# the sysv init script requires an additional package
if platform? [ "centos","redhat","fedora"]
  distro = "el"
end

user node['tomcat']['user']

directory "/usr/local/tomcat" do
  owner node['tomcat']['user']
end

ark tomcat_version do
  url node['tomcat'][version]['url']
  checksum node['tomcat'][version]['checksum']
  version node['tomcat']['version']
  path  "/usr/local/tomcat"
  home_dir node['tomcat']['home']
  owner node['tomcat']['user']
end

init_script = template tomcat_version do
  path "/etc/init.d/#{tomcat_version}"
  source "tomcat.init.#{distro}.erb"
  owner "root"
  group "root"
  mode "0774"
  variables( :name => tomcat_version)
end

service tomcat_version do
  supports :restart => true, :reload => true, :status => true
  action [:enable, :start]
end

template "/usr/local/#{tomcat_version}/conf/tomcat-users.xml" do
  source "tomcat-users.xml.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/etc/default/#{tomcat_version}" do
  source "default_tomcat.erb"
  owner "root"
  group "root"
  variables(:tomcat => node['tomcat'].to_hash)
  mode "0644"
  notifies :restart, "service[#{tomcat_version}]", :immediately
end

# hello script setting
directory "/usr/local/#{tomcat_version}/webapps/hello" do
  owner node['tomcat']['user']
end

cookbook_file "/usr/local/#{tomcat_version}/webapps/hello/index.html" do
  source "/hello/index.html"
  mode "0644"
end

directory "/usr/local/#{tomcat_version}/webapps/hello/img" do
  owner node['tomcat']['user']
end

cookbook_file "/usr/local/#{tomcat_version}/webapps/hello/img/p1.png" do
  source "/hello/img/p1.png"
  mode "0644"
end

directory "/usr/local/#{tomcat_version}/webapps/hello/WEB-INF" do
  owner node['tomcat']['user']
end

cookbook_file "/usr/local/#{tomcat_version}/webapps/hello/WEB-INF/web.xml" do
  source "/hello/WEB-INF/web.xml"
  mode "0644"
end

directory "/usr/local/#{tomcat_version}/webapps/hello/WEB-INF/classes" do
  owner node['tomcat']['user']
end

cookbook_file "/usr/local/#{tomcat_version}/webapps/hello/WEB-INF/classes/Hello.class" do
  source "/hello/WEB-INF/classes/Hello.class"
  mode "0644"
end

cookbook_file "/usr/local/#{tomcat_version}/webapps/hello/WEB-INF/classes/Hello.java" do
  source "/hello/WEB-INF/classes/Hello.java"
  mode "0644"
end
