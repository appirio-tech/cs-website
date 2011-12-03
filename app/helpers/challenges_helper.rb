module ChallengesHelper  
  
  # 
  # name         - param name
  # value        - param value
  # text         - link text to be displayed in the menu
  # other_params - additonal params to be perserved, such as other sorting
  # opts         - hash of options, currently used for setting if the item is active
  #                by default and if there are any additional classes to keep, such
  #                as for the down arrow
  # 
  def current_link(selected, selected_order, name, value, text, other_params, opts = {})
    p "========== selected:#{selected} - selected_order:#{selected_order} - name:#{name} - value:#{value} - text:#{text} - other_params:#{other_params} - opts:#{opts}"
    cls = ""
    if params[name] == value 
      cls = "active"
    # we also want to highlight if it's the default and the parameter isn't set
    elsif opts[:default] == true && !params.has_key?(name)
      cls = "active"
    end
    cls += " #{opts[:class]}" if opts.has_key?(:class)
        
    # merge with any additonal sorting that was already applied
    params_hash = {}
    [*other_params].each do |p|
      params_hash[p] = params[p] 
    end
    
    # set the sorting arrow
    if value.eql?(selected)
      if selected_order.eql?('asc')
        cls += " ddasc"
        # change the name of the field to desc
        params_hash['orderby_dir'] = 'desc'
      else
        cls += " dd" 
      end
      
    end
    
    # add the category if present
    params_hash[:category] = params[:category] unless params[:category].nil?
    
    # add the search keyword if present
    params_hash[:keyword] = params[:keyword] unless params[:keyword].nil?
    
    final_params = params_hash.merge(name => value)    
    
    link_to text, challenges_path(final_params), :class => cls
  end
end






