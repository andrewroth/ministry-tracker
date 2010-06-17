module PrcsHelper
  unloadable

  def show_input_lines(prc)
    render :partial => 'prcs/input_lines',
    :locals => {
        :prc => prc
    }
  end
 
end
