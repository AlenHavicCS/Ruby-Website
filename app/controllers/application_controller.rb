class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :comment_owned_by_visitor?

  private

  # Anonymous commenters aren't accounts, so "ownership" is a token minted at
  # comment creation and remembered in their session cookie.
  def comment_owned_by_visitor?(comment)
    return false if comment.author_token.blank?

    session[:my_comment_tokens]&.[](comment.id.to_s) == comment.author_token
  end
end
