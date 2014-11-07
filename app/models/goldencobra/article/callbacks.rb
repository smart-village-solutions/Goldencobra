# encoding: utf-8

module Goldencobra
  class Article < ActiveRecord::Base

    before_update :set_redirection_step_1
    after_create :set_active_since
    after_create :notification_event_create
    after_create :cleanup_redirections
    after_save :set_url_path
    before_save :parse_image_gallery_tags
    before_save :set_url_name_if_blank
    before_save :set_standard_application_template
    after_save :set_default_meta_opengraph_values
    after_save :verify_existence_of_opengraph_image
    after_update :notification_event_update
    after_update :update_parent_article_etag
    before_destroy :update_parent_article_etag
    after_update :set_redirection_step_2

    def cleanup_redirections
      Goldencobra::Redirector.where(:source_url => self.absolute_public_url).destroy_all
    end

    #bevor ein Artikle gespeichert wird , wird ein redirector unvollständig erstellt
    def set_redirection_step_1
      if !self.new_record? && (self.url_name_changed? || self.ancestry_changed?)
        #Erstelle Redirector nur mit source
        old_url = "#{self.absolute_base_url}#{Goldencobra::Domain.current.try(:url_prefix)}#{self.url_path}"
        r = Goldencobra::Redirector.find_or_create_by_source_url(old_url)
        r.active = false
        r.save
        self.create_redirection = r.id
      end
    end

    def set_redirection_step_2
      if self.create_redirection
        #Suche Redirector nur mit source und vervollständige ihn
        Goldencobra::Redirector.where(:source_url => self.absolute_public_url).destroy_all
        r = Goldencobra::Redirector.find_by_id(self.create_redirection)
        r.target_url = self.absolute_public_url
        r.active = true
        r.save
      end
    end

    def set_url_path
        self.update_column(:url_path, self.get_url_from_path)
    end

    def get_url_from_path
      "/#{self.path.select([:ancestry, :url_name, :startpage, :id]).map{|a| a.url_name if !a.startpage}.compact.join("/")}"
    end

    #Nachdem ein Artikel gelöscht oder aktualsisiert wurde soll sein Elternelement aktualisiert werden, damit ein rss feed oder ähnliches mitbekommt wenn ein kindeintrag gelöscht oder bearbeitet wurde
    def update_parent_article_etag
      if self.parent.present?
        self.parent.update_attributes(:updated_at => Time.now)
      end
    end

    def set_active_since
      self.active_since = self.created_at
    end

    def parse_image_gallery_tags
      if self.respond_to?(:image_gallery_tags)
        self.image_gallery_tags = self.image_gallery_tags.compact.delete_if{|a| a.blank?}.join(",") if self.image_gallery_tags.class == Array
      end
    end

    def set_default_meta_opengraph_values
      # Diese Zeile schein Überflüssig geworden zu sein, da nun der teaser, description oder title als defaultwerte genommen werden
      #meta_description = Goldencobra::Setting.for_key('goldencobra.page.default_meta_description_tag')

      if self.teaser.present?
        meta_description = remove_html_tags(self.teaser.truncate(200))
      else
        meta_description = self.content.present? ? remove_html_tags(self.content).truncate(200) : self.title
      end

      if Goldencobra::Metatag.where(article_id: self.id, name: 'Meta Description').none?
        Goldencobra::Metatag.create(name: 'Meta Description',
                                    article_id: self.id,
                                    value: meta_description)
      end

      if Goldencobra::Metatag.where(article_id: self.id, name: 'Title Tag').none?
        Goldencobra::Metatag.create(name: 'Title Tag',
                                    article_id: self.id,
                                    #value: self.breadcrumb.present? ? self.breadcrumb : self.title)
                                    value: self.title)
      end

      if Goldencobra::Metatag.where(article_id: self.id, name: 'OpenGraph Description').none?
        Goldencobra::Metatag.create(name: 'OpenGraph Description',
                                    article_id: self.id,
                                    value: meta_description)
      end

      if Goldencobra::Metatag.where(article_id: self.id, name: 'OpenGraph Title').none?
        Goldencobra::Metatag.create(name: 'OpenGraph Title',
                                    article_id: self.id,
                                    value: self.title)
      end

      if Goldencobra::Metatag.where(article_id: self.id, name: 'OpenGraph URL').none?
        Goldencobra::Metatag.create(name: 'OpenGraph URL',
                                    article_id: self.id,
                                    value: self.absolute_public_url)
      end
    end

    # helper um links zu entfernen in text
    def remove_html_tags(text)
      text.gsub(/<[^<]+?>/, "")
    end

    def verify_existence_of_opengraph_image
      if Goldencobra::Metatag.where(article_id: self.id, name: "OpenGraph Image").none?
        if self.article_images.any? && self.article_images.first.present? && self.article_images.first.image.present? && self.article_images.first.image.image.present?
          og_img_val = "#{self.absolute_base_url}#{self.article_images.first.image.image.url}"
        else
          og_img_val = Goldencobra::Setting.for_key("goldencobra.facebook.opengraph_default_image")
        end
        Goldencobra::Metatag.create(name: "OpenGraph Image", article_id: self.id, value: og_img_val)
      end
    end

    def notification_event_create
      ActiveSupport::Notifications.instrument("goldencobra.article.created", :article_id => self.id)
    end

    def notification_event_update
      ActiveSupport::Notifications.instrument("goldencobra.article.updated", :article_id => self.id)
    end

    def set_url_name_if_blank
      if self.url_name.blank?
        #self.url_name = self.breadcrumb
        self.url_name = self.friendly_id.split("--")[0]
      end
    end

    def set_standard_application_template
      if ActiveRecord::Base.connection.table_exists?("goldencobra_articles") && ActiveRecord::Base.connection.table_exists?("goldencobra_articletypes")
        if self.template_file.blank?
          if self.articletype.present? && self.articletype.default_template_file.present?
            self.template_file = self.articletype.default_template_file
          else
            self.template_file = "application"
          end
        end
      end
    end

  end
end