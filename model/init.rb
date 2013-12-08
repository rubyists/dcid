require_relative "../lib/dcid"
require (DCID::ROOT/:options).to_s
require (DCID::LIBROOT/:dcid/:db).to_s
DCID.db.extension :pg_array
Sequel::Model.db = DCID.db
require_relative "area_code"
if DCID.options.tiny_cdr.root
  require File.join(DCID.options.tiny_cdr.root, "lib/tiny_cdr/db")
  require File.join(DCID.options.tiny_cdr.root, "model/call")
  require_relative "call"
end
