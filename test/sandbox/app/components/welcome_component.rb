class WelcomeComponent < ActionWire::Component
  attribute :full_name, :string

  def content
    <<~CONTENT.html_safe
      <div class="border border-gray-300 rounded-lg p-8">
        #{full_name}
      </div>
    CONTENT
  end
end