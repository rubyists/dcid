require 'innate'
require 'pgpass'

module DCID
  include Innate::Optioned

  pgpass = lambda{|options|
    Log.info "Connecting to #{options}"
    begin
      if found = Pgpass.match(options)
        found.to_url
      else
        raise "No entry in .pgpass for %p" % [options]
      end
    rescue
      raise "No entry in .pgpass for %p" % [options]
    end
  }

  options.dsl do
    o "SIP External Proxy Server Format String (To make calls to PSTN)", :proxy_server_fmt,
      ENV["TCC_ProxyServerFormatString"] || 'sofia/gateway/default/%s'

    sub :tiny_cdr do
      o 'TinyCdr postgres database uri', :db,
        ENV["DCID_TinyCdrDB"] || pgpass.(database: 'tiny_cdr')
      o 'TinyCdr couch db uri', :couch_uri,
        ENV["DCID_TinyCdrCouchURI"]
    end

    o "Log Level (DEBUG, DEVEL, INFO, NOTICE, ERROR, CRIT)", :log_level,
      ENV["DCID_LogLevel"] || "INFO"

    o "Sequel Database URI (adapter://user:pass@host/database)", :db,
      ENV["DCID_DB"] || pgpass.(database: 'dcid')

    o "Mode for spec", :mode,
      ENV['TCC_Mode'] || 'live'
  end
end
