class WelcomeComponent < ActionWire::Component
  attr_reader :full_name, :description

  def initialize(full_name:)
    @full_name = full_name
  end

  def render_in(view_context)
    <<~CONTENT.html_safe
      <div class="border border-gray-300 rounded-lg p-8">
        #{full_name}
      </div>
    CONTENT
  end
end