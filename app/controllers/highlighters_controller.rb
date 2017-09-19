class HighlightersController < ApplicationController

  def show

  end

  def create
    dockerfile = highlighter_params[:dockerfile]

    @data = {
      original_name: dockerfile.original_filename,
      content_type: dockerfile.content_type,
      headers: dockerfile.headers,
    }

    if @data[:content_type].match(/text/)
      lexer = Rouge::Lexers::Dockerfile.new
      formatter = Rouge::Formatters::HTML.new
      content = dockerfile.read.force_encoding('utf-8')
      highlighted = formatter.format(lexer.lex(content))

      @data.merge!(highlighted: highlighted)
    end

    respond_to do |format|
      format.html
      format.json do
        render json: @data
      end
    end
  end

  private
  def highlighter_params
    params.require(:highlighter).permit(:dockerfile)
  end

end
