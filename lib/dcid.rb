require "pathname"
require 'log4r'
require 'log4r/configurator'

Log4r::Configurator.custom_levels(:DEBUG, :DEVEL, :INFO, :NOTICE, :WARN, :ERROR, :CRIT)

# Allows for pathnames to be easily added to
class Pathname
  def /(other)
    join(other.to_s)
  end
end

# Choose outbound caller id based on location
module DCID
  autoload :VERSION, "dcid/version"
  Log = Log4r::Logger.new("DCID")
  ROOT = (Pathname(__FILE__)/'../..').expand_path
  LIBROOT = ROOT/:lib
  MIGRATION_ROOT = ROOT/:migrations
  MODEL_ROOT = ROOT/:model
  SPEC_HELPER_PATH = ROOT/:spec
end
DCID::Log.outputters = Log4r::StdoutOutputter.new("DCID")
DCID::Log.info "Loaded DCID"
