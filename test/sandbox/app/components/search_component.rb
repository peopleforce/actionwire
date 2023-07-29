class SearchComponent < ActionWire::Component
  attribute :query

  def content
    items = ["apple", "banana", "orange", "pear", "grape", "pineapple", "strawberry"]

    if query.present?
      items = items.select { |item| item.include?(query) }
    end

    <<~CONTENT.html_safe
      <div>
        <input wire:model.live="query">
      </div>

      <div x-cloak x-show="$wire.query" >
         <div wire:loading.remove>Searching for "<span x-text='$wire.query'></span>"...</div>

          <div>Found #{items.count} results</div>
      </div>
    CONTENT
  end
end