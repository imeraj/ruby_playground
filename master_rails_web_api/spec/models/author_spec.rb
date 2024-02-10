require 'rails_helper'

RSpec.describe Author, type: :model do
  %i[given_name family_name].each do |field|
    it { is_expected.to validate_presence_of(field) }
  end

  it { should have_many(:books) }

  it 'has a valid factory' do
    expect(build(:author)).to be_valid
  end
end
