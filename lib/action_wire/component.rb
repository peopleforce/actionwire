# frozen_string_literal: true

module ActionWire
  class Component

    attr_accessor :id

    def initialize
      super
    end

    def data
      {
        id: @id
      }
    end

    def render_in(view_context)
      @id = SecureRandom.uuid
      @snapshot = {
        data: data,
        memo: {
          id: @id,
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

      #encode = ActiveSupport::JSON.encode(@snapshot)

      <<~CONTENT.html_safe
        <div wire:snapshot="#{ CGI::escapeHTML(@snapshot)}" wire:effects="[]" wire:id="#{@id}">
                #{content}
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
