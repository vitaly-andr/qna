class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private
  # Reusable flash rendering
  def render_flash_notice(message)
    turbo_stream.replace('flash-messages', partial: 'shared/flash', locals: { flash: { notice: message } })
  end

  def render_flash_alert(message)
    turbo_stream.replace('flash-messages', partial: 'shared/flash', locals: { flash: { alert: message } })
  end
end
