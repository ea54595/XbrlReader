#$KCODE="utf8"
require 'rubygems'
require 'sqlite3'
require 'pry'

db = SQLite3::Database.new("FinancialStatement.db")  
begin
  sql = <<-SQL
    CREATE TABLE FinancialStatement (
      EdinetCode text, --EDINETCODE 
      Year text, --年度
      CashAndCashEquivalents integer, --現金および現金同等物
      ShortTermInvestmentsMarketableSecurities integer, --その他金融資産
      TradeAccountsReceivable integer, --売上債権
      Inventories integer, --棚卸資産
      AccountsPayableAndAccrued integer, --仕入債務
      ShortTermDebt integer, --短期借入金
      LongTermDebt integer, --長期借入金
      TotalCurrentLiabikities integer, --総負債
      TreasuryStock integer, --自己株式
      TotalEquity integer, --純資産
      TotalLiabilitiesAndEquity integer, --総資産
      NetOperationgRevenues integer, --売上高
      CostOfGoodsSold integer, --売上原価
      SellingGeneralAndAdministrativeExpenses integer, --一般管理費
      OperationgIncome integer, --支払利益
      IncomeTaxes integer, --法人税
      CurrentNetIncome integer, --純利益
      EarningsPerShare integer, --EarningsPerShare
      AverageSharesOutstanding integer, --発行済株式数
      DepreciationCost integer, --減価償却費
      NetCashProvidedByOperatingActivities integer, --営業CF
      CapitalExpenditure integer, --資本支出
      PurchasesOfStockForTreasury integer, --自己株式買い
      Dividends integer --配当額
    );
    CREATE TABLE CompanyCode(
      CompanyName text, --企業名
      EdinetCode text --EDINETCODE
    );
  SQL
  db.execute_batch(sql)
rescue => exc
  binding.pry
  p exc
end
db.close