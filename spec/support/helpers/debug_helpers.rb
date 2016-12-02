module BarsoomUtils
  module Spec
    module DebugHelpers
      def hostname
        "gridlook.dev"
      end
    end
  end
end

DebugHelpers = BarsoomUtils::Spec::DebugHelpers
