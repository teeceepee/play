class FormsController < ApplicationController

  def index

  end

  def create
    item = params[:form][:item]
    item.capitalize! if params[:form][:capital] == '1'
    html = render_to_string(partial: 'ul', locals: {items: [item]})
    render json: {html: html}
  end

end
