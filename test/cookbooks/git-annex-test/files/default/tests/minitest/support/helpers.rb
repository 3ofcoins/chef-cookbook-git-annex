# -*- coding: utf-8 -*-

require 'chef/mixin/shell_out'
require 'wrong'

Wrong.config.alias_assert :expect, override: true

module Cookbooks
  module GitAnnex
    module SpecHelpersMixin
      include Chef::Mixin::ShellOut
      include MiniTest::Chef::Assertions
      include MiniTest::Chef::Context
      include MiniTest::Chef::Resources
      include Wrong::Assert
      include Wrong::Helpers
      def increment_assertion_count
        self.assertions += 1
      end
    end
  end
end

class MiniTest::Spec
  include Cookbooks::GitAnnex::SpecHelpersMixin
end
