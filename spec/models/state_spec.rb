require 'spec_helper'

describe State do
  it 'is created when all attributes are valid' do
    build(:state).should be_valid
  end

  describe '.name' do
    it 'is required' do
      build(:state, name: '').should be_invalid
    end

    it 'does not allow numbers' do
      names = ['Fail5', '234554', 12_345]
      names.each do |name|
        build(:state, name: name).should be_invalid
      end
    end
  end

  describe '.abbr (abbreviation)' do
    it 'requires an abbreviation' do
      build(:state, abbr: '').should be_invalid
    end

    it 'restricts abbreviations to two letters' do
      abbrs = %w(ABCDEF F Fla)
      abbrs.each do |abbr|
        build(:state, abbr: abbr).should be_invalid
      end
    end

    it 'does not allow numbers in the abbreviation' do
      abbrs = ['24', '1', '12345', 56_789, 2, 22]
      abbrs.each do |abbr|
        build(:state, abbr: abbr).should be_invalid
      end
    end
  end
end
