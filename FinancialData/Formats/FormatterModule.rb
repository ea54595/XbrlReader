module FommatterModule
  def check_and_merge(merge_target_datas)
    if merge_target_datas.size == 0
      return nil
    end
    merged = {}
    merge_target_datas.each do |data|
      if data == nil
        next
      end
      data.each do |d|
        if merged[d[:year]].nil? 
          merged[d[:year]] = parse_float(d[:value])
        else
          merged[d[:year]] =  parse_float(merged[d[:year]]) + parse_float(d[:value])
        end
      end
    end
    return merged
  end

  def get_item_form_result(result, name)
    index = result.index{ |v| v[0][:name] == name}
    return nil if index.nil?
    result[index]
  end
end