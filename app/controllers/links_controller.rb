class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    link = Link.find(params[:id])
    if current_user.author_of?(link.linkable)
      link.destroy
      respond_to do |format|
        format.turbo_stream {
          render [ turbo_stream.remove(view_context.dom_id(link)),
                   render_flash_notice('Link was successfully removed.')
                 ]
        }
        format.html { redirect_back fallback_location: root_path, notice: 'Link was successfully removed.' }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: 'You are not authorized to delete this link.', status: :forbidden }
        format.turbo_stream {
          render render_flash_alert('You are not authorized to delete this link.'), status: :forbidden
        }
      end
    end
  end
end
