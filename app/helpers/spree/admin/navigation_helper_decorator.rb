module Spree
  module Admin
    NavigationHelper.module_eval do
      
      #
      # This helper will generate another set of fields for an objects nested association
      # it will render a partial with the [association_name]_fields convention and create
      # a link for JS to tap into on click
      #
      # This helper is based on RailsCasts excellent episode: http://railscasts.com/episodes/196-nested-model-form-revised
      #
      # @param [String] name The name of the object
      # @param [FormBuilder] f 
      # @param [String] association The name of the association within the parent
      #
      # 
      def link_to_add_nested_fields(name, f, association)
        new_object = f.object.send(association).klass.new
        id = new_object.object_id
        fields = f.fields_for association, new_object, child_index: id do |builder|
          render association.to_s.singularize + "_fields", f: builder
        end

        # Generate a dummy link for JS
        link_to Spree.t(name),
          '#',
          class: "button fa fa-plus add_fields",
          data: { id: id, fields: fields.gsub("\n", "") }

      end

    end
  end
end