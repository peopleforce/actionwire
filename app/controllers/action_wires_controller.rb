class ActionWiresController < ::ActionController::Base
  skip_before_action :verify_authenticity_token

  def index

  end

  def create
    components = []

    for component in params[:components]
      # json parse with symbols
      snapshot = JSON.parse(component[:snapshot])

      data = snapshot["data"]
      component_instance = snapshot["memo"]["name"].constantize.new
      data.each do |k, v|
        component_instance.public_send("#{k}=", v)
      end

      # updates
      if component[:updates].present?
        component[:updates].each do |k, v|
          component_instance.public_send("#{k}=", v)
        end
      end

      # calls
      for call in component[:calls]
        component_instance.public_send(call[:method])
      end

      view = ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil)

      components << {
        effects: {
          html: "<div wire:id=\"#{snapshot["memo"]["id"]}\">#{component_instance.render_in(view)}</div>",
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
