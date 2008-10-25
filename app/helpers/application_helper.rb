# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    
  def update_flash(page, msg = nil, level='notice')
    unless msg
      msg = flash[:notice]
      if flash[:warning]
        msg = flash[:warning]
        level = 'warning'
      end
    end
    page.replace_html "flash_#{level}", msg
    page.show "flash_#{level}"
    page.visual_effect :highlight, "flash_#{level}"
    page.delay(5) do
      page.visual_effect :fade, "flash_#{level}"
      page.delay(2) do
        page.replace_html "flash_#{level}", ''
      end
    end
  end

  def date_options(year = Time.now.year - 5)
    {:include_blank => true, :order => [:month, :day, :year], :start_year => year}
  end
  
  def spinner(id='')
    image_tag('spinner.gif', :id => 'spinner'+id.to_s, :style => 'display:none')
  end
  
  def hide_spinner(page, id='')
    page['spinner'+id.to_s].hide
  end
  
  def custom_field(attrib, person)
    case attrib.value_type
    when 'check_box'
      field = eval("check_box_tag('#{attrib.safe_name}_checkbox', '1', #{person.get_value(attrib.id) == 'yes' ? true : false}, 
                                {:onclick => \"alternate('#{attrib.safe_name}')\"})")
      field += hidden_field_tag(attrib.safe_name, person.get_value(attrib.id) || 'no')
      return field
    when 'text_field'
      return send('text_field_tag', attrib.safe_name, person.get_value(attrib.id))
    when 'text_area'
      return send('text_area_tag', attrib.safe_name, person.get_value(attrib.id))
    when 'date_select'
      return fancy_date_field(attrib.safe_name, format_date(person.get_value(attrib.id)))
    end
  end
end

def training_question_field(question, person)
  answer = person.get_training_answer(question.id) ? person.get_training_answer(question.id) : TrainingAnswer.new
  date = fancy_date_field(question.safe_name + '_date', answer.completed_at)
  if is_ministry_leader || @me == person
    approver = send('text_field_tag', question.safe_name + '_approver', answer.approved_by )
    approver += '&nbsp;&nbsp;' + link_to_function('approve', "$('#{question.safe_name}_approver').value = '#{@my.full_name}'")
  else
    approver = answer.approved_by
  end
  date + '&nbsp;&nbsp; Approved By: ' + approver.to_s
end

def fancy_date_field(name, value)
  value = value.is_a?(Date) ? value.strftime("%m/%d/%Y") : value
  field = %| 
        <input type="text" name="#{name}" id="#{name}" 
                value="#{value}" size="13" />
        <script language="javascript">
            function clear_date(item) {
                $(item).val('');
            }
        </script>
        <a class="button" href="#" id="pick_date_#{name}">pick</a> \|
        <a class="button" href="javascript:clear_date('#{name}');">clear</a>
        <script type="text/javascript">
          Calendar.setup(
            {
              inputField  : "#{name}", // ID of the input field
              ifFormat    : "%m/%d/%Y",    													// the date format
              button      : "pick_date_#{name}",       		// ID of the button
              showsTime		: false,
              showOthers	: true
            }
          );
        </script>|
end

def format_date(value=nil)
  return '' if value.to_s.empty?
  time = value.class == Time ? value : Time.parse(value)
  time.strftime('%m/%d/%Y')
end
