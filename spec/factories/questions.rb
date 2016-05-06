FactoryGirl.define do
  factory :question do
    title 'Question_1'
    body 'Question_text'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
