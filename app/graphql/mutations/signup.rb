# frozen_string_literal: true

module Mutations
  class Signup < ::Mutations::BaseMutation
    description 'サインアップ'

    argument :name, ::String, required: true
    argument :username, ::String, required: true
    argument :new_password, ::String, required: true
    argument :new_password_confirmation, ::String, required: true

    field :current_user, ::Types::Objects::CurrentUserObject, null: true

    def use_recaptcha?() = true

    def mutate(name:, username:, new_password:, new_password_confirmation:)
      # 登録済みは正常終了
      if context[:current_info][:user].registered
        return {
          current_user: context[:current_info][:user]
        }
      end

      unless new_password.present?
        raise(::GraphQL::ExecutionError.new('パスワードは必須です', extensions: { code: 'INVALID_VALUE', path: 'new_password' }))
      end

      attrs = {
        name: name,
        username: username,
        password: new_password,
        password_confirmation: new_password_confirmation,
        registered: true,
        role: ::Role.login
      }

      # 設定したら全てのセッションを削除しセッション作成
      ::ActiveRecord::Base.transaction do
        context[:current_info][:user].update!(attrs)
        context[:current_info][:user].sessions.delete_all
        context[:current_info][:session] = context[:current_info][:user].create_session
      end

      {
        current_user: context[:current_info][:user]
      }
    end
  end
end
