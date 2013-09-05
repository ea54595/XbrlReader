

require "rubygems"
require "watir-webdriver"
require 'benchmark'
require 'pp'

PAGES = 30  # 処理する検索結果の最大画面数 [ MAX = 30 (3000 件) ]
DOWNLOAD_PDF = false

browser = FireWatir::Firefox.new
sleep 3
puts Benchmark.measure { 

  browser.goto('http://info.edinet-fsa.go.jp')

  # [有価証券報告書等] をクリック
  browser.link(:xpath, "/html/body/form/div[3]/table/tbody/tr/td[2]/div[5]/a[1]").click

  # [提出書類検索] をクリック
  browser.link(:xpath, "/html/body/div[3]/table/tbody/tr/td/ul/li[2]/ul/li/a[1]").click

  # 一画面の表示数を [100件] に設定 {show1 => 20, show2 => 50, show3 => 100}
  browser.radio(:id, "show3").set

  # [検索] をクリック
  browser.link(:xpath, "/html/body/div[3]/table/tbody/tr/td[2]/form/div[2]/input[1]").click

  1.upto(PAGES).each do |page|
    puts "--- page #{page}"
    # PDF データの download
    #------------------------------
    if DOWNLOAD_PDF
      1.upto(100) do |row|
        pdf_path = "/html/body/div[3]/table/tbody/tr/td[2]/form/table[2]/tbody/tr[#{row+1}]/td[5]/a[1]"
        pdf_link = browser.link(:xpath, pdf_path)
        if pdf_link.exist?
          pdf_link.click 
          puts pdf_path

          # firafox の[環境設定] の [コンテンツ]タブで. ポップアップをブロックしないように設定する事。
          # でも　ポップアップは最大 20 までしか開かないようなので、pdf を 20 個までしか download できない。
          # この ポップアップを close する方法が不明  (2009-08-16 katoy)
          #　attche で window を見つけられうはずだが、エラーが発生してしまう...
          
          # sw = browser.attach(:url, "https://info.edinet-fsa.go.jp/E01EW/index.html")
          # sw = browser.attach(:title, "Mozilla Firefox", :url, "https://info.edinet-fsa.go.jp/E01EW/index.html")
          # sw.close if sw != nil
        end
      end
    end

    # XBRL データの download
    #------------------------------
    # [ALL] をクリックして、XBRL データをすべて選ぶ 
    browser.checkbox(:id, "all").set(true)
    # javascript の popup ダイアログの [OK] をクリックするように準備する
    browser.startClicker("OK", 5, "EDINT")
    # [XBRLダウンロード] をクリック　(javascipt の popup ダイアログが開く)
    browser.link(:xpath, "/html/body/div[3]/table/tbody/tr/td[2]/form/div[5]/input[1]").click

    # [次] があれば次ページへ行く。なければ終了する。
    next_link = browser.link(:xpath, "/html/body/div[3]/table/tbody/tr/td[2]/form/table/tbody/tr/td[3]/a[1]")
    break unless next_link.exist?
    next_link.click
  end
  # browser.close
}

# browser.close dows not work.
# See http://jira.openqa.org/browse/WTR-272
sleep 5  # データの dwonload 終了を すこしだけ待つ
system("echo 'tell application \"Firefox\" to quit' | osascript -")