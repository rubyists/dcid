require "pathname"
begin
  require "bacon"
rescue LoadError
  require "rubygems"
  require "bacon"
end

begin
  if (local_path = Pathname.new(__FILE__).dirname.join("..", "lib", "dcid.rb")).file?
    require_relative File.join("..", local_path)
  else
    require "dcid"
  end
rescue LoadError
  require "rubygems"
  require "dcid"
end

Bacon.summary_on_exit

describe "Spec Helper" do
  it "Should bring our library namespace in" do
    DCID.should == DCID
  end
end


