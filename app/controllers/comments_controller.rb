class CommentsController < ApplicationController
  allow_unauthenticated_access only: [:create, :destroy]
  rate_limit to: 5, within: 1.minute, only: :create,
    with: -> { redirect_back fallback_location: root_path, alert: "You're commenting too fast. Try again in a bit." }

  before_action :set_project, only: :create
  before_action :set_comment, only: [:destroy, :ban_ip]

  def create
    if BannedIp.banned?(request.remote_ip)
      return redirect_to(@project, alert: "Your comment could not be posted.")
    end

    @comment = @project.comments.new(comment_params)
    @comment.author_name = nil if params[:comment][:anonymous] == "1"
    @comment.ip_address = request.remote_ip

    if @comment.save
      remember_comment_ownership(@comment)
      redirect_to @project, notice: "Comment posted."
    else
      redirect_to @project, alert: @comment.errors.full_messages.to_sentence
    end
  end

  def destroy
    unless authenticated? || comment_owned_by_visitor?(@comment)
      return redirect_to(@comment.project, alert: "You can only delete your own comments.")
    end

    project = @comment.project
    @comment.destroy
    redirect_to project, notice: "Comment deleted."
  end

  def ban_ip
    project = @comment.project
    BannedIp.find_or_create_by!(ip_address: @comment.ip_address)
    @comment.destroy
    redirect_to project, notice: "IP banned and comment removed."
  end

  private

  def set_project
    @project = Project.find_by!(slug: params[:project_slug])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:author_name, :body)
  end

  def remember_comment_ownership(comment)
    session[:my_comment_tokens] ||= {}
    session[:my_comment_tokens][comment.id.to_s] = comment.author_token
  end
end
