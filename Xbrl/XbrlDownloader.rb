require 'rubygems'
require 'pry'
require 'net/http'
require 'rexml/document'

DOMAIN = "resource.ufocatch.com"
ATOM = "/atom/"
QUERY = "query/"

TDNET = "tdnetx/"
EDINET = "edinetx/"

class XbrlDownloader

  def initialize(stock_codes, down_path)
    @stock_codes = stock_codes
    @base_path = down_path
    get_xbrl_form_tdnet stock_codes
    get_xbrl_form_edinet stock_codes
  end
    
  def get_xbrl_form_edinet(stock_codes)
    stock_codes.each do |code|
      download_from_edinet code.to_s
    end
  end

  def download_from_edinet(stock_code)
    download_directory = create_folder(stock_code)
    list = rest_ufo_catch(stock_code, EDINET)
    list.each do |url|
      download_xbrl url,download_directory
    end
  end
  private :download_from_edinet

  def get_xbrl_form_tdnet(stock_codes)
    stock_codes.each do |code|
      download_from_tdnet code.to_s
    end
  end
  private :get_xbrl_form_tdnet

  def download_from_tdnet(stock_code)
    download_directory = create_folder(stock_code)
    list = rest_ufo_catch(stock_code, TDNET)
    list.each do |url|
      download_xbrl url,download_directory
    end
  end
  private :download_from_tdnet

  def create_folder(stock_code)
    download_directory = @base_path + "/" + stock_code
    Dir.mkdir(download_directory) unless Dir.exist?(download_directory)    
    download_directory
  end
  private :create_folder

  def download_xbrl(url, download_directory)
    file_name = url.split(/\//).last
    begin
      open(url, "r") do |source|
        open(download_directory + "/" +file_name + ".zip", "w+") do |file|
          file.write(source.read)
        end
        puts "download complete " + download_directory+file_name+".zip" 
      end
    rescue Exception => e
      puts e.message        
    end
  end
  private :download_xbrl

  def rest_ufo_catch(stock_code, from)
    request = Net::HTTP::Get.new( ATOM + from + QUERY + stock_code.to_s)
    response = Net::HTTP.start(DOMAIN,80){ |http|
      http.request(request)
    }
    doc = REXML::Document.new(response.body)
    
    xbrl_lsit = []
    next_page = nil

    doc.elements.each("/*/entry/link") do |v|
      if v.attributes["type"] == "application/zip"
        xbrl_lsit << v.attributes["href"]
      end
    end
    xbrl_lsit
  end
  private :rest_ufo_catch

end
