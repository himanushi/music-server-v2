# frozen_string_literal: true

class ApplicationController < ::ActionController::Base
  before_action :current_info

  def current_info
    @current_info ||=
      if token.present?
        begin
          session = ::Session.find_by_digit_token!(token)
          { user: session.user, session: session, cookie: request.cookies }
        rescue ::StandardError
          user = ::User.create_user_and_session!
          { user: user, session: user.sessions.first, cookie: request.cookies }
        end
      else
        user = ::User.create_user_and_session!
        { user: user, session: user.sessions.first, cookie: request.cookies }
      end
  end

  def token
    authorization = request.cookies['Authorization']
    (authorization || '').gsub(/\ABearer /, '')
  end
end
