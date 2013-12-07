require_relative "../lib/dcid"
require (DCID::ROOT/:options).to_s
require (DCID::LIBROOT/:dcid/:db).to_s
DCID.db.extension :pg_array
Sequel::Model.db = DCID.db
require_relative "area_code"
