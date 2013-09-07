#$KCODE="utf8"
require File.expand_path(File.dirname(__FILE__) + "/FinancialData/FinancialData")
require File.expand_path(File.dirname(__FILE__) + "/FinancialData/FinancialDataFormatter")

f_data = FinancialData.new("/Users/ea54595/Documents/提出財務諸表Xbrl/オービック")
f_data.output_csv(true)
f_out =FinancialDataFormatter.new(f_data, 4684)
#binding.pry
f_out.output_csv