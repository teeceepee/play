class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update]

  def draft
    render layout: false
  end

  def index
    @articles = Article.all.order(updated_at: :desc)

    respond_to do |format|
      format.html
      format.json do
        render json: @articles
      end
    end
  end

  def show

  end

  def new
    @article = Article.new
  end

  def edit

  end

  def create
    @article = Article.new(articles_params)

    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    if @article.update(articles_params)

      respond_to do |format|
        format.html { redirect_to @article }
        format.json { render json: @article }
      end
    else
      respond_to do |format|
        format.html { render 'edit' }
        format.json { render json: @article }
      end

    end
  end

  private

  def articles_params
    params.require(:article).permit(:title, :content)
  end

  def set_article
    @article = Article.find(params[:id])
  end

end
