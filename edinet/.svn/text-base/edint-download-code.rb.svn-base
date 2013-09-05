
# using 
#   ruby 1.8.7 (2009-06-12 patchlevel 174) [i686-darwin9]
#   firewatir (1.6.2)

require "rubygems"
require "firewatir"
require 'benchmark'
require 'pp'

PAGES = 30  # 処理する検索結果の最大画面数 [ MAX = 30 (3000 件) ]
DOWNLOAD_PDF = false

browser = FireWatir::Firefox.new
sleep 3
puts Benchmark.measure { 

  browser.goto('http://info.edinet-fsa.go.jp')

  # [EDINETコードリスト ] をクリック
  browser.link(:xpath, "/html/body/form/div[3]/table/tbody/tr/td[2]/div[5]/ul/table/tbody/tr/td[3]/li/a[1]").click

  # 次ページの [EDINETコードリスト ] をクリック
  browser.link(:xpath, "/html/body/div[3]/table/tbody/tr/td[2]/form/table/tbody/tr/td/a[1]").click

  # browser.close
}

# browser.close dows not work.
# See http://jira.openqa.org/browse/WTR-272
sleep 5  # データの dwonload 終了を すこしだけ待つ
system("echo 'tell application \"Firefox\" to quit' | osascript -")
