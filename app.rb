require "innate"
require_relative "lib/dcid"
require_relative "options"

require_relative "./model/init"

#require_relative "lib/tiny_call_center/utils/fsr"
DCID::Log.level = Log4r.const_get(DCID.options.log_level)

require_relative 'node/main'
require_relative 'node/lookup'

module Innate
  class Request
    def accept_language(string = env['HTTP_ACCEPT_LANGUAGE'])
      return [] unless string

      accept_language_with_weight(string).map{|lang, weight| lang }
    end
    alias locales accept_language

    def accept_language_with_weight(string = env['HTTP_ACCEPT_LANGUAGE'])
      string.to_s.gsub(/\s+/, '').split(',').
        map{|chunk|        chunk.split(';q=', 2) }.
        map{|lang, weight| [lang, weight ? weight.to_f : 1.0] }.
        sort_by{|lang, weight| -weight }
    end
  end
end

class WorkAroundRackStatic
  def initialize(app)
    @app = app
    @static = Rack::Static.new(
      @app,
      urls: %w[/bootstrap /css /stylesheets /js /images],
      root: "public",
      cache_control: 'public'
    )
  end

  def call(env)
    warn "calling WorkAroundRackStatic"
    warn env['PATH_INFO']
    if env['PATH_INFO'] == '/'
      @app.call(env)
    else
      @static.call(env)
    end
  end
end

Innate.middleware :live do
  use Rack::CommonLogger
  use Rack::ShowExceptions
  use Rack::ETag
  use Rack::ConditionalGet
  use Rack::ContentLength
  use WorkAroundRackStatic
  use Rack::Reloader
  run Innate.core
end

Innate.middleware :dev do
  use Rack::CommonLogger
  use Rack::ShowExceptions
  use Rack::ETag
  use Rack::ConditionalGet
  use Rack::ContentLength
  use WorkAroundRackStatic
  use Rack::Reloader
  run Innate.core
end


Rack::Mime::MIME_TYPES['.coffee'] = 'text/coffeescript'

if $0 == __FILE__
  Innate.start :file => __FILE__
end
