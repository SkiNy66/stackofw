require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'Matchers' do
    it { is_expected.to belong_to :question }
    it { is_expected.to belong_to :user }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :question_id }
    it { is_expected.to validate_presence_of :user_id }
  end
end
