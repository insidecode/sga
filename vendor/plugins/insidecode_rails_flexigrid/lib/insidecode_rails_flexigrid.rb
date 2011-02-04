module Flexigrid

    def flexigrid_stylesheets
      stylesheet_link_tag('flexigrid/flexigrid.css').html_safe
    end

    def flexigrid_javascripts
      javascript_include_tag('flexigrid/flexigrid.js').html_safe
    end

    def flexigrid(title, id, action, columns = [], options = {})
      
      # Default options
      options = 
        { 
          :method              => 'get',
          :data_type           => 'json',
          :rows_per_page       => '10',
          :sort_name           => '',
          :sort_order          => 'asc',
          :use_pager           => true,
          :use_rp              => true,
          :show_table_toggle_button => false,
          :singleSelect        => true,
          :width               => '100%',
          :height              => '400'
        }.merge(options)
      
      # Stringify options values
      options.inject({}) do |options, (key, value)|
        options[key] = (key != :subgrid) ? value.to_s : value
        options
      end
      
      # Generate columns data
      col_model, col_search = gen_columns(columns)

      # Enable filtering (by default)
      search = ""
      if col_search
         search = "searchitems : " << col_search << ",\n"
      end

      # Generate required Javascript & html to create the flexigrid
      %Q(
        <table id="#{id}" style="display:none"></table>
        
        <script type="text/javascript">
          $("##{id}").flexigrid	({
      			method: '#{options[:method]}',
      			url: '#{action}',
      			dataType: '#{options[:data_type]}',
            colModel:#{col_model},
            #{search}
            sortname: '#{options[:sort_name]}',
      			sortorder: '#{options[:sort_order]}',
      			usepager: #{options[:use_pager]},
      			title: '#{title}',
      			useRp: #{options[:use_rp]},
      			rp: #{options[:rows_per_page]},
      			showTableToggleBtn: #{options[:show_table_toggle_button]},
      			width: #{options[:width]},
      			height: #{options[:height]},
      			singleSelect: #{options[:single_select]}
          });
        </script>
      ).html_safe
    end

    private

    def gen_columns(columns)
      # Generate columns data
      col_model = "["
      col_search = "["
      columns.each do |c|
        col_model << "{display:'#{c[:display]}', name:'#{c[:field]}'#{get_attributes(c)}},"
        col_search << "{display:'#{c[:display]}', name:'#{c[:field]}'}," if c[:searchable]
      end
      col_model.chop! << "]"
      col_search.chop! << "]"
      [col_model, col_search]
    end

    # Generate a list of attributes for related column (align:'right', sortable:true, width:xxx, ...)
    def get_attributes(column)
      options = ","
      column.except(:field, :display, :searchable).each do |couple|
        if couple[1].class == String
          options << "#{couple[0]}:'#{couple[1]}',"
        else
          options << "#{couple[0]}:#{couple[1]},"
        end
      end
      options.chop!
    end
end


module FlexigridJson
  include ActionView::Helpers::JavaScriptHelper

  def to_flexigrid_json(attributes, page, total)
    json = %Q({"page":"#{page}","total":"#{total}")
    if total > 0
      json << %Q(,"rows":[)
      each do |elem|
        elem.id ||= index(elem)
        json << %Q({"id":"#{elem.id}","cell":[)
        couples = elem.attributes.symbolize_keys
        attributes.each do |atr|
          value = get_atr_value(elem, atr, couples)
          value = escape_javascript(value) if value and value.is_a? String
          json << %Q("#{value}",)
        end
        json.chop! << "]},"
      end
      json.chop! << "]}"
    else
      json << "}"
    end
  end
  
  private
  
  def get_atr_value(elem, atr, couples)
    if atr.to_s.include?('.')
      value = get_nested_atr_value(elem, atr.to_s.split('.').reverse) 
    else
      value = couples[atr]
      value = elem.send(atr.to_sym) if value.blank? && elem.respond_to?(atr) # Required for virtual attributes
    end
    value
  end
  
  def get_nested_atr_value(elem, hierarchy)
    return nil if hierarchy.size == 0
    atr = hierarchy.pop
    raise ArgumentError, "#{atr} doesn't exist on #{elem.inspect}" unless elem.respond_to?(atr)
    nested_elem = elem.send(atr)
    return "" if nested_elem.nil?
    value = get_nested_atr_value(nested_elem, hierarchy)
    value.nil? ? nested_elem : value
  end
end

module ActiveRecord
  module QueryMethods
    def ola
      puts "ola"
    end
  end
end

module FlexigridQuery
  def self.append_features(base) # :nodoc:
    super
    base.extend ClassMethods
  end

  module ClassMethods
    def flexigrid_find(params = {})
      query = params[:query]
      qtype = params[:qtype]
      qop = params[:qop]
      sortname = params[:sortname]
      sortorder = params[:sortorder]

      query.gsub!("*","%") if !query.nil? && query.include?("*") && qop == "="
      qop = "like" if qop == "="
      sortorder = "asc" if sortorder.nil?

      where = "#{qtype} #{qop} ?" if qop != "%" && !query.nil?
      
      unless query.blank?
        unless sortname.blank?
          results = self.send(:where, where, query).order("#{sortname} #{sortorder}")
        else
          results = self.send(:where, where, query)
        end
      else
        unless sortname.blank?
          results = self.send(:order, "#{sortname} #{sortorder}")
        else
          results = self.send(:all)
        end
      end
    end
  end
end