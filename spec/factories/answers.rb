FactoryGirl.define do
  factory :answer do
    body 'Answer_for_question'
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
  end
end
