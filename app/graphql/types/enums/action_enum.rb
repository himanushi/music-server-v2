# frozen_string_literal: true

module Types
  module Enums
    class ActionEnum < ::Types::Enums::BaseEnum
      ::AllowedAction::ALL_ACTIONS.each do |action|
        value action, value: action
      end
    end
  end
end
