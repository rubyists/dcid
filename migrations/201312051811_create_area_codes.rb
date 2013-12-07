Sequel.migration do
  up do
    create_table :area_codes do
      primary_key :id
      String :code
      String :city
      String :state
      String :postal_code
      column :numbers, "text[]"
    end
    run "create extension postgis"
    run "select addgeometrycolumn('area_codes', 'the_geom', 4326, 'POINT', 2)"
  end

  down do
    drop_table :area_codes
    run "drop extension postgis cascade"
  end
end
