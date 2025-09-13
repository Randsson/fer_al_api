class ApplicationController < ActionController::API
  include ExceptionHandler

  # Pagination helper
  def paginate_collection(collection, per_page: 10)
    page = params[:page] || 1
    collection.page(page).per(per_page)
  end

  # Response helpers
  def render_success(data = nil, message = 'Sucesso', status = :ok)
    response_data = { success: true, message: message }
    response_data[:data] = data if data
    render json: response_data, status: status
  end

  def render_error(message = 'Erro interno', status = :internal_server_error)
    render json: { success: false, message: message }, status: status
  end

  def render_validation_errors(record)
    render json: { 
      success: false, 
      message: 'Dados inválidos', 
      errors: record.errors.full_messages 
    }, status: :unprocessable_entity
  end
end
