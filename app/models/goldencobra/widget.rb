# Encoding: UTF-8

# == Schema Information
#
# Table name: goldencobra_widgets
#
#  id                  :integer(4)      not null, primary key
#  title               :string(255)
#  content             :text
#  css_name            :string(255)
#  active              :boolean(1)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  id_name             :string(255)
#  sorter              :integer(4)
#  mobile_content      :text
#  teaser              :string(255)
#  default             :boolean(1)
#  description         :text
#  offline_days        :string(255)
#  offline_time_start  :datetime
#  offline_time_end    :datetime
#  offline_time_active :boolean(1)
#  alternative_content :text
#

module Goldencobra
  class Widget < ActiveRecord::Base
    acts_as_taggable_on :tags

    has_many :article_widgets
    has_many :articles, :through => :article_widgets

    before_save :validate_start_end_time

    OfflineDays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So']

    scope :active, where(:active => true).order(:sorter)
    scope :inactive, where(:active => false).order(:sorter)
    scope :default, where(:default => true).order(:sorter)
    scope :not_default, where(:default => false).order(:sorter)

    if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
      if Goldencobra::Setting.for_key("goldencobra.widgets.recreate_cache") == "true"
        after_save 'Goldencobra::Article.recreate_cache'
      end
    end
    if ActiveRecord::Base.connection.table_exists?("versions")
      has_paper_trail
    end

    before_save :set_default_tag

    def set_default_tag
      self.tag_list = "sidebar" if self.tag_list.blank?
    end

    def offline_day=(wert)
      self.offline_days = wert.flatten.uniq.compact.delete_if{|a|a==""}.join(",")
    end

    def offline_day
      self.offline_days.split(",").map{|tag| tag.strip} if self.offline_days.present?
    end

    def offline_time_start_display
      if self.offline_time_start.present?
        self.offline_time_start.strftime("%H%M")
      else
        ""
      end
    end

    def offline_time_end_display
      if self.offline_time_end.present?
        self.offline_time_end.strftime("%H%M")
      else
        ""
      end
    end

    def offline_date_start_display
      if self.offline_date_start.present?
        self.offline_date_start.strftime("%Y%m%d")
      else
        ""
      end
    end

    def offline_date_end_display
      if self.offline_date_end.present?
        self.offline_date_end.strftime("%Y%m%d")
      else
        ""
      end
    end



    def validate_start_end_time
      if self.offline_time_active

        if self.offline_time_start.present? && self.offline_time_end.present?

          if self.offline_time_start > self.offline_time_end
            errors.add(:offline_time_start, 'Startzeit muss VOR Endzeit liegen')
            errors.add(:offline_time_end, 'Startzeit muss VOR Endzeit liegen')
          end

        else
          errors.add(:offline_time_start, 'Zeit muss gesetzt werden')
          errors.add(:offline_time_end, 'Zeit muss gesetzt werden')
        end

        if self.offline_days.blank?
          errors.add(:offline_day, 'Mindestens ein Tag muss ausgewählt sein.')
        end
      end
    end
  end
end
