require_relative 'Formats'

class AverageSharesOutstanding < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :NumberOfIssuedAndOutstandingSharesAtTheEndOfFiscalYearIncludingTreasuryStock)
    ])
  end
end