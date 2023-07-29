class CounterComponent < ActionWire::Component
  attr_reader :count

  def initialize
    @count = 0
  end

  def content
    <<~CONTENT.html_safe
      <div>
          <h1>#{ @count }</h1>
          <button wire:click="increment">+</button>
          <button wire:click="decrement">-</button>
      </div>
    CONTENT
  end

  def increment

  end

  def decrement

  end
end