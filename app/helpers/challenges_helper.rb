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
  def current_link(name, value, text, other_params, opts = {})
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
    final_params = params_hash.merge(name => value)    
    link_to text, challenges_path(final_params), :class => cls
  end
end






