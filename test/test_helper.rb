require 'bundler/setup'
require 'minitest/autorun'
require 'active_model_serializers'
require 'fixtures/poro'

begin
  require 'action_controller'
  require 'action_controller/serialization'
  require 'action_controller/serialization_test_case'

  ActiveSupport.on_load(:after_initialize) do
    if ::ActionController::Serialization.enabled
      ActionController::Base.send(:include, ::ActionController::Serialization)
      ActionController::TestCase.send(:include, ::ActionController::SerializationAssertions)
    end
  end
rescue LoadError
  # rails not installed, continuing
end

# Ensure backward compatibility with Minitest 4
Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

module TestHelper
  Routes = ActionDispatch::Routing::RouteSet.new
  Routes.draw do
    get ':controller(/:action(/:id))'
    get ':controller(/:action)'
  end

  ActionController::Base.send :include, Routes.url_helpers
  ActionController::Base.send :include, ActionController::Serialization
end

ActionController::TestCase.class_eval do
  def setup
    @routes = TestHelper::Routes
  end
end
