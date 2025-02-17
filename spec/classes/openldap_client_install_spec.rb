# frozen_string_literal: true

require 'spec_helper'

describe 'openldap::client::install' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with no parameters' do
        let :pre_condition do
          "class {'openldap::client':}"
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('openldap::client::install') }

        case facts[:osfamily]
        when 'Debian'
          case facts[:operatingsystemmajrelease]
          when '22'
            it {
              is_expected.to contain_package('libldap-2.5-0').with(ensure: :present)
            }
          else
            it {
              is_expected.to contain_package('libldap-2.4-2').with(ensure: :present)
            }
        when 'RedHat'
          it {
            is_expected.to contain_package('openldap').with(ensure: :present)
          }
        end
      end

      context 'when overriding package name' do
        let :pre_condition do
          "class {'openldap::client': package => 'foo', }"
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('openldap::client::install') }

        it {
          is_expected.to contain_package('foo').with(ensure: :present)
        }
      end
    end
  end
end
