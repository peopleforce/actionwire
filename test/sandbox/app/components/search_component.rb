class SearchComponent < ActionWire::Component
  attr_reader :query

  def initialize(query: "")
    @query = query
  end

  def content
    <<~CONTENT.html_safe
      <input wire:model.live="search">
    CONTENT
  end
end