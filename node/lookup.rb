module DCID
  class Lookup
    Innate.node '/lookup', self

    provide(:html, {:type => "text/xml", :engine => :Etanni})

    def index(from, to)
      to_code = AreaCode[code: to[0,3]]
      if to_code
        best = to_code.best_match
        @num = best.numbers[rand(best.numbers.count)]
      else
        nums = AreaCode.owned.all
        @num = nums[rand(nums.count)]
      end
    end
  end
end
