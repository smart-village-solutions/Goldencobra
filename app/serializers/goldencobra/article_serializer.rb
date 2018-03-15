module Goldencobra
  class ArticleSerializer < ActiveModel::Serializer
    root false

    def attributes
      data = super
      Goldencobra::Article.attribute_names.map(&:to_sym).each do |attr|
        data[attr] = object.send(attr)
      end
      data[:child_ids] = object.send(:child_ids)
      data      
    end

    has_many :metatags
    has_many :images, each_serializer: Goldencobra::UploadSerializer
    has_many :widgets

    def metatags
      object.metatags.select([:id, :name, :value])
    end

    def widgets
      object.widgets.pluck(:id)
    end
  end
end

# == Schema Information
#
# Table name: goldencobra_articles
#
#  id                                  :integer          not null, primary key
#  title                               :string(255)
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  url_name                            :string(255)
#  slug                                :string(255)
#  content                             :text(65535)
#  teaser                              :text(65535)
#  ancestry                            :string(255)
#  startpage                           :boolean          default(FALSE)
#  active                              :boolean          default(TRUE)
#  subtitle                            :string(255)
#  summary                             :text(65535)
#  context_info                        :text(65535)
#  canonical_url                       :string(255)
#  robots_no_index                     :boolean          default(FALSE)
#  breadcrumb                          :string(255)
#  template_file                       :string(255)
#  article_for_index_id                :integer
#  article_for_index_levels            :integer          default(0)
#  article_for_index_count             :integer          default(0)
#  enable_social_sharing               :boolean
#  article_for_index_images            :boolean          default(FALSE)
#  cacheable                           :boolean          default(TRUE)
#  image_gallery_tags                  :string(255)
#  article_type                        :string(255)
#  external_url_redirect               :string(255)
#  index_of_articles_tagged_with       :string(255)
#  sort_order                          :string(255)
#  reverse_sort                        :boolean
#  sorter_limit                        :integer
#  not_tagged_with                     :string(255)
#  use_frontend_tags                   :boolean          default(FALSE)
#  dynamic_redirection                 :string(255)      default("false")
#  redirection_target_in_new_window    :boolean          default(FALSE)
#  commentable                         :boolean          default(FALSE)
#  active_since                        :datetime         default(Fri, 03 Oct 2014 09:43:07 CEST +02:00)
#  redirect_link_title                 :string(255)
#  display_index_types                 :string(255)      default("all")
#  creator_id                          :integer
#  external_referee_id                 :string(255)
#  external_referee_ip                 :string(255)
#  external_updated_at                 :datetime
#  image_gallery_type                  :string(255)      default("lightbox")
#  url_path                            :text(65535)
#  global_sorting_id                   :integer          default(0)
#  display_index_articletypes          :string(255)      default("all")
#  index_of_articles_descendents_depth :string(255)      default("1")
#  ancestry_depth                      :integer          default(0)
#  metatag_title_tag                   :string(255)
#  metatag_meta_description            :string(255)
#  metatag_open_graph_title            :string(255)
#  metatag_open_graph_description      :string(255)
#  metatag_open_graph_type             :string(255)      default("website")
#  metatag_open_graph_url              :string(255)
#  metatag_open_graph_image            :string(255)
#  state                               :integer          default(0)
#  display_index_articles              :boolean          default(FALSE)
#
