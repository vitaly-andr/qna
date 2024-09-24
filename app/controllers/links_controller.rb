class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    link = Link.find(params[:id])
    if current_user.author_of?(link.linkable)
      link.destroy
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove(view_context.dom_id(link)) }
        format.html { redirect_back fallback_location: root_path, notice: 'Link was successfully removed.' }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: 'You are not authorized to delete this link.' }
        format.turbo_stream { render_flash_alert('You are not authorized to delete this link.') }
      end
    end
  end
end
