require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'Matchers' do
    it { should have_many(:answers).dependent(:destroy) }
  end

  context 'Validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end
end
