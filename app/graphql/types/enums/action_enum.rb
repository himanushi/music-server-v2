# frozen_string_literal: true

module Types
  module Enums
    class ActionEnum < ::Types::Enums::BaseEnum
      ::AllowedAction.all_actions.each do |action|
        value action, value: action
      end
    end
  end
end
