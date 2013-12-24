Sequel.migration do
  up do
    create_table :routes do
      primary_key :id
      String :cid, :null => false
      String :number
      String :route, :null => false, :default => 'default'
    end
  end

  down do
    drop_table :routes
  end
end
