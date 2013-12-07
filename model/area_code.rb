module DCID
  class AreaCode < Sequel::Model
    using DCID
    dataset_module do
      def owned
        exclude(numbers: nil)
      end
    end

    def <<(number)
      if numbers.nil?
        self.numbers = Sequel.pg_array [number]
      else
        self.numbers << number
      end
    end

    def add_number(number)
      self << number
      save
    end

    def closest
      all_distances_from_me.first
    end

    def best_match
      return self if numbers
      if (my_state = codes_in_my_state.all).size > 0
        my_state[rand(my_state.size)]
      else
        closest_i_own
      end
    end

    def closest_i_own
      distances_from_me.first
    end

    def all_distances_from_me
      AreaCode.select(:code, :city, :state, :numbers){ |o| o.st_distance(:the_geom, the_geom)}.order(:st_distance)
    end

    def distances_from_me
      AreaCode.select(:code, :city, :state, :numbers){ |o| o.st_distance(:the_geom, the_geom)}.owned.order(:st_distance)
    end

    def all_codes_in_my_state
      AreaCode.filter(state: self.state).select(:code, :city, :state, :numbers)
    end

    def codes_in_my_state
      AreaCode.owned.filter(state: self.state).select(:code, :city, :state, :numbers)
    end
  end
end
