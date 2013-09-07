#$KCODE="utf8"
require 'pry'
require 'csv'
require 'kconv'
require 'pp'
require_relative '../Xbrl/XbrlReaderEdinet'
require_relative '../Xbrl/XbrlReaderTdnet'
require_relative '../Xbrl/XbrlPathGetter'

class FinancialData

  attr_reader :result, :edinet, :tdnet

  def initialize(dir_path)
    @edinet = []
    @tdnet = []
    @result = []
    xbrl_paths = XbrlPathGetter.new(dir_path)
    set_edinet(xbrl_paths.edinetXbrl)
    set_tdnet(xbrl_paths.tdnetXbrl)  
    merge_data
    #binding.pry
  end

  def output_csv(is_full_data = false)
    name = @edinet[0].documentInfo[0][:EntityNameJaEntityInformation].id2name
    CSV.open( name + ".csv","wb") do |csv|
      csv << ["会社名".tosjis ,"会社名(英語)".tosjis]
      english_name = ""
      if @edinet[0].documentInfo[1] != nil
        english_name = @edinet[0].documentInfo[1][:EntityNameEnEntityInformation].id2name.tosjis
      end
      csv << [
        @edinet[0].documentInfo[0][:EntityNameJaEntityInformation].id2name.tosjis,
        english_name
      ]
      labels = [
        "schema",
        "from",
      ]
      @tdnet.each do |val|
        labels << val.contexts[:CurrentYearNonConsolidatedDuration]
      end

      csv << labels
      if is_full_data
        @result.each do |val|
          csv << insert_csv(val, labels)
        end
      else
        @result.each do |val|
          case val[:name].id2name
          when "CashAndDeposits"
            csv << insert_csv(val, labels)
          when "ShortTermInvestmentSecurities"
            csv << insert_csv(val, labels)
          when "OperationalInvestmentSecuritiesCA"
            csv << insert_csv(val, labels)
          when "NotesAndAccountsReceivableTrade"
            csv << insert_csv(val, labels)
          when "MerchandiseAndFinishedGoods"
            csv << insert_csv(val, labels)
          when "WorkInProcess"
            csv << insert_csv(val, labels)
          when "RawMaterialsAndSupplies"
            csv << insert_csv(val, labels)
          when "Inventories"
            csv << insert_csv(val, labels)
          when "AccountsPayableTrade"
            csv << insert_csv(val, labels)
          when "NotesAndAccountsPayableTrade"
            csv << insert_csv(val, labels)
          when "ShortTermLoansPayable"
            csv << insert_csv(val, labels)
          when "CurrentPortionOfLongTermLoansPayable"
            csv << insert_csv(val, labels)
          when "CurrentPortionOfBonds"
            csv << insert_csv(val, labels)
          when "BondsPayable"
            csv << insert_csv(val, labels)
          when "ConvertibleBondTypeBondsWithSubscriptionRightsToShares"
            csv << insert_csv(val, labels)
          when "LongTermLoansPayable"
            csv << insert_csv(val, labels)
          when "Liabilities"
            csv << insert_csv(val, labels)
          when "TreasuryStock"
            csv << insert_csv(val, labels)
          when "ShareholdersEquity"
            csv << insert_csv(val, labels)
          when "NetAssets"
            csv << insert_csv(val, labels)
          when "Assets"
            csv << insert_csv(val, labels)
          when "NetSales"
            csv << insert_csv(val, labels)
          when "CostOfSales"
            csv << insert_csv(val, labels)
          when "GrossProfit"
            csv << insert_csv(val, labels)
          when "SellingGeneralAndAdministrativeExpenses"
            csv << insert_csv(val, labels)
          when "OperatingIncome"
            csv << insert_csv(val, labels)
          when "InterestExpensesNOE"
            csv << insert_csv(val, labels)
          when "IncomeTaxes"
            csv << insert_csv(val, labels)
          when "NetIncomeNA"
            csv << insert_csv(val, labels)
          when "NetIncomePerShare"
            csv << insert_csv(val, labels)
          when "NumberOfIssuedAndOutstandingSharesAtTheEndOfFiscalYearIncludingTreasuryStock"
            csv << insert_csv(val, labels)
          when "DepreciationAndAmortizationOpeCF"
            csv << insert_csv(val, labels)
          when "NetCashProvidedByUsedInOperatingActivities"
            csv << insert_csv(val, labels)
          when "PurchaseOfPropertyPlantAndEquipmentInvCF"
            csv << insert_csv(val, labels)
          when "PurchaseOfIntangibleAssetsInvCF"
            csv << insert_csv(val, labels)
          when "PurchaseOfPropertyPlantAndEquipmentAndIntangibleAssetsInvCF"
            csv << insert_csv(val, labels)
          when "PurchaseOfTreasuryStockTS"
            csv << insert_csv(val, labels)
          when "CashDividendsPaidFinCF"
            csv << insert_csv(val, labels)
          when "NameRepresentative"
            csv << insert_csv(val, labels)
          end
        end
      end
    end
    puts "exit output csv"
  end

