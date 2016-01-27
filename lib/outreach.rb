require "outreach/version"
require "outreach/configuration"
require "outreach/auth"
require "outreach/prospect"
require "outreach/sequence"

module Outreach
  # Permission constants
  CREATE_PROSPECTS_PERMISSION = 'create_prospects'
  READ_PROSPECTS_PERMISSION   = 'read_prospects'
  UPDATE_PROSPECTS_PERMISSION = 'update_prospects'
  READ_SEQUENCES_PERMISSION   = 'read_sequences'
  UPDATE_SEQUENCES_PERMISSION = 'update_sequences'
  READ_TAGS_PERMISSION        = 'read_tags'

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
