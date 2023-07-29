# frozen_string_literal: true

module ActionWire
  class Component
    include ActiveModel::Model
    include ActiveModel::Attributes

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

      <<~CONTENT.html_safe
        <div wire:snapshot="#{ CGI::escapeHTML(snapshot)}" wire:effects="[]" wire:id="#{id}">
                #{defined?(content) ? content : @content}
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
  end
end
