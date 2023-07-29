# frozen_string_literal: true

module ActionWire
  class Component
    include ActiveModel::Model
    include ActiveModel::Attributes

    require 'erb'

    attribute :id, :string

    def initialize(params = {})
      super
      params.each do |key, value|
        setter = "#{key}="
        send(setter, value) if respond_to?(setter.to_sym, false)
      end
    end

    def data
      d = {}
      self.class.new.attributes.except("id").each do |key, value|
        d[key] = send(key)
      end
      d
    end

    def render_in(view_context)
      before_render if defined?(before_render)

      id = SecureRandom.uuid
      snapshot = {
        data: data,
        memo: {
          id: id,
          name: self.class.name,
          path: "/",
          method: "GET",
          children: [],
          "lazyLoaded": false,
          errors: [],
          locale: "en",
        },
        checksum: "checksum"
      }.to_json

      # render erb file to string
      rendered_template = if defined?(template)
                            template
                          else
                            file_path, line_number = get_relative_path_to_class(self.class)
                            template = File.read(file_path.gsub(".rb", "") + ".html.erb")
                            ERB.new(template).result(binding)
                          end

      <<~CONTENT.html_safe
        <div wire:snapshot="#{ CGI::escapeHTML(snapshot)}" wire:effects="[]" wire:id="#{id}">
                #{rendered_template}
        </div>
      CONTENT
    end

    def self.slot(name)
      class_eval <<-CODE, __FILE__, __LINE__ + 1
      attr_writer :#{name}
      
      def #{name}(...)
        if block_given?
          @#{name} = @view_context.capture(...)
        else
          @#{name}
        end
      end

      def #{name}?
        !!@#{name}
      end
      CODE
    end

    def get_relative_path_to_class(klass)
      full_path, _ = klass.instance_method(:noop).source_location
      relative_path = Pathname.new(full_path).relative_path_from(Rails.root)
      relative_path.to_s
    end

  end
end
