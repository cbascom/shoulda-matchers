require 'spec_helper'

describe Shoulda::Matchers::ActiveModel::AllowValueMatcher do

  context "an attribute with a format validation" do
    before do
      define_model :example, :attr => :string do
        validates_format_of :attr, :with => /abc/
      end
      @model = Example.new
    end

    it "should pass with a good value when using should" do
      @model.should allow_value("abcde").for(:attr)
    end

    it "should fail with a bad value when using should" do
      expect { @model.should allow_value('xyz').for(:attr) }.
        to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it "should pass with a bad value when using should_not" do
      @model.should_not allow_value("xyz").for(:attr)
    end

    it "should fail with a good value when using should_not" do
      expect { @model.should_not allow_value('abcde').for(:attr) }.
        to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  context "an attribute with a format validation and a custom message" do
    before do
      define_model :example, :attr => :string do
        validates_format_of :attr, :with => /abc/, :message => 'bad value'
      end
      @model = Example.new
    end

    it "should pass with a good value when using should" do
      @model.should allow_value('abcde').for(:attr)
    end

    it "should pass with a good value and matching message when using should" do
      @model.should allow_value('abcde').for(:attr).with_message(/bad/)
    end

    it "should pass with a good value and non-matching message when using should" do
      @model.should allow_value('abcde').for(:attr).with_message(/bogus/)
    end

    it "should fail with a bad value when using should" do
      expect { @model.should allow_value('xyz').for(:attr) }.
        to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it "should fail with a bad value and matching message when using should" do
      expect { @model.should allow_value('xyz').for(:attr).with_message(/bad/) }.
        to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it "should fail with a bad value and non-matching message when using should" do
      expect { @model.should allow_value('xyz').for(:attr).with_message(/bogus/) }.
        to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it "should pass with a bad value when using should_not" do
      @model.should_not allow_value('xyz').for(:attr)
    end

    it "should pass with a bad value and matching message when using should_not" do
      @model.should_not allow_value('xyz').for(:attr).with_message(/bad/)
    end

    it "should fail with a bad value and non-matching message when using should_not" do
      expect { @model.should_not allow_value('xyz').for(:attr).with_message(/bogus/) }.
        to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it "should fail with a good value when using should_not" do
      expect { @model.should_not allow_value('abcde').for(:attr) }.
        to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it "should fail with a good value and matching message when using should_not" do
      expect { @model.should_not allow_value('abcde').for(:attr).with_message(/bad/) }.
        to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it "should fail with a good value and non-matching message when using should_not" do
      expect { @model.should_not allow_value('abcde').for(:attr).with_message(/bogus/) }.
        to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  context "an attribute with several validations" do
    before do
      define_model :example, :attr => :string do
        validates_presence_of     :attr
        validates_length_of       :attr, :within => 1..5
        validates_numericality_of :attr, :greater_than_or_equal_to => 1,
                                         :less_than_or_equal_to    => 50000
      end
      @model = Example.new
    end

    it "should pass with a good value when using should" do
      @model.should allow_value("12345").for(:attr)
    end

    bad_values = [nil, "", "abc", "0", "50001", "123456"]
    bad_values.each do |value|
      it "should pass with bad value (#{value.inspect}) when using should_not" do
        @model.should_not allow_value(value).for(:attr)
      end
    end
  end

end
