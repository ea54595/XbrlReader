#$KCODE="utf8"
require File.expand_path(File.dirname(__FILE__) + "/FinancialData")
require 'csv'
require 'kconv'
require 'jpstock'
require File.expand_path(File.dirname(__FILE__) + "/Formats/CashAndCashEquivalents")
require File.expand_path(File.dirname(__FILE__) + "/Formats/OtherFinancialAsset")
require File.expand_path(File.dirname(__FILE__) + "/Formats/TradeAccountsReceivable")
require File.expand_path(File.dirname(__FILE__) + "/Formats/Inventories")
require File.expand_path(File.dirname(__FILE__) + "/Formats/AccountsPayableAndAccrued")
require File.expand_path(File.dirname(__FILE__) + "/Formats/ShortTermDebt")
require File.expand_path(File.dirname(__FILE__) + "/Formats/LongTermDebt")
require File.expand_path(File.dirname(__FILE__) + "/Formats/TotalCurrentLiabilities")
require File.expand_path(File.dirname(__FILE__) + "/Formats/TreasuryStock")
require File.expand_path(File.dirname(__FILE__) + "/Formats/TotalEquity")
require File.expand_path(File.dirname(__FILE__) + "/Formats/TotalLiabilitiesAndEquity")
require File.expand_path(File.dirname(__FILE__) + "/Formats/ShareholdersEquity")
require File.expand_path(File.dirname(__FILE__) + "/Formats/NetOperationgRevenues")
require File.expand_path(File.dirname(__FILE__) + "/Formats/CostOfSales")
require File.expand_path(File.dirname(__FILE__) + "/Formats/CashAndCashEquivalents")
require File.expand_path(File.dirname(__FILE__) + "/Formats/GrossProfit")
require File.expand_path(File.dirname(__FILE__) + "/Formats/SellingGeneralAndAdministrativeExpenses")
require File.expand_path(File.dirname(__FILE__) + "/Formats/OperatingIncome")
require File.expand_path(File.dirname(__FILE__) + "/Formats/InterestExpenses")
require File.expand_path(File.dirname(__FILE__) + "/Formats/IncomeTaxes")
require File.expand_path(File.dirname(__FILE__) + "/Formats/CurrentNetIncome")
require File.expand_path(File.dirname(__FILE__) + "/Formats/EarningsPerShare")
require File.expand_path(File.dirname(__FILE__) + "/Formats/AverageSharesOutstanding")
require File.expand_path(File.dirname(__FILE__) + "/Formats/DepreciationCost")
require File.expand_path(File.dirname(__FILE__) + "/Formats/NetCashProvidedByOperatingActivities")
require File.expand_path(File.dirname(__FILE__) + "/Formats/CapitalExpenditure")
require File.expand_path(File.dirname(__FILE__) + "/Formats/PurchasesOfStockForTreasury")
require File.expand_path(File.dirname(__FILE__) + "/Formats/Dividends")
require File.expand_path(File.dirname(__FILE__) + "/Formats/NameRepresentative")
require File.expand_path(File.dirname(__FILE__) + "/Formats/StockPrice")

class FinancialDataFormatter

  def initialize(f_data, stock_code)
    @base = f_data
    result = f_data.result
    @stock_code = stock_code
    
    @CashAndCashEquivalents = CashAndCashEquivalents.calculate(result)
    @OtherFinancialAsset = OtherFinancialAsset.calculate(result)
    @TradeAccountsReceivable = TradeAccountsReceivable.calculate(result)
    @Inventories = Inventories.calculate(result)
    @AccountsPayableAndAccrued = AccountsPayableAndAccrued.calculate(result)
    @ShortTermDebt = ShortTermDebt.calculate(result)
    @LongTermDebt = LongTermDebt.calculate(result)
    @TotalCurrentLiabilities = TotalCurrentLiabilities.calculate(result)
    @TreasuryStock = TreasuryStock.calculate(result)
    @TotalEquity = TotalEquity.calculate(result)
    @TotalLiabilitiesAndEquity = TotalLiabilitiesAndEquity.calculate(result)
    @ShareholdersEquity = ShareholdersEquity.calculate(result)
    @NetOperationgRevenues = NetOperationgRevenues.calculate(result)
    @CostOfSales = CostOfSales.calculate(result)
    @GrossProfit = GrossProfit.calculate(result)
    @SellingGeneralAndAdministrativeExpenses = SellingGeneralAndAdministrativeExpenses.calculate(result)
    @OperatingIncome = OperatingIncome.calculate(result)
    @InterestExpenses = InterestExpenses.calculate(result)
    @IncomeTaxes = IncomeTaxes.calculate(result)
    @CurrentNetIncome = CurrentNetIncome.calculate(result)
    @EarningsPerShare = EarningsPerShare.calculate(result)
    @AverageSharesOutstanding = AverageSharesOutstanding.calculate(result)
    @DepreciationCost = DepreciationCost.calculate(result)
    @NetCashProvidedByOperatingActivities = NetCashProvidedByOperatingActivities.calculate(result)
    @CapitalExpenditure = CapitalExpenditure.calculate(result)
    @PurchasesOfStockForTreasury = PurchasesOfStockForTreasury.calculate(result)
    @Dividends = Dividends.calculate(result)
    @NameRepresentative = NameRepresentative.calculate(result)
    @StockPrice = StockPrice.calculate(stock_code.to_s)
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
      csv << inset_csv(@TotalCurrentLiabilities, labels,"総負債")
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
      csv << insert_csv_stock_price_day
      csv << insert_csv_stock_price
    end
    puts "exit output csv"
  end

  def insert_csv_stock_price_day
    col = []
    col << "株価取得日".tosjis
    @StockPrice.each do |day|
      col << day.date.strftime("%Y/%m/%d")
    end
    col    
  end

  def insert_csv_stock_price
    col = []
    col << "株価".tosjis
    @StockPrice.each do |price|
      col << price.close
    end
    col
  end
  private :insert_csv_stock_price

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

      if values.key?(l)
        col << values[l]
      else
        col << ""
      end
    end
    col
  end
  private :inset_csv

  def inset_csv_sjis(values, labels, name)
    col = []
    col << name.tosjis
    labels.each do |l|
      if l == "項目名".tosjis
        next
      end
      if values.key?(l)
        col << values[l].tosjis
      else
        col << ""
      end
    end
    col
  end
  private :inset_csv_sjis

end