require 'sequel'
require_relative "../../options"

module DCID
  @db ||= nil

  def self.db
    return @db if @db
    conn = DCID.options.db
    Log.debug "Connecting to #{conn}"
    @db = Sequel.connect(conn)
  end

  def self.db=(other)
    @db = Sequel.connect(other)
  end
end
