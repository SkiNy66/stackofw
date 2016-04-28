FactoryGirl.define do
  factory :answer do
    body 'Answer_for_question'
    question_id 1
  end
  
  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
