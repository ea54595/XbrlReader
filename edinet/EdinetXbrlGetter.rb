require 'rubygems'
require 'watir-webdriver'
require 'watir-webdriver/extensions/alerts'
require 'benchmark'
require 'jpstock'
require 'pry'
require 'net/http'
require 'rexml/document'
require 'open-uri'
require 'openssl'
require 'net/https'

class EdinetXbrlGetter
  def initialize(stock_code_list)
    #edinet_code_list = get_edinet_code(stock_code_list)
    #edinet_code_list.each do |edinet_code|
     # download_xbrl_form_edinet edinet_code.edicode,edinet_code.code
    #end
    download_xbrl_form_tdnet("8053")
  end

  def download_xbrl_form_edinet(edinet_code, stock_code)
    profile = create_profile(stock_code)
    #binding.pry
    browser = Watir::Browser.new :ff, :profile => profile
    puts Benchmark.measure {
      browser.goto("http://info.edinet-fsa.go.jp")  
      browser.link(:xpath, '//*[@id="right-column"]/div[10]/a[1]').click
      browser.text_field(:xpath, '//*[@id="edinetCode"]').set edinet_code
      browser.button(:xpath, '//*[@id="right-column"]/form/div[2]/input').click
      browser.radio(:id, "show3").set
      browser.link(:xpath, '//*[@id="right-column"]/form/table[3]/tbody/tr[2]/td[1]/a').click
      
      1.upto(30).each do |page|
        browser.checkbox(:id, "all").set(true)
        browser.confirm(true) do
          xbrl_button = browser.button(:xpath, '//*[@id="right-column"]/form/div[5]/input')
          if xbrl_button.exist?
            break
          end
          browser.button(:xpath, '//*[@id="right-column"]/form/div[5]/input').click
        end
        next_link = browser.link(:xpath, "/html/body/div[3]/table/tbody/tr/td[2]/form/table/tbody/tr/td[3]/a[1]")
          break unless next_link.exist?
        next_link.click
      end
    }
    browser.close
    system("echo 'tell application \"Firefox\" to quit' | osascript -")
  end

  private
  def create_profile(stock_code)
    download_directory = "/Users/ea54595/Documents/Xbrl/" + stock_code
    download_directory.gsub!("/", "\\") if Selenium::WebDriver::Platform.windows?
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.folderList'] = 2 # custom location
    profile['browser.download.dir'] = download_directory
    profile['browser.helperApps.neverAsk.saveToDisk'] =  "application/x-xpinstall;application/x-zip;application/x-zip-compressed;application/octet-stream;application/zip;application/pdf;application/msword;text/plain;application/octet"
    profile
  end 

  def get_edinet_code(stock_code_list)
    edinet_code_list = []
    stock_code_list.each do |stock_code|
      edinet_code_list << JpStock.sec2edi(:code => stock_code)
    end
    edinet_code_list
  end

  def download_xbrl_form_tdnet(stock_code)
    request = Net::HTTP::Get.new('/webapi/tdnet/list/'+ stock_code +'.atom?hasXBRL=1')
    response = Net::HTTP.start('webapi.yanoshin.jp', 80) {|http|
      http.request(request)
    }
    doc = REXML::Document.new(response.body)
    xbrl_url_list = []
    doc.elements.each("/*/entry/link") do |v|
      xbrl_url_list << v.attributes["href"]
    end

    download_directory = "/Users/ea54595/Documents/Xbrl/" + stock_code +"/"
    
    xbrl_url_list.each do |url|
      file_name = url.split(/\//).last

      Dir.mkdir(download_directory) unless Dir.exist?(download_directory)    
      begin

        https = Net::HTTP.new("url",443)
        https.use_ssl = true
        https.ca_file = "/Users/ea54595/Documents/Xbrl/BuiltinObjectToken:ApplicationCA-JapaneseGovernment"
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.verify_depth = 5
        https.start {|w|
          response = w.get('/')
          puts response.body
        }
        #open(url, "r",{:ssl_verify_mode=>OpenSSL::SSL::VERIFY_NONE}) do |source|
        #  open(download_directory + file_name, "w+") do |file|
        #    file.write(source.read)
        #  end
        #end
      rescue Exception => e
        binding.pry
        puts "not found "+ e.message
        next 
      end
    end
    puts "complete get xbrl form tdnet"
  end

end

a =EdinetXbrlGetter.new(nil)


