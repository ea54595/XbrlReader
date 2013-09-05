#$KCODE="utf8"
require 'rubygems'
require 'sqlite3'
require 'pry'

#DBアクセス
class DBAccesser
  DBPATH = "/Users/ea54595/Documents/workspace/FinancialAnalizeApp/FinanceAnalysisApp/FinancialStatement.db"
  def initialize
    @db = Dir.chdir( File.dirname( File.expand_path(DBPATH) ) )
  end
  def insert_financial
    
  end

  def inset_company_name
    
    
  end
  def close_databse
    @db.close
  end
end



  

  
