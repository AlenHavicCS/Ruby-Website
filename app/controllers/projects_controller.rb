class ProjectsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]
  before_action :set_project, only: %i[edit update destroy]

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find_by!(slug: params[:slug])
    @comments = @project.comments.order(created_at: :desc)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project was successfully deleted."
  end

  private

  def set_project
    @project = Project.find_by!(slug: params[:slug])
  end

  def project_params
    params.require(:project).permit(:title, :category, :description, :link, :image_url)
  end
end
