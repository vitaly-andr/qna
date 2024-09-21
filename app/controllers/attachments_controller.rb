class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment, only: [:destroy]

  def destroy
    record = @attachment.record

    if current_user.author_of?(record)
      @attachment.purge
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: 'File was successfully deleted.' }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("file_#{@attachment.id}"),
            render_flash_notice('File was successfully deleted.')
          ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: 'You are not authorized to delete this file.' }
        format.turbo_stream do
          render turbo_stream: [
            render_flash_alert('You are not authorized to delete this file.')
          ]
        end
      end
    end
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
