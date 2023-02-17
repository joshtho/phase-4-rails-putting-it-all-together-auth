class UsersController < ApplicationController

    def create
        user = User.create(user_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: {error: user.errors.full_messages}, status: :unprocessable_entity
    end

    def show
        user = User.find(session[:user_id])
        if user&.authorization(params[:password])
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: {error: "Invalid username or password"}, status: :unauthorized 
    end

    private

    def user_params
        params.permit(:username, :image_url, :bio, :password)
    end
end
