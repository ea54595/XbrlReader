require_relative 'Formats'

class TradeAccountsReceivable < Formats

  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :NotesAndAccountsReceivableTrade),
      get_item_form_result(result, :AccountsReceivableTrade)
    ])
  end
end