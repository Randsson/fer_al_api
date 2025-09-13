class Api::V1::AuthenticationController < Api::V1::BaseController
  skip_before_action :authenticate_request, only: [:login, :register]

  # POST /api/v1/auth/register
  def register
    user = User.new(user_params)
    
    if user.save
      token = JwtService.encode(user_id: user.id)
      render_success(
        { user: user_response(user), token: token }, 
        'Usuário registrado com sucesso', 
        :created
      )
    else
      render_validation_errors(user)
    end
  end

  # POST /api/v1/auth/login
  def login
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      render_success(
        { user: user_response(user), token: token },
        'Login realizado com sucesso'
      )
    else
      render_error('Email ou senha inválidos', :unauthorized)
    end
  end

  # GET /api/v1/auth/profile
  def profile
    render_success(user_response(current_user), 'Perfil do usuário')
  end

  # PUT /api/v1/auth/profile
  def update_profile
    if current_user.update(update_profile_params)
      render_success(user_response(current_user), 'Perfil atualizado com sucesso')
    else
      render_validation_errors(current_user)
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, 
      :first_name, :last_name, :phone, :user_type, :address
    )
  end

  def update_profile_params
    params.require(:user).permit(
      :first_name, :last_name, :phone, :address, :avatar
    )
  end

  def user_response(user)
    {
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      full_name: user.full_name,
      phone: user.phone,
      user_type: user.user_type,
      address: user.address,
      avatar: user.avatar,
      latitude: user.latitude,
      longitude: user.longitude,
      created_at: user.created_at
    }
  end
end
