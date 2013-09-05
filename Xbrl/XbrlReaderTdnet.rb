#$KCODE="utf8"
require 'pry'
require 'rexml/document'
require 'open-uri'
require 'uri'
require "pp"

require_relative "XbrlReader.rb"

PRIOR_INSTANT = "PriorYearConsolidatedInstant"
PRIOR_DURATION = "PriorYearConsolidatedDuration"
NEXT_DURATION = "NextYearConsolidatedDuration"

PRIOR_NONCONSOLIDATED_INSTANT = "PriorYearNonConsolidatedInstant"
PRIOR_NONCONSOLIDATED_DURATION = "PriorYearNonConsolidatedDuration"
NEXT_NONCONSOLIDATED_DURATION = "NextYearNonConsolidatedDuration"

class XbrlReaderTdnet < XbrlReader
  
  attr_reader :securitiesCode

  private
  def read_xbrl(file_path)
    @files = "tdnet"
    doc = REXML::Document.new(open(file_path))
    elem_to_set_item(doc)
    set_securtie_code
    mearge_items
  end

  def set_securtie_code
    i = @currentYears.index{|v| v[:name] == :SecuritiesCode}
    unless i.nil?
      @securitiesCode = @currentYears[i][:value]
    end
  end
  
  def elem_to_set_item(doc)
    doc.elements.each("/*/*") do |elem|
      name_space = elem.namespace(elem.prefix)
      case name_space
      when NS_XBRLI
        set_context(elem)
      when NS_LINK
      when NS_ISO4217
      when NS_XLINK
      when NS_XSI
      else
        set_item(elem)
      end
    end
  end

  def set_item(elem)
    v = elem.text.intern if elem.text != nil  
    ns = elem.namespace(elem.prefix)
    hash = { contextRef: elem.attributes['contextRef'],
      prefix: elem.prefix,
      ns: ns.intern,
      name: elem.local_name.intern,
      value: v ,
      unitRef: elem.attributes['unitRef'],
      decimals: elem.attributes['decimals']
    }
    set_current_item(hash[:contextRef], hash)
    set_prior_item(hash[:contextRef], hash)
  end

  def set_current_item(conRef, hash)
    if (conRef == CURRENT_INSTANT) || (conRef == CURRENT_DURATION)
      @currentYears << hash
    end
    if (conRef == CURRENT_NON_CONSOLIDATED_INSTANT) || (conRef == CURRENT_NON_CONSOLIDATED_DURATION)
      @nonConsolidateCurrentYears << hash
    end
  end

  def set_prior_item(conRef, hash)
    if (conRef == PRIOR_INSTANT) ||(conRef == PRIOR_DURATION)
      @priorYears << hash
    end
    if (conRef == PRIOR_NONCONSOLIDATED_INSTANT) ||(conRef == PRIOR_NONCONSOLIDATED_DURATION)
      @nonConsolidatePriorYears << hash
    end
  end

  def mearge_items
    current_non_consolidate = false
    currents = @currentYears
    if currents.size == 0
      currents = @nonConsolidateCurrentYears
      current_non_consolidate = true
    end
    prior_non_consolidate = false
    priors = @priorYears
    if priors.size == 0
      priors = @nonConsolidatePriorYears
      prior_non_consolidate = true
    end

    currents.each do |current|
      priors.each do |prior|
        if current[:name] == :NameRepresentative   
          h = { name: current[:name], current: current[:value] }
          @items << h
        end
        if @items.index{ |exist| current[:name] == exist[:name] } != nil
          break
        end
        if current[:name] == prior[:name] 
          h = { 
            name: current[:name],
            current: current[:value],
            prior: prior[:value],
            consolidate: {
              currentNonConsolidate: current_non_consolidate,
              priorNonConsolidate: prior_non_consolidate
            }
          }
          @items << h
          break
        end
      end
    end
  end

end