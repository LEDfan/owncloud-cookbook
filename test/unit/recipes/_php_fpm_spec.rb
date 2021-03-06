# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2015 Xabier de Zuazo
# License:: Apache License, Version 2.0
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

require_relative '../spec_helper'

describe 'owncloud::_php_fpm' do
  let(:chef_runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  before { stub_php_fpm_cookbook }

  it 'include php-fpm recipe' do
    expect(chef_run).to include_recipe('php-fpm')
  end

  it 'creates php FPM pool' do
    expect(chef_run).to create_template(
      "#{node['php-fpm']['pool_conf_dir']}/owncloud.conf"
    )
  end

  it 'uses the default service provider for php-fpm' do
    expect(chef_run).to enable_service('php-fpm')
      .with_provider(nil)
  end

  context 'on Ubuntu 15.04' do
    # Ubuntu 15.04 still not supported by fauxhai
    before do
      node.automatic['platform_family'] = 'debian'
      node.automatic['platform'] = 'ubuntu'
      node.automatic['platform_version'] = '15.04'
    end

    it 'uses Debian service provider for php-fpm' do
      expect(chef_run).to enable_service('php-fpm')
        .with_provider(Chef::Provider::Service::Debian)
    end
  end # context on Ubuntu 15.04
end
