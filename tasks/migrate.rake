# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software

desc "migrate to latest version of db"
task :migrate, :version do |_, args|
  args.with_defaults(:version => nil)
  require_relative '../lib/dcid'
  require_relative '../lib/dcid/db'
  require 'sequel/extensions/migration'

  raise "No DB found" unless DCID.db

  #require_relative '../model/init'

  require 'nokogiri'
  require 'sequel'

  DB = DCID.db

  if args.version.nil?
    Sequel::Migrator.apply(DCID.db, DCID::MIGRATION_ROOT)
  else
    Sequel::Migrator.run(DCID.db, DCID::MIGRATION_ROOT, :target => args.version.to_i)
  end
end
