
# Meta Tags fuer einen Goldencobra::Article
#
# Ueber diese Methoden kann einheitlich auf die Metatags zugegriffen werden.
# Die Regeln zur Erstellung der MetaTags und deren Fallbacks koennen so zentral
# gesteuert werden
#
module Goldencobra::ArticleConcerns::MetaTag
  extend ActiveSupport::Concern

  def meta_tag_site
    Goldencobra::Setting.for_key("goldencobra.page.default_title_tag")
  end

  def meta_tag_title_tag
    get_meta_value(:metatag_title_tag, :breadcrumb)
  end

  def meta_tag_meta_description
    get_meta_value(:metatag_meta_description, :teaser)
  end

  def meta_tag_open_graph_title
    get_meta_value(:metatag_open_graph_title, :metatag_title_tag, :breadcrumb, :title)
  end

  def meta_tag_open_graph_description
    get_meta_value(:metatag_open_graph_description, :metatag_meta_description, :teaser)
  end

  def meta_tag_open_graph_type
    metatag_open_graph_type.present? ? metatag_open_graph_type : "website"
  end

  def meta_tag_open_graph_url
    get_meta_value(:metatag_open_graph_url, :absolute_public_url)
  end

  def meta_tag_open_graph_image
    if metatag_open_graph_image.present?
      og_image_url = metatag_open_graph_image
    else
      og_image_url = images.first.try(:image).try(:url)
    end
    og_image_fallback = Goldencobra::Setting.for_key("goldencobra.facebook.opengraph_default_image")
    og_image_url.present? ? og_image_url : og_image_fallback
  end

  def meta_tag_canonical_url
    get_meta_value(:canonical_url, :absolute_public_url)
  end

  # Generate a hash of custom_tags in settings
  # every children in goldencobra.page.custom_tags will by a custom meta_tag.
  # Esisting tags (canonical, noindex,... ) will be overwritten by custom tags
  # with the same name
  #
  # @return [Hash] {author: "MyValue", custom_tag: "otherValue"}
  def meta_tag_static_custom
    custom_tag_settings = Goldencobra::Setting.where(title: "custom_tags").first
    if custom_tag_settings.present? && custom_tag_settings.parent_names == "goldencobra.page"
      Hash[custom_tag_settings.children.map { |s| [s.title.to_sym, s.value] }]
    end
  end

  def combined_meta_tags
    {
      site: meta_tag_site,
      title: meta_tag_title_tag,
      separator: " ",
      reverse: true,
      description: meta_tag_meta_description,
      canonical: meta_tag_canonical_url,
      open_graph: combined_open_graph_tags,
      noindex: robots_no_index
    }.merge(meta_tag_static_custom)
  end

  def combined_open_graph_tags
    {
      title: meta_tag_open_graph_title,
      description: meta_tag_open_graph_description,
      type: meta_tag_open_graph_type,
      url: meta_tag_open_graph_url,
      image: meta_tag_open_graph_image
    }
  end

  private

  # get first present Value
  # calls al list of methods given as Array on the current article.
  # The first method with anpresent value will be returned
  #
  # @return [String] Response of called Method (mostly Strings)
  def get_meta_value(*method_names_to_call)
    method_names_to_call.map do |single_meta_method|
      next unless send(single_meta_method).present?
      return send(single_meta_method)
    end
    nil
  end
end