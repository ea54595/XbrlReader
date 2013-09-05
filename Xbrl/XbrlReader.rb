#$KCODE="utf8"
require 'pry'
require 'csv'

#===== 定数 =======
NS_XLINK="http://www.w3.org/1999/xlink"
NS_XSI="http://www.w3.org/2001/XMLSchema-instance"
NS_XSD="http://www.w3.org/2001/XMLSchema"

NS_XBRLI ="http://www.xbrl.org/2003/instance"
NS_REF="http://www.xbrl.org/2006/ref"
NS_LINK="http://www.xbrl.org/2003/linkbase"
NS_ISO4217="http://www.xbrl.org/2003/iso4217"

CURRENT_INSTANT = "CurrentYearConsolidatedInstant"
CURRENT_DURATION = "CurrentYearConsolidatedDuration"
CURRENT_NON_CONSOLIDATED_INSTANT = "CurrentYearNonConsolidatedInstant"
CURRENT_NON_CONSOLIDATED_DURATION = "CurrentYearNonConsolidatedDuration"

CONSOLIDATED = "Consodidated"
NON_CONSOLIDATED = "NonConsolidated"

DOC_INFO = "DocumentInfo"

class XbrlReader

  def initialize(file_path)
    @kinds = [] #業種コード ex cte... sec...第一種金融商品取扱業
    @items = [] #各種財務値
    @files = ""
    @xbrlYear = ""
    @ignoreFiles = []
    @contexts = {} #年度
    @currentYears = []
    @nonConsolidateCurrentYears = []
    @priorYears = []
    @nonConsolidatePriorYears = []
    @documentInfo = []
    @base = file_path
    read_xbrl(file_path)
  end
  attr_reader :kinds,
    :items,
    :files,
    :contexts,
    :currentYears,
    :nonConsolidateCurrentYears,
    :priorYears,
    :nonConsolidatePriorYears,
    :documentInfo,
    :xbrlYear

  def output_csv
    CSV.open("items.csv","wb") do |csv|
      csv << ["currentYears"]
      @currentYears.each do |item|
        csv << item.values
      end
      csv << ["priorYears"] 
      @priorYears.each do |item|
        csv << item.values
      end
    end
  end

  protected 
  def read_xbrl(file_path)    
  end

  def set_context(elem)
    case elem.local_name
    when "context"
      contextID = nil
      elem.attributes.each do |key, val|
        contextID = val.to_sym if key == "id"
      end
      REXML::XPath.each(elem,"xbrli:period/xbrli:instant/text()") do |p|
        @contexts[contextID] = p.to_s
      end 
      REXML::XPath.each(elem,"xbrli:period/xbrli:startDate/text()") do |p|
        @contexts[contextID] = p.to_s
      end 
      REXML::XPath.each(elem,"xbrli:period/xbrli:endDate/text()") do |p|
        @contexts[contextID] = @contexts[contextID] + " - " + p.to_s
      end
      @xbrlYear = @contexts[:CurrentYearNonConsolidatedInstant] 
    end
  end
end

