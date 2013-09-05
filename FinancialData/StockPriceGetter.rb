# -- coding: utf-8
require "open-uri"
require "nokogiri"
require "pry"

class StockPriceGetter
  def initialize(stockCode, years, times)
      @stockCode = stockCode
      @stockPrices = []
      @years = years
      @times = times
      set_stock_prices
  end
  attr_reader :stockCode, :stockPrices

  private 
  def set_stock_prices
    @month = Date.today.mon
    @day = Date.today.mday
    i = 0 
    until i >= @times
      scrape(i)
      i += 1
    end
  end

  def scrape(i)
    before_and_after = 0
    scraped = get_scraped(get_page(@years -i, @month, @day))
    if scraped.empty?
      result = get_before_or_after_price(i)
      scraped = result[:result]
      before_and_after = result[:before_and_after]
    end
    stock_price = scraped.children[1].children[6].text
    @stockPrices << {(@years -i).to_s + "/" + @month.to_s + "/" + (@day + before_and_after).to_s => stock_price }
  end

  def get_page(years, month, day)
    begin
        page = open("http://info.finance.yahoo.co.jp/history/?code=#{@stockCode}.T&sy=#{years}&sm=#{month}&sd=#{day}&ey=#{years}&em=#{month}&ed=#{day}&tm=d")
    rescue OpenURI::HTTPError
      puts "Error:Can't get page"
      return 
    end
    page
  end

  def get_scraped(page)
    html = Nokogiri::HTML(page.read, nil, 'utf-8')
    html.search("//table [@class='boardFin yjSt marB6']")
  end

  def get_former_day(i)
    j = -1
    result = []
    until !result.empty?
      result = get_scraped(get_page(@years -i, @month, @day + j))
      j -= 1
    end
    {result: result, before_and_after: j }
  end

  def get_after_day(i)
    j = 1
    result = []
    until !result.empty?
      result = get_scraped(get_page(@years -i, @month, @day + j))
      j += 1
    end
    {result: result, before_and_after: j }
  end

  def get_before_or_after_price(i)
    if @day == 1
      result = get_after_day(i)
    else
      result = get_former_day(i)
    end
    result
  end
end