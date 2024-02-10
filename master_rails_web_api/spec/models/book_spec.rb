require 'rails_helper'

RSpec.describe Book, type: :model do
  %i[title released_on author isbn_10 isbn_13].each do |field|
    it { is_expected.to validate_presence_of(field) }
  end

  %i[isbn_10 isbn_13].each do |field|
    it { is_expected.to validate_uniqueness_of(field).case_insensitive }
  end

  subject { create(:agile_web_development) }
  it { should validate_length_of(:isbn_10).is_equal_to(10) }
  it { should validate_length_of(:isbn_13).is_equal_to(13) }

  it { should belong_to(:publisher).optional }
  it { should belong_to(:author) }

  it 'has a valid factory' do
    expect(build(:book)).to be_valid
  end
end
