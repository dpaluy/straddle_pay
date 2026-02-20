# frozen_string_literal: true

module StraddlePay
  if defined?(Rails)
    # Rails engine for StraddlePay gem integration.
    class Engine < ::Rails::Engine
      isolate_namespace StraddlePay
    end
  end
end
