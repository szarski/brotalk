require File.join(File.dirname(__FILE__), '../spec_helper')

describe TwitterWrapper do
  let(:twitter_mock) {mock("TwitterMock")}
  let(:yaml_mock) {mock("Yaml#load_file").as_null_object}

  before(:each) do
    YAML.stub(:load_file).and_return(yaml_mock)
  end

  describe "#publish_address" do
    let(:hashtag) {"brotalk"}
    let(:ip_address) {"1.2.3.4"}
    let(:message) {"And now something completly different #{ip_address} ##{hashtag}"}
    let(:twitter_update_mock) {mock("TwitterMock#update")}

    before(:each) do
      twitter_mock.stub(:update).with(message).and_return(twitter_update_mock)
      Twitter::Client.stub(:new).and_return(twitter_mock)
    end

    it "invokes Twitter::Client.update with message" do
      twitter_mock.should_receive(:update).with(message)
      subject.publish_address(ip_address, hashtag)
    end
  end

  describe "#scan_addresses" do
    let(:twitter_search_mock) {mock("Twitter#search", :map=>["adssda1.2.3.4asdsda"])}

    before(:each) do
      twitter_mock.stub(:search).with("#brotalk").and_return(twitter_search_mock)
      Twitter::Client.stub(:new).and_return(twitter_mock)
    end

    it "invokes Twitter::Client#search" do
      twitter_mock.should_receive(:search).with("#brotalk")
      subject.scan_addresses("brotalk")
    end

    it "retrieves an array of peer addresses when given a hashtag" do
      subject.scan_addresses("brotalk").should eq(["1.2.3.4"])
    end
  end
end
