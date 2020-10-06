require 'rails_helper'

RSpec.describe Personal, type: :model do
  context 'associations' do
    it {is_expected.to have_many(:appointments).dependent(:destroy)}
  end
end
