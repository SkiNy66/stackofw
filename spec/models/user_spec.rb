require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Matchers' do
    it { is_expected.to have_many(:questions) }
    it { is_expected.to have_many(:answers) }
  end

  context 'Validates' do
    it { should validate_presence_of :email }  
    it { should validate_presence_of :password }
  end
end