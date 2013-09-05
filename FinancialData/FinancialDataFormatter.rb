#$KCODE="utf8"
require File.expand_path(File.dirname(__FILE__) + "/FinancialData")
require File.expand_path(File.dirname(__FILE__) + "/StockPriceGetter")
require "csv"
require "kconv"

class FinancialDataFormatter

  def initialize(f_data, stock_code)
    @base = f_data
    @result = f_data.result
    @stock_code = stock_code
    @CashAndCashEquivalents 
    @OtherFinancialAsset
    @TradeAccountsReceivable
    @Inventories
    @AccountsPayableAndAccrued
    @ShortTermDebt
    @LongTermDebt
    @TotalCurrentLiabikities
    @TreasuryStock
    @TotalEquity
    @TotalLiabilitiesAndEquity 
    @ShareholdersEquity
    @NetOperationgRevenues 
    @CostOfSales
    @GrossProfit
    @SellingGeneralAndAdministrativeExpenses
    @OperatingIncome
    @InterestExpenses
    @IncomeTaxes
    @CurrentNetIncome
    @EarningsPerShare
    @AverageSharesOutstanding
    @DepreciationCost
    @NetCashProvidedByOperatingActivities
    @CapitalExpenditure
    @PurchasesOfStockForTreasury
    @Dividends
    @NameRepresentative
    @stockPrice
    set_financial_data
  end

  def output_csv
    name = @base.edinet[0].documentInfo[0][:EntityNameJaEntityInformation].id2name
    labels = []
    labels << "項目名".tosjis
    @base.tdnet.each do |val|
      current_exist = labels.index{ |exist| exist == val.contexts[:CurrentYearNonConsolidatedDuration] }
      if current_exist.nil?
        labels << val.contexts[:CurrentYearNonConsolidatedDuration]
      end
      prior_exist = labels.index{ |exist| exist == val.contexts[:PriorYearNonConsolidatedDuration] }
      if prior_exist.nil?
        labels << val.contexts[:PriorYearNonConsolidatedDuration]
      end
    end
    CSV.open( name + "分析データ.csv","wb") do |csv|
      csv << labels
      csv << inset_csv(@CashAndCashEquivalents, labels,"現金および現金同等物")
      csv << inset_csv(@OtherFinancialAsset, labels,"その他金融資産")
      csv << inset_csv(@TradeAccountsReceivable, labels,"売上債権")
      csv << inset_csv(@Inventories, labels,"棚卸資産")
      csv << inset_csv(@AccountsPayableAndAccrued, labels,"仕入債務")
      csv << inset_csv(@ShortTermDebt, labels,"短期借入金")
      csv << inset_csv(@LongTermDebt, labels,"長期借入金")
      csv << inset_csv(@TotalCurrentLiabikities, labels,"総負債")
      csv << inset_csv(@TreasuryStock, labels,"自己株式")
      csv << inset_csv(@ShareholdersEquity, labels,"株主資本")
      csv << inset_csv(@TotalEquity, labels,"純資産")
      csv << inset_csv(@TotalLiabilitiesAndEquity, labels,"総資産") 
      
      csv << inset_csv(@NetOperationgRevenues , labels, "売上高")
      csv << inset_csv(@CostOfSales, labels, "売上原価")
      csv << inset_csv(@GrossProfit, labels, "売上総利益")
      csv << inset_csv(@SellingGeneralAndAdministrativeExpenses, labels, "一般管理費")
      csv << inset_csv(@OperatingIncome, labels , "営業利益")
      csv << inset_csv(@InterestExpenses, labels ,"支払利息")
      csv << inset_csv(@IncomeTaxes, labels, "法人税")
      csv << inset_csv(@CurrentNetIncome, labels, "純利益")
      csv << inset_csv(@EarningsPerShare, labels,"EPS")
      csv << inset_csv(@AverageSharesOutstanding, labels,"発行済株式数")
      csv << inset_csv(@DepreciationCost, labels, "減価償却費")
      csv << inset_csv(@NetCashProvidedByOperatingActivities, labels, "営業CF")

      csv << inset_csv(@CapitalExpenditure, labels, "資本支出")
      csv << inset_csv(@PurchasesOfStockForTreasury, labels, "自己株式買い")
      csv << inset_csv(@Dividends, labels ,"配当額")

      csv << inset_csv_sjis(@NameRepresentative, labels ,"代表取締役社長")
      csv << insert_csv_stock_price
    end
    puts "exit output csv"
  end

  private
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

  def insert_csv_stock_price
    col = []
    col << "株価".tosjis
    @stockPrice.each do |k|
      col << k.values[0]
    end
    col
  end

  def parse_float(v) 
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

  def set_financial_data
    set_cash_and_cash_equivalents
    set_other_financial_asset
    set_trade_accounts_receivable
    set_inventories
    set_accounts_payable_and_accrued
    set_short_term_debt
    set_long_term_debt
    set_liabilities
    set_treasury_stock
    set_total_equity
    set_total_liabilities_and_equity
    set_shareholders_equity
    set_net_operationg_revenues
    set_cost_of_sales
    set_gross_profit
    set_selling_general_and_administrative_expenses
    set_operating_income
    set_interest_expenses
    set_income_taxes
    set_current_net_income
    set_earnings_per_share
    set_number_of_outstanding_shares
    set_depreciation
    set_net_cash_provided_by_operating_activities
    set_capital_expenditure
    set_purchase_of_treasury
    set_dividend
    set_name_representative
    set_stock_price
  end

  def has_result(result, name)
    index = result.index{ |v| v[0][:name] == name}
    if index.nil?
      return nil
    end
    result[index]
  end

  def inset_csv(values, labels, name)
    col = []
    col << name.tosjis
    if values == nil
      labels.each do |l|
        col << ""
      end
      return col
    end   
    labels.each do |l|
      if l == "項目名".tosjis
        next
      end
      if values[l] != nil
        col << values[l]
      else
        col << ""
      end
    end
    col
  end

  def inset_csv_sjis(values, labels, name)
    col = []
    col << name.tosjis
    labels.each do |l|
      if l == "項目名".tosjis
        next
      end
      i = values.index{ |v| v[:year] == l }
      if !i.nil?
        col << values[i][:value].id2name.tosjis
      else
        col << ""
      end
    end
    col
  end
  
  def set_cash_and_cash_equivalents
    @CashAndCashEquivalents = check_and_merge([
      has_result(@result, :CashAndDeposits)
    ])
  end

  def set_other_financial_asset
    @OtherFinancialAsset = check_and_merge([
      has_result(@result,:ShortTermInvestmentSecurities),
      has_result(@result,:OperationalInvestmentSecuritiesCA),
    ])
  end

  def set_trade_accounts_receivable
    @TradeAccountsReceivable = check_and_merge([
        has_result(@result, :NotesAndAccountsReceivableTrade),
        has_result(@result, :AccountsReceivableTrade)
    ])
  end

  def set_inventories
    @Inventories = check_and_merge([
      has_result(@result, :MerchandiseAndFinishedGoods),
      has_result(@result, :WorkInProcess), 
      has_result(@result, :RawMaterialsAndSupplies), 
      has_result(@result, :Inventories)
    ])  
  end

  def set_accounts_payable_and_accrued
    @AccountsPayableAndAccrued = check_and_merge([
      has_result(@result, :AccountsPayableTrade),
      has_result(@result, :NotesAndAccountsPayableTrade),
    ])
  end

  def set_short_term_debt
    @ShortTermDebt = check_and_merge([
      has_result(@result, :ShortTermLoansPayable),
      has_result(@result, :CurrentPortionOfLongTermLoansPayable),
      has_result(@result, :CurrentPortionOfBonds),
    ])
  end

  def set_long_term_debt
    @LongTermDebt = check_and_merge([
      has_result(@result, :BondsPayable),
      has_result(@result, :ConvertibleBondTypeBondsWithSubscriptionRightsToShares),
      has_result(@result, :LongTermLoansPayable),
    ])
  end
  
  def set_liabilities
    @TotalCurrentLiabikities = check_and_merge([
      has_result(@result, :Liabilities)
    ])
  end

  def set_treasury_stock
    @TreasuryStock = check_and_merge([
      has_result(@result, :TreasuryStock)
    ])
  end
  
  def set_total_equity
    @TotalEquity = check_and_merge([
      has_result(@result, :ShareholdersEquity) 
    ])   
  end

  def set_total_liabilities_and_equity
    @TotalLiabilitiesAndEquity =  check_and_merge([ 
      has_result(@result, :Assets) 
    ])
  end

  def set_shareholders_equity
    @ShareholdersEquity = check_and_merge([ 
      has_result(@result, :ShareholdersEquity) 
    ])
  end

  def set_net_operationg_revenues
    net_operationg_revenues = has_result(@result, :NetSales) 
    if net_operationg_revenues == nil
      net_operationg_revenues = has_result(@result, :OperatingRevenue1) 
    end
    @NetOperationgRevenues = check_and_merge([
       net_operationg_revenues
    ])
  end

  def set_cost_of_sales
    cost_of_sales = has_result(@result, :CostOfSales) 
    if cost_of_sales.nil?
      cost_of_sales = has_result(@result, :OperatingExpenses2) 
    end
    @CostOfSales = check_and_merge([
      cost_of_sales
    ])
  end

  def set_gross_profit
    @GrossProfit = check_and_merge([
      has_result(@result, :GrossProfit)
    ]) 
  end

  def set_selling_general_and_administrative_expenses
    @SellingGeneralAndAdministrativeExpenses = check_and_merge([
      has_result(@result, :SellingGeneralAndAdministrativeExpenses)  
    ])
  end

  def set_operating_income
    @OperatingIncome = check_and_merge([
      has_result(@result, :OperatingIncome)  
    ])
  end

  def set_interest_expenses
    @InterestExpenses = check_and_merge([ 
      has_result(@result, :InterestExpensesNOE) 
    ])
  end

  def set_income_taxes
    @IncomeTaxes = check_and_merge([ 
      has_result(@result, :IncomeTaxes)      
    ])
  end

  def set_current_net_income
    @CurrentNetIncome = check_and_merge([
      has_result(@result, :NetIncomeNA)
    ])
  end

  def set_earnings_per_share
    @EarningsPerShare = check_and_merge([ 
      has_result(@result, :NetIncomePerShare),
      has_result(@result, :NetIncomePerShareUS),
      has_result(@result, :BasicEarningsPerShareIFRS)
    ])
  end

  def set_number_of_outstanding_shares
    @AverageSharesOutstanding = check_and_merge([
      has_result(@result, :NumberOfIssuedAndOutstandingSharesAtTheEndOfFiscalYearIncludingTreasuryStock) 
    ])
  end

  def set_depreciation
    @DepreciationCost = check_and_merge([
      has_result(@result, :DepreciationAndAmortizationOpeCF)
    ])
  end

  def set_net_cash_provided_by_operating_activities
    @NetCashProvidedByOperatingActivities = check_and_merge([
      has_result(@result, :NetCashProvidedByUsedInOperatingActivities),
      has_result(@result, :CashFlowsFromOperatingActivitiesUS),
      has_result(@result, :CashFlowsFromOperatingActivitiesIFRS)
    ])
  end

  def set_capital_expenditure
    @CapitalExpenditure = check_and_merge([
      has_result(@result, :PurchaseOfPropertyPlantAndEquipmentInvCF),
      has_result(@result, :PurchaseOfIntangibleAssetsInvCF),
      has_result(@result, :PurchaseOfPropertyPlantAndEquipmentAndIntangibleAssetsInvCF)
    ])
  end

  def set_purchase_of_treasury
    @PurchasesOfStockForTreasury = check_and_merge([
      has_result(@result, :PurchaseOfTreasuryStockTS)
    ])
  end

  def set_dividend
    @Dividends = check_and_merge([
      has_result(@result, :CashDividendsPaidFinCF)
    ])
  end

  def set_name_representative
    @NameRepresentative = has_result(@result, :NameRepresentative)
  end

  def set_stock_price
    @stockPrice = StockPriceGetter.new(@stock_code, Date.today.year, 6).stockPrices
  end
end