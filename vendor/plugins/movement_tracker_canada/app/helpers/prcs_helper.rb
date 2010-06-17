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
 
end
