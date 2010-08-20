module PrcsHelper
  unloadable

  def show_input_lines(prc)
    render :partial => 'prcs/input_lines',
    :locals => {
        :prc => prc
    }
  end
  
  def show_index_entries(prcs)
    render :partial => 'prcs/index_entries',
    :locals => {
        :prcs => prcs
    }
  end  
  
  def show_data(prc, input_stat)
    result = prc[input_stat[:column]]
    
    if input_stat[:display_type] == :checkbox
      result = prc[input_stat[:column]] == 1 ? "Yes" : "No"

    elsif input_stat[:display_type] == :drop_down

      if input_stat[:drop_down_data] == :prc_method
        prcmethod_id = prc[input_stat[:column]]
        result = Prcmethod.find(prcmethod_id).prcMethod_desc
      end

    end
    result
  end
 
end
