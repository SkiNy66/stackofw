FactoryGirl.define do
  factory :answer do
    body 'Answer_for_question'
    question
    best 'false'
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
  end
end
