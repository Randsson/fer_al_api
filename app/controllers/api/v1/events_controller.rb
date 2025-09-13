class Api::V1::EventsController < Api::V1::BaseController
  before_action :set_event, only: [:show, :update, :destroy, :toggle_interest, :add_image]
  before_action :require_organizer_or_admin, only: [:create]
  before_action :check_event_ownership, only: [:update, :destroy, :add_image]
  skip_before_action :authenticate_request, only: [:index, :show, :search, :by_category, :featured, :upcoming]

  # GET /api/v1/events
  def index
    events = Event.published.includes(:category, :user, :event_images)
    events = filter_events(events)
    events = paginate_collection(events, per_page: 20)
    
    render_success(
      events.map { |event| event_response(event) },
      'Lista de eventos'
    )
  end

  # GET /api/v1/events/:id
  def show
    render_success(event_response(@event, detailed: true), 'Detalhes do evento')
  end

  # POST /api/v1/events
  def create
    event = current_user.events.build(event_params)
    
    if event.save
      render_success(event_response(event), 'Evento criado com sucesso', :created)
    else
      render_validation_errors(event)
    end
  end

  # PUT /api/v1/events/:id
  def update
    if @event.update(event_params)
      render_success(event_response(@event), 'Evento atualizado com sucesso')
    else
      render_validation_errors(@event)
    end
  end

  # DELETE /api/v1/events/:id
  def destroy
    @event.destroy
    render_success(nil, 'Evento excluído com sucesso')
  end

  # GET /api/v1/events/search
  def search
    events = Event.published
    
    if params[:q].present?
      events = events.where(
        "title ILIKE ? OR description ILIKE ? OR address ILIKE ?", 
        "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%"
      )
    end
    
    if params[:latitude].present? && params[:longitude].present?
      events = events.near_location(params[:latitude], params[:longitude], params[:distance] || 10)
    end
    
    events = filter_events(events)
    events = paginate_collection(events)
    
    render_success(
      events.map { |event| event_response(event) },
      'Resultados da busca'
    )
  end

  # GET /api/v1/events/by_category/:category_id
  def by_category
    category = Category.find(params[:category_id])
    events = category.events.published.includes(:user, :event_images)
    events = paginate_collection(events)
    
    render_success(
      events.map { |event| event_response(event) },
      "Eventos da categoria #{category.name}"
    )
  end

  # GET /api/v1/events/featured
  def featured
    events = Event.published.featured.includes(:category, :user, :event_images)
    events = paginate_collection(events)
    
    render_success(
      events.map { |event| event_response(event) },
      'Eventos em destaque'
    )
  end

  # GET /api/v1/events/upcoming
  def upcoming
    events = Event.published.upcoming.includes(:category, :user, :event_images)
    events = paginate_collection(events)
    
    render_success(
      events.map { |event| event_response(event) },
      'Próximos eventos'
    )
  end

  # POST /api/v1/events/:id/toggle_interest
  def toggle_interest
    interest = current_user.user_event_interests.find_or_initialize_by(event: @event)
    
    if interest.persisted?
      interest.update(interested: !interest.interested)
    else
      interest.update(interested: true)
    end
    
    message = interest.interested? ? 'Interesse adicionado' : 'Interesse removido'
    render_success({ interested: interest.interested }, message)
  end

  # POST /api/v1/events/:id/images
  def add_image
    image = @event.event_images.build(image_params)
    
    if image.save
      render_success(image_response(image), 'Imagem adicionada com sucesso', :created)
    else
      render_validation_errors(image)
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def check_event_ownership
    require_owner_or_admin(@event)
  end

  def event_params
    params.require(:event).permit(
      :title, :description, :start_date, :end_date, :address,
      :category_id, :status, :featured
    )
  end

  def image_params
    params.require(:event_image).permit(:url, :caption)
  end

  def filter_events(events)
    events = events.by_category(params[:category_id]) if params[:category_id].present?
    events = events.where('start_date >= ?', params[:start_date]) if params[:start_date].present?
    events = events.where('end_date <= ?', params[:end_date]) if params[:end_date].present?
    events
  end

  def event_response(event, detailed: false)
    response = {
      id: event.id,
      title: event.title,
      description: event.description,
      start_date: event.start_date,
      end_date: event.end_date,
      address: event.address,
      latitude: event.latitude,
      longitude: event.longitude,
      status: event.status,
      featured: event.featured,
      duration_hours: event.duration_in_hours,
      average_rating: event.average_rating.round(1),
      total_reviews: event.total_reviews,
      category: {
        id: event.category.id,
        name: event.category.name,
        color: event.category.color,
        icon: event.category.icon
      },
      organizer: {
        id: event.user.id,
        name: event.user.full_name,
        email: event.user.email
      },
      images: event.event_images.map { |img| image_response(img) },
      created_at: event.created_at,
      updated_at: event.updated_at
    }

    if detailed
      response[:interested_users_count] = event.user_event_interests.interested.count
      response[:user_interested] = current_user&.user_event_interests&.find_by(event: event)&.interested || false
    end

    response
  end

  def image_response(image)
    {
      id: image.id,
      url: image.url,
      caption: image.caption
    }
  end
end
