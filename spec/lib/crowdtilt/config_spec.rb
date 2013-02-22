require 'spec_helper'

describe "Configuring" do
  it "should exception if configuration hasn't happened" do
    expect {
      Crowdtilt.config
    }.to raise_error("Crowdtilt not initialized, please configure using Crowdtilt.configure")
  end

  describe "defaults" do
    context "env" do
      it "should default to development env" do
        Crowdtilt.configure
        Crowdtilt.config.env.should == 'development'
      end
    end

    context "url" do
      it "should be the sandbox url when the env is development" do
        Crowdtilt.configure
        Crowdtilt.config.url.should == 'https://api-sandbox.crowdtilt.com'
      end

      it "should be the live url when the env is production" do
        Crowdtilt.configure do
          env "production"
        end
        Crowdtilt.config.url.should == 'https://api.crowdtilt.com'
      end
    end
  end

  it "should set the values" do
    Crowdtilt.configure do
      key "abc123"
      secret "foobar"
      env "production"
    end
    Crowdtilt.config.key.should == "abc123"
    Crowdtilt.config.secret.should == "foobar"
    Crowdtilt.config.env.should == "production"
  end
end