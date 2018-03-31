class D::AuthorsController < ApplicationController

  def index
    authors = Author.all.order(id: :desc)
    render_json(authors)
  end
end
