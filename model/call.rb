module DCID
  class Call < TinyCdr::Call
    def self.who_owns(from, to)
      if from.size > 10
        from = from[-10,10]
      end
      from_called = filter(Sequel.like(:destination_number, from)).order(Sequel.desc(:start_stamp))
      if from_called.count > 0
        @user = from_called.first.username
      else
        took_call = filter(Sequel.like(:caller_id_number, from)).order(Sequel.desc(:start_stamp))
        if took_call.count > 0
          @user = took_call.first.destination_number
        end
      end
    end
  end
end
