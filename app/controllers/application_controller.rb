class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound do
    render plain: 'Object not found', status: 404
  end

  rescue_from ArcusErrors::Base do |exception|
    render json: [ { name: '', displayName: exception.message }], content_type: 'application/html'
  end

  def access_denied(_)
    flash[:error] = access_denied_message
    redirect_back(fallback_location: admin_root_path)
  end

  private

  def access_denied_message
    I18n.t(
      "active_admin.access_denied.#{params[:controller]}.#{params[:action]}.message",
      default: [
        "active_admin.access_denied.#{params[:controller]}.message".to_sym,
        'active_admin.access_denied.message'.to_sym
      ]
    )
  end
end
