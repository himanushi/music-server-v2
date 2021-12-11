# frozen_string_literal: true

class AllowedAction < ::ApplicationRecord
  MUTATION_ACTIONS = ::Mutation.fields.keys
  public_constant :MUTATION_ACTIONS

  QUERY_ACTIONS = ::Query.fields.keys
  public_constant :QUERY_ACTIONS

  DEFAULT_ACTIONS = ::AllowedAction::QUERY_ACTIONS + %w[login]
  public_constant :DEFAULT_ACTIONS

  CONSOLE_ACTIONS = %w[graphiql console].freeze
  public_constant :CONSOLE_ACTIONS

  ALL_ACTIONS = (
    ::AllowedAction::MUTATION_ACTIONS + ::AllowedAction::DEFAULT_ACTIONS + ::AllowedAction::CONSOLE_ACTIONS
  ).uniq.freeze

  public_constant :ALL_ACTIONS

  belongs_to :role

  validates :name, :role, presence: true
  validates :name, inclusion: { in: ::AllowedAction::ALL_ACTIONS, message: '指定できないアクション(%<value>)' }

  def table_id() = 'ald'
end
