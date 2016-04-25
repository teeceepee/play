class CommentsController < ApplicationController

  def index
    @comments = Comment.all.order(created_at: :desc)
    @comment = Comment.new
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      comments = Comment.all.order(created_at: :desc)
      html = render_to_string(partial: 'comments/list', locals: {comments: comments})
      render json: {html: html}
    else
      html = render_to_string(partial: 'comments/form', locals: {comment: @comment})
      render json: {html: html}, status: :unprocessable_entity
    end
  end

  def normal_create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to comments_url
    else
      render 'new'
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:text)
  end
end
