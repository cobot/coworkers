module QuestionsHelper
  def question_input_tags(question, i, answers)
    hidden_field_tag("answers[#{i}][question]", question.id) +
    label_tag("answers_#{i}_text", question.text) +
    send(input_type(question), "answers[#{i}][text]", answer_for(question, answers))
  end
  
  def input_type(question)
    case question.type
    when 'short_text'
      :text_field_tag
    when 'long_text'
      :text_area_tag
    end
  end
  
  def answer_for(question, answers)
    if answer = answers.find{|a| a.question_id == question.id}
      answer.text
    end
  end
end