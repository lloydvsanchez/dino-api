class Api::V1::CagesController < ApplicationController
  include Response

  def index
    resource = Cage.select(%i[id name power capacity]).includes(:dinosaurs)
    resource = resource.where(cage_params) unless cage_params.empty?
    resource = resource.joins(:dinosaurs).where(dinosaur_params) unless dinosaur_params.empty?
    json_response(preformat_to_json(resource))
  end

  def create
    cage = Cage.new(
      cage_params.merge({ dinosaurs_attributes: dinosaur_params["dinosaurs"] })
    )

    if cage.save
      json_response(preformat_to_json(cage))
    else
      json_response({ message: cage.first_error_message }, :unprocessable_entity)
    end
  rescue ArgumentError => e
    json_response({ message: e.message }, :unprocessable_entity)
  end

  def update
    if cage.update(cage_params.merge({ dinosaurs_attributes: dinosaur_params_with_id }))
      json_response(preformat_to_json(cage))
    else
      json_response({ message: cage.first_error_message }, :unprocessable_entity)
    end
  rescue ActiveRecord::RecordNotFound
    json_response({ message: "Invalid value for id: #{cage_params_id}" }, :not_found)
  rescue ArgumentError => e
    json_response({ message: e.message }, :unprocessable_entity)
  end

  def destroy
    cage.destroy
    head :ok
  rescue ActiveRecord::RecordNotFound
    json_response({ message: "Invalid value for id: #{cage_params_id}"}, :not_found)
  end

  private

  def cage
    @cage ||= Cage.includes(:dinosaurs).find(cage_params_id)
  end

  def cage_params_id
    @cage_params_id ||= cage_params['id']
  end

  def cage_params
    params.fetch("_json", params).permit(%i[id name power capacity]).to_h
  end

  def dinosaur_params
    params.fetch("_json", params).permit(dinosaurs: %i[id name species dino_type]).to_h
  end

  def dinosaur_params_with_id
    dinos_in_cage = cage.dinosaurs.pluck(:id)

    (dinosaur_params['dinosaurs'] || []).map do |hash|
      hash['id'] = dinosaur_id(hash) unless hash['id']
      hash
    end
  end

  def dinosaur_id(hash)
    cage.dinosaurs.find_by(name: hash['name'])&.id
  end
end
