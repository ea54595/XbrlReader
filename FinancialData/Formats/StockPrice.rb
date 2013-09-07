# -- coding: utf-8
require 'jpstock'
require "pry"

class StockPrice
  def self.calculate(stock_code)
    get_prices stock_code
  end

  def self.get_prices(stock_code)
    year = Date.today.year
    month = Date.today.mon
    day = Date.today.mday
    count = 0
    stock_prices = []
    
    5.times do
      stock_prices << get_price(stock_code,Date.new(year + count ,month,day))
      count += -1
    end
    
    stock_prices
  end
  private_class_method :get_prices
  
  def self.get_price(stock_code, date)
    result = JpStock.historical_prices(:code=> stock_code, :start_date => date, :end_date=> date)
    while result.empty?
      date += -1
      result = JpStock.historical_prices(:code=> stock_code, :start_date => date, :end_date=> date)
    end
    result[0]
  end
  private_class_method :get_price
end