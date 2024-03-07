module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def preformat_to_json(resource)
    cage_attrs = %w[id name power capacity]

    resource.as_json(
      only: cage_attrs,
      include: {
        dinosaurs: { only: %w[id name species dino_type] }
      }
    )
  end
end
