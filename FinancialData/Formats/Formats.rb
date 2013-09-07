class Formats
  def self.check_and_merge(merge_target_datas)
    merge_target_datas.compact!
    return nil if merge_target_datas.empty?

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
    return nil if merged.empty?
    merged    
  end
  
  def self.parse_representive(data)
    return nil if data.nil?
    parsed = {}
    data.each do |d| 
      parsed[d[:year]] = d[:value].id2name
    end
    parsed
  end

  def self.get_item_form_result(result, name)
    index = result.index{ |v| v[0][:name] == name}
    return nil if index.nil?
    result[index]
  end
  
  def self.parse_float(v) 
    if v == nil
      return 0
    end
    if v.kind_of?(Symbol)
      v = v.id2name
    end
    unless v.kind_of?(String)
      return v
    end
    v.to_f
  end

end