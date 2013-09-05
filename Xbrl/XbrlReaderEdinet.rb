#$KCODE="utf8"
require 'pry'
require 'rexml/document'
require 'open-uri'
require 'uri'
require_relative '../Xbrl/XbrlReader.rb'

PRIOR1_INSTANT = "Prior1YearConsolidatedInstant"
PRIOR1_DURATION = "Prior1YearConsolidatedDuration"
PRIOR1_NON_CONSOLIDATED_INSTANT = "Prior1YearNonConsolidatedInstant"
PRIOR1_NON_CONSOLIDATED_DURATION = "Prior1YearNonConsolidatedDuration"

class XbrlReaderEdinet < XbrlReader
  
  private
  def read_xbrl(file_path)
    @files = "edinet"
    doc = REXML::Document.new(open(file_path))
    set_elem_to_item(doc)
    mearge_items
  end

  def set_elem_to_item(doc)
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
        set_year_item(elem)
      end
    end 
  end

  def set_industry_code(doc)
    doc.elements.each("/*") do |elem|
      unless elem.local_name == "xbrl"
        next   
      end 
      elem.attributes.each do |key, val|
        if /jpfr-t-(.*)/ =~ key
          @kinds << key.scan(/jpfr-t-(.*)/)
        end
      end
    end
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
    if (conRef == PRIOR1_INSTANT) ||(conRef == PRIOR1_DURATION)
      @priorYears << hash
    end
    if (conRef == PRIOR1_NON_CONSOLIDATED_INSTANT) ||(conRef == PRIOR1_NON_CONSOLIDATED_DURATION)
      @nonConsolidatePriorYears << hash
    end
  end
  
  def set_year_item(elem)
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
    set_document_info(hash)
  end

  def set_document_info(hash)
    if hash[:contextRef] == DOC_INFO
      case hash[:name]
      when :EntityNameJaEntityInformation
        @documentInfo << { EntityNameJaEntityInformation: hash[:value] }
      when :EntityNameEnEntityInformation
        @documentInfo << { EntityNameEnEntityInformation: hash[:value] }
      end
    end
  end

  def mearge_items

    current_non_consolidate = false
    currents = @currentYears
    if currents.empty?
      currents = @nonConsolidateCurrentYears
      current_non_consolidate = true
    end

    prior_non_consolidate = false
    priors = @priorYears
    if priors.empty?
     priors = @nonConsolidatePriorYears
     prior_non_consolidate = true
    end

    currents.each do |current|
      priors.each do |prior|
        if @items.index{ |hash2| prior[:name] == hash2[:name] } != nil
          next
        end
        if current[:name] == prior[:name] 
          h = { 
            name: current[:name],
            current: current[:value],
            prior: prior[:value],
            consolidate: {
              currentNonConsolidate: current_non_consolidate,
              priorNonConsolidate:  prior_non_consolidate
            }
          }
          @items << h
          break
        end
      end
    end
  end

end
