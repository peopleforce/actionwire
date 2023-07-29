class CounterComponent < ActionWire::Component
  attribute :count, :integer, default: 0

  def content
    <<~CONTENT.html_safe
      <div>
          <h1>#{ count }</h1>
          <button wire:click="increment">+</button>
          <button wire:click="decrement">-</button>

          <p>You have this value: <span x-text="$wire.count"></span></p>
      </div>
    CONTENT
  end

  def increment
    self.count += 1
  end

  def decrement
    self.count -= 1
  end
end