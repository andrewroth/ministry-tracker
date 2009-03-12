# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def times(start_time, end_time)
    midnight = Time.today.beginning_of_day
    # start_time = midnight + start_time.hours
    # end_time = midnight.beginning_of_day + end_time.hours
    time_options = []
    start_time.to_i.step(end_time.to_i, 900) do |time|
      time_options << [(midnight + time).to_s(:time), time]
    end
    time_options
  end
    
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
    flash[:notice] = flash[:warning] = nil
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
      return fancy_date_field(attrib.safe_name, person.get_value(attrib.id))
    end
  end

  def fancy_date_field(name, value)
    value = value.is_a?(Date) ? value.to_s : value
    field = %| 
          <input type="text" name="#{name}" id="#{name}" 
                  value="#{value}" size="13" />
          <script language="javascript">
              function clear_date(item) {
                  $(item).val('');
              }
          </script>
          <a class="button" href="#" id="pick_date_#{name}">pick date</a> \|
          <a class="button" href="javascript:clear_date('#{name}');">clear</a>
          <script type="text/javascript">
            Calendar.setup(
              {
                inputField  : "#{name}", // ID of the input field
                ifFormat    : "#{I18n.t('date.formats.default', :count => '%d')}",    													// the date format
                button      : "pick_date_#{name}",       		// ID of the button
                showsTime		: false,
                showOthers	: true
              }
            );
          </script>|
  end

end
