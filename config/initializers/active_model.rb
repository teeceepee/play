module ActiveModel
  module Translation
    def han(attribute, options = {})
      human_attribute_name(attribute, options)
    end

    def human_action_name(attribute, options = {})
      options   = { count: 1 }.merge!(options)
      parts     = attribute.to_s.split(".")
      attribute = parts.pop
      namespace = parts.join("/") unless parts.empty?
      attributes_scope = "#{self.i18n_scope}.actions"

      if namespace
        defaults = lookup_ancestors.map do |klass|
          :"#{attributes_scope}.#{klass.model_name.i18n_key}/#{namespace}.#{attribute}"
        end
        defaults << :"#{attributes_scope}.#{namespace}.#{attribute}"
      else
        defaults = lookup_ancestors.map do |klass|
          :"#{attributes_scope}.#{klass.model_name.i18n_key}.#{attribute}"
        end
      end

      defaults << :"actions.#{attribute}"
      defaults << options.delete(:default) if options[:default]
      defaults << attribute.humanize

      options[:default] = defaults
      I18n.translate(defaults.shift, options)
    end
  end
end
