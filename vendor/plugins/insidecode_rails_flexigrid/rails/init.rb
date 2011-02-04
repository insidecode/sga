require 'insidecode_rails_flexigrid'

Array.send :include, FlexigridJson
ActionView::Base.send :include, Flexigrid
ActiveRecord::Base.send :include, FlexigridQuery