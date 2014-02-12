module Goldencobra::Api::V2::ArticlesHelper


  # ---------------------------------------------------------------------------------------
  def do_search(q)
    Goldencobra::Article.active.search(:title_or_subtitle_or_url_name_or_content_or_summary_or_teaser_contains => q).relation.map {
        |article|
      {
          :id => article.id,
          :absolute_public_url => article.absolute_public_url,
          :title => article ? article.title : '',
          :teaser => article ? article.teaser : '',
          :article_type => article.article_type,
          :updated_at => article.updated_at,
          :parent_title => article.parent ? article.parent.title ? article.parent.title : '' : '',
          :ancestry => article.ancestry ? article.ancestry : ''
      }
    }.to_json
  end

end
