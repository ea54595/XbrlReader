require_relative 'FommatterModule'

class Inventories
  include FommatterModule
  
  def self.calcuate(result)
    goods = get_item_form_result(result, :MerchandiseAndFinishedGoods),
    process = get_item_form_result(result, :WorkInProcess),
    supplies = get_item_form_result(result, :RawMaterialsAndSupplies),

    if goods.nil? && process.nil? && supplies.nil?
      check_and_merge([
        get_item_form_result(result, :Inventories),
      ])
    else
    check_and_merge([
      goods,
      process,
      supplies,
    ])
  end

end