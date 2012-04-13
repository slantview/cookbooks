#
# Author::  Steve Rude (<steve@slantview.com>)
# Cookbook Name:: php
# Recipe:: module_xml
#
# Copyright 2012 Slantview Media.
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

pkg = value_for_platform(
    [ "centos", "redhat", "fedora" ] => {"default" => "php-mbstring"},
    "default" => nil
  )


package pkg do
  action :install
  not_if pkg.nil?
end
