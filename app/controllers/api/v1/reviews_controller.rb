class Api::V1::ReviewsController < Api::V1::BaseController
  before_action :set_event, only: [:index, :create]
  before_action :set_review, only: [:show, :update, :destroy]
  before_action :check_review_ownership, only: [:update, :destroy]

  # GET /api/v1/events/:event_id/reviews
  def index
    reviews = @event.reviews.includes(:user).ordered
    reviews = paginate_collection(reviews)
    
    render_success(
      reviews.map { |review| review_response(review) },
      'Avaliações do evento'
    )
  end

  # GET /api/v1/reviews/:id
  def show
    render_success(review_response(@review), 'Detalhes da avaliação')
  end

  # POST /api/v1/events/:event_id/reviews
  def create
    # Verificar se o evento já terminou
    unless @event.end_date < Time.current
      return render_error('Só é possível avaliar eventos que já terminaram', :unprocessable_entity)
    end

    # Verificar se o usuário já avaliou este evento
    existing_review = current_user.reviews.find_by(event: @event)
    if existing_review
      return render_error('Você já avaliou este evento', :unprocessable_entity)
    end

    review = current_user.reviews.build(review_params.merge(event: @event))
    
    if review.save
      # Criar notificação para o organizador
      create_review_notification(review)
      render_success(review_response(review), 'Avaliação criada com sucesso', :created)
    else
      render_validation_errors(review)
    end
  end

  # PUT /api/v1/reviews/:id
  def update
    if @review.update(review_params)
      render_success(review_response(@review), 'Avaliação atualizada com sucesso')
    else
      render_validation_errors(@review)
    end
  end

  # DELETE /api/v1/reviews/:id
  def destroy
    @review.destroy
    render_success(nil, 'Avaliação excluída com sucesso')
  end

  # GET /api/v1/reviews/my_reviews
  def my_reviews
    reviews = current_user.reviews.includes(:event, :event => :category).ordered
    reviews = paginate_collection(reviews)
    
    render_success(
      reviews.map { |review| review_response(review, include_event: true) },
      'Minhas avaliações'
    )
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def check_review_ownership
    require_owner_or_admin(@review)
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def create_review_notification(review)
    Notification.create!(
      user: review.event.user,
      event: review.event,
      notification_type: :new_review,
      title: 'Nova avaliação recebida',
      message: "#{review.user.full_name} avaliou seu evento '#{review.event.title}' com #{review.rating} estrelas."
    )
  end

  def review_response(review, include_event: false)
    response = {
      id: review.id,
      rating: review.rating,
      comment: review.comment,
      user: {
        id: review.user.id,
        name: review.user.full_name
      },
      created_at: review.created_at,
      updated_at: review.updated_at
    }

    if include_event
      response[:event] = {
        id: review.event.id,
        title: review.event.title,
        category: review.event.category.name
      }
    end

    response
  end
end
