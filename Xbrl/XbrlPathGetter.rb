#$KCODE="utf8"
require 'pry'
require 'find'

class XbrlPathGetter
  attr_reader :tdnetXbrl, :edinetXbrl

  def initialize(dir_path)
    @tdnetXbrl = []
    @edinetXbrl = []
    get_dir_under_xbrl(dir_path)
  end

  def get_dir_under_xbrl(dir_path)
    Find.find(dir_path) do |list|
      unless list.match(/.xbrl/).nil?
        if !list.match(/tdnet-aced/).nil?
          if list.match(/jpfr/).nil?
            @tdnetXbrl << list
          end
        elsif !list.match(/jpfr-asr/).nil?
          @edinetXbrl << list
        end 
      end
    end
  end
  private :get_dir_under_xbrl

end
