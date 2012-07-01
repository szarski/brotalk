require File.join(File.dirname(__FILE__), '../../spec_helper')

class MessageBuilderTestClass;end

describe MessageBuilder do
  let(:bros_table_mock) {double("bros table").as_null_object}
  before(:each) do
    @message_builder = MessageBuilderTestClass.new
    @message_builder.extend(MessageBuilder)
  end

  describe "#build_message" do
    let(:prepared_message) {{"message" => "ay bro", "bros_table" => bros_table_mock}}
    let(:message_type) {:greeting}

    before(:each) do
      @message_builder.stub(:prepare_message).and_return(prepared_message)
    end

    it "invokes #prepare_message with message type and bros table" do
      @message_builder.should_receive(:prepare_message).with(message_type, bros_table_mock).
        and_return(prepared_message)
      @message_builder.build_message(message_type, bros_table_mock)
    end

    it "invokes #to_json on prepared_message" do
      prepared_message.should_receive(:to_json) 
      @message_builder.build_message(message_type, bros_table_mock)
    end
  end

  describe "#prepared_message" do
    context "when message_type :greeting" do
      let(:message_type) {:greeting}

      it "sets message to 'ay bro'" do
        @message_builder.prepare_message(message_type, bros_table_mock)["message"].
          should eq("ay bro")
      end
      it "sets bros_table to bros table" do
        @message_builder.prepare_message(message_type, bros_table_mock)["bros_table"].
          should eq(bros_table_mock)
      end
    end


    context "when message_type :message" do
      let(:message_type) {:regular}
      let(:message_body) {"Hello"}

      it "sets message to passed message" do
        @message_builder.prepare_message(message_type, message_body)["message"].
          should eq(message_body)
      end
    end

    context "when message_type :ping" do
      let(:message_type) {:ping}

      it "sets message to 'ping'" do
        @message_builder.prepare_message(message_type)["message"].
          should eq("ping")
      end
    end

    context "when message_type :pong" do
      let(:message_type) {:pong}

      it "sets message to 'pong'" do
        @message_builder.prepare_message(message_type)["message"].
          should eq("pong")
      end
    end

    context "when message_type unknown" do
      let(:message_type) {:unknown_type}
      let(:message_body) {"Hello"}

      it "raises MessageBuilderError exception" do
        lambda {
          @message_builder.prepare_message(message_type, message_body)
        }.should raise_error(MessageBuilderError, "Unknown message type.")
      end
    end
  end
end
