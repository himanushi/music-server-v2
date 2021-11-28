# frozen_string_literal: true

module Types
  module Enums
    class ActionEnum < ::Types::Enums::BaseEnum
      # なぜか db:seed が実行できないため
      if ::Rails.const_defined?('Console') || ::Rails.const_defined?('Server')
        ::AllowedAction::ALL_ACTIONS.each do |action|
          value action, value: action
        end
      end
    end
  end
end
