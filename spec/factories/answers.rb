FactoryGirl.define do
  sequence :body do |n|
    "Answer_for_question#{n}"
  end
  factory :answer do
    body
    question
    best false
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
  end
end
