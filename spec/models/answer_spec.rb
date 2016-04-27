require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'Matchers' do
    it { is_expected.to belong_to :question }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :question_id }
  end
end
