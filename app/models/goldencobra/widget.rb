#encoding: utf-8

# == Schema Information
#
# Table name: goldencobra_widgets
#
#  id                          :integer          not null, primary key
#  title                       :string(255)
#  content                     :text
#  css_name                    :string(255)
#  active                      :boolean
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  id_name                     :string(255)
#  sorter                      :integer
#  mobile_content              :text
#  teaser                      :string(255)
#  default                     :boolean
#  description                 :text
#  offline_days                :string(255)
#  offline_time_active         :boolean
#  alternative_content         :text
#  offline_date_start          :date
#  offline_date_end            :date
#  offline_time_week_start_end :text
#


module Goldencobra
  class Widget < ActiveRecord::Base

    serialize :offline_time_week_start_end

    has_many  :article_widgets
    has_many  :articles, :through => :article_widgets
    has_many  :permissions, :class_name => Goldencobra::Permission, :foreign_key => "subject_id", :conditions => {:subject_class => "Goldencobra::Widget"}

    accepts_nested_attributes_for :permissions, :allow_destroy => true

    attr_accessor :offline_time_start_mo, :offline_time_end_mo, :offline_time_start_tu, :offline_time_end_tu, :offline_time_start_we, :offline_time_end_we
    attr_accessor :offline_time_start_th, :offline_time_end_th, :offline_time_start_fr, :offline_time_end_fr, :offline_time_start_sa, :offline_time_end_sa
    attr_accessor :offline_time_start_su, :offline_time_end_su

    before_save :set_week_start_end_times
    before_save :validate_start_end_time

    OfflineDays   = ["Mo", 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So']
    OfflineDaysEN = ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']

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
    acts_as_taggable_on :tags

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

    # def offline_time_start_display
    #   if self.offline_time_start.present?
    #     self.offline_time_start.strftime("%H%M")
    #   else
    #     ""
    #   end
    # end

    # def offline_time_end_display
    #   if self.offline_time_end.present?
    #     self.offline_time_end.strftime("%H%M")
    #   else
    #     ""
    #   end
    # end

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

    def offline_time_week
      result = Hash.new
      if self.offline_time_week_start_end.present?
        self.offline_time_week_start_end.each do |key,value|
          result["data-time-day-#{key}"] = value
        end
      end
      return result
    end

    OfflineDaysEN.each do |day|
      define_method "get_offline_time_start_#{day}" do
        if self.offline_time_week_start_end.present?
          a = self.offline_time_week_start_end[day].to_s.split("-")[0].to_s
          "#{a.slice(0..1)}:#{a.slice(2..4)}" if a.present?
        end
      end
      define_method "get_offline_time_end_#{day}" do
        if self.offline_time_week_start_end.present?
          a = self.offline_time_week_start_end[day].to_s.split("-")[1].to_s
          "#{a.slice(0..1)}:#{a.slice(2..4)}" if a.present?
        end
      end
    end

    def set_week_start_end_times
      self.offline_time_week_start_end = Hash.new
      OfflineDays.each_with_index do |day,index|
        if self.offline_day.present? && self.offline_day.include?(day)
          current_day = OfflineDaysEN[index]
          if current_day.present?
            start_time = eval("self.offline_time_start_#{current_day}").to_s.gsub(/\D/, "").strip
            end_time = eval("self.offline_time_end_#{current_day}").to_s.gsub(/\D/, "").strip
            start_time = "0001" if start_time.blank?
            end_time = "2359" if end_time.blank?
            self.offline_time_week_start_end[current_day] = "#{start_time}-#{end_time}"
          end
        end
      end
    end


    def validate_start_end_time
      if self.offline_time_active

        # if self.offline_time_start.present? && self.offline_time_end.present?

        #   if self.offline_time_start > self.offline_time_end
        #     errors.add(:offline_time_start, 'Startzeit muss VOR Endzeit liegen')
        #     errors.add(:offline_time_end, 'Startzeit muss VOR Endzeit liegen')
        #   end

        # else
        #   errors.add(:offline_time_start, 'Zeit muss gesetzt werden')
        #   errors.add(:offline_time_end, 'Zeit muss gesetzt werden')
        # end

        if self.offline_days.blank?
          errors.add(:offline_day, 'Mindestens ein Tag muss ausgewählt sein.')
        end
      end
    end
  end
end
