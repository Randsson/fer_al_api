module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
    attr_reader :current_user
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end

  def require_admin
    unless current_user&.admin?
      render json: { error: 'Acesso negado. Apenas administradores podem realizar esta ação.' }, 
             status: :forbidden
    end
  end

  def require_organizer_or_admin
    unless current_user&.can_create_events?
      render json: { error: 'Acesso negado. Apenas organizadores e administradores podem realizar esta ação.' }, 
             status: :forbidden
    end
  end

  def require_owner_or_admin(resource)
    unless current_user&.admin? || resource.user == current_user
      render json: { error: 'Acesso negado. Você só pode gerenciar seus próprios recursos.' }, 
             status: :forbidden
    end
  end
end
