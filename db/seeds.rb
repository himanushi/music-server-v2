# frozen_string_literal: true

::ActiveRecord::Base.transaction do
  ::Role.create!(name: 'admin', description: '管理者') do |role|
    ::AllowedAction::ALL_ACTIONS.each do |action_name|
      role.allowed_actions.new(name: action_name)
    end
  end

  ::Role.create!(name: 'default', description: '未ログイン') do |role|
    ::AllowedAction::DEFAULT_ACTIONS.each do |action_name|
      role.allowed_actions.new(name: action_name)
    end
  end

  ::Role.create!(name: 'login', description: 'ログイン済み') do |role|
    ::AllowedAction::DEFAULT_ACTIONS.each do |action_name|
      role.allowed_actions.new(name: action_name)
    end
  end

  password = "#{::SecureRandom.hex(3)}aA1"
  username = ::SecureRandom.hex(3)

  puts "/login [username: #{username},  password: #{password}]"
  ::User.create!(name: 'admin', username: username, role: ::Role.find_by!(name: 'admin'), password: password)
end
