require File.join(File.dirname(__FILE__), '../../spec_helper')

class MessageParserTestClass;end

describe MessageParser do
  before(:each) do
    @message_parser = MessageParserTestClass.new
    @message_parser.extend(MessageParser)
  end

  describe "#parse_message" do
    let(:raw_message) { "{\"message\":\"hello\"}" }
    let(:parsed_json) {{"message" => "hello"}}

    before(:each) do
      @message_parser.stub(:parse_json).and_return(parsed_json)
    end

    it "invokes #parse_json with raw_message" do
      @message_parser.should_receive(:parse_json).with(raw_message).
        and_return(parsed_json)
      @message_parser.parse_message(raw_message)
    end

    context "when greetings" do
      let(:raw_message) { "{\"message\":\"ay bro\",\"bros\":[1,2,3]}" }
      let(:parsed_json) {{"message" => "ay bro", "bros" => [1,2,3]}}

      it "sets :message_type => :greetings" do
        @message_parser.parse_message(raw_message)[:message_type].should eq(:greetings)
      end
    end

    context "when regular message" do
      let(:raw_message) { "{\"message\":\"hello\"}" }
      let(:parsed_json) {{"message" => "hello"}}

      it "sets :message_type => :regular" do
        @message_parser.parse_message(raw_message)[:message_type].should eq(:regular)
      end
    end

    context "when broken message" do
      let(:raw_message) { "blah blah"}
      let(:parsed_json) {{}}

      it "sets :message_type => :broken" do
        @message_parser.parse_message(raw_message)[:message_type].should eq(:broken)
      end
    end
  end

  describe "#parse_json" do
    let(:raw_message) { "{\"message\":\"hello\"}" }
    it "invokes JSON.parse with raw_message" do
      JSON.should_receive(:parse).with(raw_message)
      @message_parser.parse_json(raw_message)
    end

    context "when parses valid message" do
      before(:each) do
        JSON.stub(:parse).and_return({"message" => "hello"})
      end

      it "returns Hash" do
        @message_parser.parse_json(raw_message).should be_a(Hash)
      end

      it "returns message equal 'hello'" do
        @message_parser.parse_json(raw_message)["message"].should eq("hello")
      end
    end

    context "when parses broken message" do
      let(:raw_message) { "blah blah" }

      before(:each) do
        JSON.stub(:parse).and_raise(JSON::ParserError)
      end

      it "does not raise JSON::ParserError on broken message" do
        lambda {
          @message_parser.parse_json(raw_message)
        }.should_not raise_error(JSON::ParserError)
      end

      it "returns empty Hash" do
        @message_parser.parse_json(raw_message).should eq({})
      end
    end
  end
end