# ==private methods===
  def insert_csv(val,labels)
    out_data = []
    out_data << val[0][:name] || ""
    out_data << val[0][:from] || ""
    val.each do |v|
      labels.each do |l|
        if v[:year] == l
          if v[:name].id2name == "NameRepresentative"
            out_data << v[:value].id2name.tosjis
          else
            out_data << v[:value]
          end
        end
      end
    end
    out_data
  end
  private :insert_csv

  def set_edinet(edinet_file_path)
    edinet_file_path.each do |file_path|
      @edinet << XbrlReaderEdinet.new(file_path)
    end
    @edinet = @edinet.sort do |a , b|
      b.xbrlYear <=> a.xbrlYear
    end
  end
  private :set_edinet

  def set_tdnet(tdnet_file_path)
    tdnet_file_path.each do |file_path|
      @tdnet << XbrlReaderTdnet.new(file_path)
    end
    @tdnet = @tdnet.sort do |a,b|
      b.xbrlYear <=> a.xbrlYear
    end
  end
  private :set_tdnet

  def merge_data
    store_data(@edinet)
    store_data(@tdnet)
  end
  private :merge_data

  def store_data(xbrls)
    xbrls.each do |xbrl_val|
      merge_xbrls(xbrl_val)
    end
  end
  private :store_data

  def get_prior_duration(xbrl_val)
    if xbrl_val.files == "edinet"
      return :Prior1YearNonConsolidatedDuration
    end
    :PriorYearNonConsolidatedDuration
  end
  private :get_prior_duration

  def merge_xbrls(xbrl_val)
    xbrl_val.items.each do |val|
      exist_index = @result.index{ |exist| exist[0][:name] == val[:name] }
      if exist_index.nil?
        set_unexist_result(xbrl_val, val)
      else
        set_exist_result(xbrl_val, val, exist_index)
      end
    end
  end
  private :merge_xbrls

  def set_unexist_result(xbrl_val, val)
    result = []
    current_hash ={ 
      :name => val[:name],
      :from => xbrl_val.files,
      :year => xbrl_val.contexts[:CurrentYearNonConsolidatedDuration],
      :value => val[:current]            
    }
    result << current_hash

    if val.key?(:prior)
      prior_hash = {
        :name => val[:name],
        :from => xbrl_val.files,
        :year => xbrl_val.contexts[get_prior_duration(xbrl_val)],
        :value => val[:prior]  
      }
      result << prior_hash
    end
    @result << result
  end
  private :set_unexist_result

  def set_exist_result(xbrl_val, val, exist_index)
    exist_values = @result[exist_index]
    if exist_values.index{ |v| v[:year] == xbrl_val.contexts[:CurrentYearNonConsolidatedDuration] }.nil?
      exist_values << {
        :name => val[:name],
        :from => xbrl_val.files,
        :year => xbrl_val.contexts[:CurrentYearNonConsolidatedDuration],
        :value => val[:current]  
      }
    end
    if val.key?(:prior)
      if exist_values.index{ |v| v[:year] == xbrl_val.contexts[get_prior_duration(xbrl_val)] }.nil?
        exist_values << {
        :name => val[:name],
        :from => xbrl_val.files,
        :year => xbrl_val.contexts[get_prior_duration(xbrl_val)],
        :value => val[:prior]  
      }
      end
    end
    @result[exist_index] = exist_values
  end
  private :set_exist_result
end