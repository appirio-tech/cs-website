require 'spec_helper'

describe ChallengesHelper do
  describe '#current_link' do
    it 'returns a html_safe string' do
      current_link('foo', 'desc', 'foo', 'foo', 'foo', 'foo').should be_html_safe
    end

    it 'has dd class if order is desc' do
      current_link('foo', 'desc', 'foo', 'foo', 'foo', 'foo').to_s.should match("dd")
    end

    it 'has ddasc class if order is asc' do
      current_link('foo', 'asc', 'foo', 'foo', 'foo', 'foo').to_s.should match("ddasc")
    end
  end
end
