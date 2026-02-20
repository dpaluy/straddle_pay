# frozen_string_literal: true

module StraddlePay
  if defined?(Rails)
    class Engine < ::Rails::Engine
      isolate_namespace StraddlePay
    end
  end
end
