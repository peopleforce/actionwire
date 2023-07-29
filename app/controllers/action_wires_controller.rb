class ActionWiresController < ::ActionController::Base
  skip_before_action :verify_authenticity_token

  def index

  end

  def create
    components = []

    for component in params[:components]
      # json parse with symbols
      snapshot = JSON.parse(component[:snapshot])

      components << {
        effects: {
          html: "<div wire:id=\"#{snapshot["memo"]["id"]}\"> asdasd</div>",
          returns: []
        },
        snapshot: snapshot.to_json
      }
    end

    render json: {
      components: components,
      effects: {
        html: ""
      }
    }
  end
end
