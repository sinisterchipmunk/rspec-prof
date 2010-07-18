require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RSpecProf do
  # I'm still at a loss as to how to spec extensions to rspec short of just using the extension.
  
  shared_examples_for "profiling rspec" do
    it "should profile rspec" do
      # uhh, how to measure success?
      sleep(1)
    end
  end
  
  context "a context" do
    profile do
      it_should_behave_like "profiling rspec"
    end
    
    profile :printer => :graph do
      it_should_behave_like "profiling rspec"
    end
    
    profile :measure_mode => "wall_time", :printer => :graph do
      it_should_behave_like "profiling rspec"
    end
    
    profile :file => StringIO.new("") do
      it_should_behave_like "profiling rspec"
    end
    
    profile :min_percent => 0.01 do
      it_should_behave_like "profiling rspec"
    end
    
    profile :each do
      it_should_behave_like "profiling rspec"
    end
  end
  
  context "profile multiple" do
    profile :all do
      it "should profile 1" do sleep(1); end
      it "should profile 2" do 100000.times { }; end
    end
  end
end
