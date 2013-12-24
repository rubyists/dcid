module DCID
  class Route < Sequel::Model
    set_dataset DCID.db[:routes]
    def self.available
      AreaCode.owned.all
    end
  end
end
