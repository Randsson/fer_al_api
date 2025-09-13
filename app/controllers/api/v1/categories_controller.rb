class Api::V1::CategoriesController < Api::V1::BaseController
  before_action :set_category, only: [:show, :update, :destroy]
  before_action :require_admin, only: [:create, :update, :destroy]
  skip_before_action :authenticate_request, only: [:index, :show]

  # GET /api/v1/categories
  def index
    categories = Category.ordered
    
    render_success(
      categories.map { |category| category_response(category) },
      'Lista de categorias'
    )
  end

  # GET /api/v1/categories/:id
  def show
    events_count = @category.events.published.count
    
    render_success(
      category_response(@category).merge(events_count: events_count),
      'Detalhes da categoria'
    )
  end

  # POST /api/v1/categories
  def create
    category = Category.new(category_params)
    
    if category.save
      render_success(category_response(category), 'Categoria criada com sucesso', :created)
    else
      render_validation_errors(category)
    end
  end

  # PUT /api/v1/categories/:id
  def update
    if @category.update(category_params)
      render_success(category_response(@category), 'Categoria atualizada com sucesso')
    else
      render_validation_errors(@category)
    end
  end

  # DELETE /api/v1/categories/:id
  def destroy
    if @category.events.exists?
      render_error('Não é possível excluir categoria com eventos associados', :unprocessable_entity)
    else
      @category.destroy
      render_success(nil, 'Categoria excluída com sucesso')
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :color, :icon)
  end

  def category_response(category)
    {
      id: category.id,
      name: category.name,
      description: category.description,
      color: category.color,
      icon: category.icon,
      created_at: category.created_at,
      updated_at: category.updated_at
    }
  end
end
