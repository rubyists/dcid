require "csv"
Sequel.migration do
  up do
    csv = CSV.parse(File.read(File.join(File.dirname(__FILE__), "../data/codes.csv")))
    areas = {}
    csv.each do |(_,_,state,city,postal_code,latitude,longitude,_,area_code)|
      next unless area_code
      next if areas[area_code]
      areas[area_code] = {state: state, city: city, postal_code: postal_code, latitude: latitude, longitude: longitude}
    end
    areas.each_pair do |area_code, data|
      DB[:area_codes].insert(state: data[:state], 
                             city: data[:city],
                             code: area_code,
                             the_geom: Sequel.function(:st_geomfromtext, "POINT(%s %s)" % [data[:longitude], data[:latitude]], 4326),
                             postal_code: data[:postal_code])
    end
  end

  down do
    DB[:area_codes].delete
  end
end
