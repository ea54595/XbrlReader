require_relative 'FommatterModule'

class TradeAccountsReceivable
  include FommatterModule

  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :NotesAndAccountsReceivableTrade),
      get_item_form_result(result, :AccountsReceivableTrade),
    ])
  end
end