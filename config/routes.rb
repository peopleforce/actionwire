ActionWire::Engine.routes.draw do

  post "/update", to: "action_wires#create"
end