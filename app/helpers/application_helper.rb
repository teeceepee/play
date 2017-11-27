module ApplicationHelper

  def rails_root_comment
    "<!-- #{Rails.root.basename} -->"
  end

  def global_options
    {
      'article.status' => Article.status.options,
    }
  end

  def current_domain
    @_current_domain ||= request.domain(1)
  end

  def ga_tracking_id
    if current_domain == 'xiumaijia.com'
      'UA-100812996-1'
    else
      'UA-67854007-2'
    end
  end
end
