module TrainingHelper
    
  def training_question_field(question, person)
    answer = person.get_training_answer(question.id) ? person.get_training_answer(question.id) : TrainingAnswer.new
    date = fancy_date_field(question.safe_name + '_date', answer.completed_at)
    # if is_ministry_leader 
      approver = send('text_field_tag', question.safe_name + '_approver', answer.approved_by )
      approver += '&nbsp;&nbsp;' + link_to_function(image_tag('silk/tick.png'), "$('##{question.safe_name}_approver').val('#{@my.full_name}')") +
                 ' ' +          link_to_function(image_tag('silk/cross.png'), "$('##{question.safe_name}_approver').val('')")
    # else
      # approver = answer.approved_by
    # end
    date += '&nbsp;&nbsp; Approved By: ' + approver.to_s unless approver.blank?
    date
  end

end
