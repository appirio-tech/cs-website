require 'spec_helper'

describe ApplicationHelper do
  describe '#signed_in?' do
    it 'returns true if there is a current user' do
      stub!(:current_user).and_return(1)
      signed_in?.should be_true
    end

    it 'returns false if there is a current user' do
      stub!(:current_user).and_return(nil)
      signed_in?.should be_false
    end
  end

  describe '#format_close_date' do
    it 'returns formatted date' do
      format_close_date(10.minutes.from_now.to_s).should == 'due in 0 hours  10 minutes'
      # TODO - this should return 2 hours instead
      # also the formatting should be fixed (double space)
      format_close_date(2.hours.from_now.to_s).should == 'due in 1 hour  120 minutes'
    end

    it 'returns closed if past date' do
      # TODO - why does one return closed and second Completed?
      format_close_date(1.minute.ago.to_s).should == 'closed'
    end
  end

  describe '#format_close_date_time' do
    it 'returns formated datetime' do
      # TODO - this should return 1 day instead
      format_close_date_time(1.day.from_now.to_s).should == 'due in 0 days 23 hours 60 minutes'
    end

    it 'returns closed if past date' do
      format_close_date_time(1.minute.ago.to_s).should == 'Completed'
    end
  end
end
