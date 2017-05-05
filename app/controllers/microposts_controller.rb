class MicropostsController < ApplicationController
  before_action :log_in_user, only: [:create, :destroy]

  def create
  end

  def destroy
  end
end
