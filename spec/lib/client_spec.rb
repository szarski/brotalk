require File.join(File.dirname(__FILE__), '../spec_helper')

describe Client do
  describe "#initialize" do
    let(:communicator) {mock}
    let(:translator_receiver) {mock}
    let(:translator_sender) {mock}

    it "initializes the communicator" do
      Communicator::DEFAULT_CLASS.stub(:new).with.and_return communicator
      communicator.stub(:register_listener)
      described_class.new.communicator.should == communicator
    end

    it "initializes the translator receiver with itself as a parent" do
      Translator::Receiver.stub(:new).with{|client| client.is_a?(Client)}.and_return translator_receiver
      described_class.new.translator_receiver.should == translator_receiver
    end

    it "tells communicator to register translator receiver as a listener" do
      Communicator::DEFAULT_CLASS.stub(:new).and_return communicator
      Translator::Receiver.stub(:new).and_return translator_receiver
      communicator.should_receive(:register_listener).with(translator_receiver)
      described_class.new
    end

    it "initializes the translator sender, gives it the communicator on initialization and stores a handler" do
      Translator::Sender.stub(:new).with(communicator).and_return translator_sender
      Client.any_instance.stub(:communicator).and_return communicator
      described_class.new.translator_sender.should == translator_sender
    end

    it "initializes the twitter_wrapper" do
      pending "we don't need this yet"
    end
  end

  describe "#start_with_twitter" do
    it "invokes TwitterWrapper#scan_addresses and issues translator.greet() with each of them and passes #bro_table"
  end

  describe "#start_listening" do
    let(:communicator) {mock}
    before {subject.stub(:communicator).and_return(communicator)}

    it "should call Communicator#start_listening" do
      communicator.should_receive(:start_listening)
      subject.start_listening
    end
  end

  describe "#bro_table" do
    it "should be empty on initialize" do
      Client.new.bros_table.should be_empty
    end
  end

  describe "#update_bros" do
    #it "should update the bro table with new records and issue translator.greet with each of them and the #bro_table"
    let(:communicator_mock) { double("communicator").as_null_object} 

    before do
      subject.instance_variable_set("@bros_table", bro_table_mock)
      subject.instance_variable_set("@communicator", communicator_mock)
    end

    context "when #bros_table is empty" do
      let(:bro_table_mock) { [] } 
      let(:bro_table_update) { Bro.from_json ["1.2.3.1%0","1.2.3.2%0","1.2.3.3%0"] } 

      it "bros table is equal to the incoming records" do
        subject.stub(:greet)
        subject.update_bros(bro_table_update)
        subject.bros_table.should eq(bro_table_update)
      end

      it "greets each bro" do
        subject.should_receive(:greet).exactly(3).times
        subject.update_bros(bro_table_update)
      end
    end

    context "when #bros_table has some existing records" do
      let(:bro_table_mock) { Bro.from_json ["1.1.1.1%0","2.2.2.2%0"] }
      let(:bro_table_update) { Bro.from_json ["3.3.3.3%0", "4.4.4.4%0"] }
      let(:bro_table_updated) { Bro.from_json ["1.1.1.1%0","2.2.2.2%0", "3.3.3.3%0", "4.4.4.4%0"] }

      it "bros table is merged from existing and incoming records" do
        subject.stub(:greet)
        subject.update_bros(bro_table_update)
        subject.bros_table.should eq(bro_table_updated)
      end

      it "greets each bro" do
        subject.should_receive(:greet).exactly(2).times
        subject.update_bros(bro_table_update)
      end
    end

    context "when #bros_table has some common records" do
      let(:bro_table_mock) { Bro.from_json ["1.1.1.1%0", "2.2.2.2%0"] }
      let(:bro_table_update) { Bro.from_json ["2.2.2.2%0", "3.3.3.3%0"] }
      let(:bro_table_updated) { Bro.from_json ["1.1.1.1%0", "2.2.2.2%0", "3.3.3.3%0"] }

      it "bros table is merged from existing and incoming records without "\
        "doubled records" do
        subject.stub(:greet)
        subject.update_bros(bro_table_update)
        subject.bros_table.should eq(bro_table_updated)
      end

      it "greets each bro" do
        subject.should_receive(:greet).exactly(1).times
        subject.update_bros(bro_table_update)
      end
    end
  end

  describe "#supernode?" do
    it "should be false upon initialization" do
      subject.supernode?.should be_false
    end
  end

  describe "#elect!" do
    it "should turn client into a supernode" do
      subject.elect!
      subject.supernode?.should be_true
    end
  end

  describe "#ensure_supernodes!" do
    before {subject.stub(:supernode?).and_return(is_supernode)}
    before {subject.stub(:bros_table).and_return(bros_table)}

    context "subject is a supernode" do
      let(:is_supernode) {true}
      let(:bros_table) {[]}

      context "subject has a supernode in his bros_table" do
        let(:bros_table) {[mock(:supernode? => false),mock(:supernode? => true),mock(:supernode? => false)]}

        it "should not call #elect!" do
          subject.should_receive(:elect!).never
          subject.ensure_supernodes!
        end
      end

      context "subject has no supernodes in his bros_table" do
        let(:bros_table) {[mock(:supernode? => false),mock(:supernode? => false),mock(:supernode? => false)]}

        it "should not call #elect!" do
          subject.should_receive(:elect!).never
          subject.ensure_supernodes!
        end
      end
    end

    context "subject is not a supernode" do
      let(:is_supernode) {false}

      context "subject has a supernode in his bros_table" do
        let(:bros_table) {[mock(:supernode? => false),mock(:supernode? => true),mock(:supernode? => false)]}

        it "should not call #elect!" do
          subject.should_receive(:elect!).never
          subject.ensure_supernodes!
        end
      end

      context "subject doesn't have a supernode in his bros table" do
        let(:bros_table) {[mock(:supernode? => false),mock(:supernode? => false),mock(:supernode? => false)]}

        it "should call #elect!" do
          subject.should_receive(:elect!).once
          subject.ensure_supernodes!
        end
      end
    end
  end

  describe "#clear_bro_table" do
    before {Client.send(:remove_const, :MAX_REGULAR_NODES); Client::MAX_REGULAR_NODES = 3}
    context "bro table has 3 supernodes and MAX_REGULAR_NODES - 1 regular nodes" do
      before {subject.instance_variable_set "@bros_table", [mock(:supernode? => false), mock(:supernode? => true), mock(:supernode? => true), mock(:supernode? => false)]}
      
      it "should not change the bro table" do
        subject.bros_table.size.should == 4
        subject.clear_bro_table
        subject.bros_table.size.should == 4
      end
    end

    context "bro table has 3 supernodes and MAX_REGULAR_NODES + 1 regular nodes" do
      before {subject.instance_variable_set "@bros_table", [mock(:supernode? => false), mock(:supernode? => true), mock(:supernode? => true), mock(:supernode? => false), mock(:supernode? => false), mock(:supernode? => false)]}
      it "should trimm the number of regular nodes to 1" do
        subject.bros_table.size.should == 6
        subject.clear_bro_table
        subject.bros_table.size.should == 5
      end
    end
  end
end
