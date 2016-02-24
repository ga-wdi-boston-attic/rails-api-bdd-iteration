#
class ArticlesController < ProtectedController
  before_filter :set_article, only: [:show, :update, :destroy]
  skip_before_action :authenticate, only: [:index, :show]

  def index
    render json: Article.all
  end

  def show
    render json: @article
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      render json: @article, status: :created
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      render json: @article, status: :ok
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    head :no_content
  end

  def set_article
    @article = Article.find(params[:id])
  end
  private :set_article

  def article_params
    params.require(:article).permit(:title, :content)
  end
  private :article_params
end
