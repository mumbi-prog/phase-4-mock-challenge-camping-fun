class CampersController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    def index
        render json: Camper.all, status: :ok
    end

    def show
        camper = find_camper
        render json: camper, serializer: CamperShowSerializer,  status: :ok
    end

    def create
        camper = Camper.create!(camper_params)
        render json: camper, status: :created
    end

    def update
        camper = find_camper
        camper.update!(camper_params)
        camper.save!
        render json: camper, status: :accepted
    end

    def destroy
        camper = find_camper
        camper.destroy!
        head :no_content
    end

    private

    def camper_params
        params.permit(:name, :age)
    end

    def find_camper
        camper = Camper.find(params[:id])
    end

    def render_unprocessable_entity(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end

    def render_not_found_response
        render json: {error: 'Camper not found'}, status: :not_found
    end

end
