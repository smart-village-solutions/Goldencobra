# encoding: utf-8

# == Schema Information
#
# Table name: goldencobra_imports
#
#  id                :integer          not null, primary key
#  assignment        :text
#  assignment_groups :text
#  target_model      :string(255)
#  successful        :boolean
#  upload_id         :integer
#  separator         :string(255)      default(",")
#  result            :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module Goldencobra
  class Import < ActiveRecord::Base
    require 'iconv'
    require 'csv'

    belongs_to :upload, :class_name => Goldencobra::Upload
    serialize :assignment
    serialize :assignment_groups
    EncodingTypes = ["UTF-8","ISO-8859-1", "ISO-8859-2", "ISO-8859-16", "US-ASCII", "Big5", "UTF-16BE", "IBM437", "Windows-1252"]
    accepts_nested_attributes_for :upload, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank? }
    after_initialize :init_nested_attributes
    BlockedAttributes = ["id", "created_at", "updated_at", "url_name", "slug", "upload_id", "images", "article_images", "article_widgets"]
    DataHandling = [["Datensatz aktualisieren oder erstellen","update"],["Datensatz immer neu anlegen", "create"]]
    DataFunctions = ["Default", "Static Value"]
    def analyze_csv
      begin
        result = []
        data = CSV.read(self.upload.image.path, "r:#{self.encoding_type}", {:col_sep => self.separator})
        data.first.each_with_index do |a, index|
          result << [a,index.to_s]
        end
      rescue
        result = []
      end
      @analyze_csv ||= result
    end

    def data_rows
      CSV.read(self.upload.image.path, "r:#{self.encoding_type}", {:col_sep => self.separator})
    end

    def get_model_attributes
      @get_model_attributes ||= eval("#{self.target_model}.new.attributes").delete_if{|a| BlockedAttributes.include?(a) }.keys
    end

    def get_association_names
      self.target_model.constantize.reflect_on_all_associations.collect { |r| r.name }.delete_if{|a| Goldencobra::Import::BlockedAttributes.include?(a.to_s) }
    end

    def method_missing(meth, *args, &block)
      if meth.to_s.include?("assignment_") && self.assignment.present?
        self.assignment[meth.to_s.split("_")[1]]
      end
    end

    def status
      @status ||="ready to import"
    end

    def run!
      self.result = []
      count = 0
      master_data_attribute_assignments = self.assignment[self.target_model].reject{|key,value| value['csv'].blank?}
      data = CSV.read(self.upload.image.path, "r:#{self.encoding_type}", {:col_sep => self.separator})
      data.each do |row|
        master_object = nil
        if self.assignment_groups[self.target_model] == "create"
          master_object = self.target_model.constantize.new
        else
          master_object = find_or_create_by_attributes(master_data_attribute_assignments, row)
        end

        self.assignment.each do |key,sub_assignments|
          if key == self.target_model
            current_object = master_object
          else
            master_object.class.reflect_on_all_associations.collect { |r| r.name }.each do |cass|
              if master_object.send(cass).present? && master_object.send(cass).new.class == key.constantize
                #Hier fehlt noch der check auf self.assignment_groups
                current_object = master_object.send(cass).new
                break
              end
            end
          end
          sub_assignments.each do |attribute_name,value|
            data_to_save = parse_data_with_method(row[value['csv'].to_i],value['data_function'])
            next if data_to_save.blank?
            current_object.send("#{attribute_name}=", data_to_save)
          end
          unless current_object.save
            self.result << "#{count} - SubObject: #{master_object.errors.messages}"
          end
        end
        unless master_object.save
          self.result << "#{count} - #{master_object.errors.messages}"
        end
        count += 1
      end
      self.save
    end

    def init_nested_attributes
      self.upload ||= build_upload
      self.assignment ||= {}
    end

    def find_or_create_by_attributes(master_data_attribute_assignments, row)
      find_condition = []
      master_data_attribute_assignments.each do |attribute_name,value|
        data_to_search = parse_data_with_method(row[value['csv'].to_i],value['data_function'])
        next if data_to_search.blank?
        find_condition << "#{attribute_name} = '#{data_to_search}'"
      end
      find_master = self.target_model.constantize.where(find_condition.join(' AND '))

      if find_master.count == 0
        logger.warn("***"*20)
        logger.warn "#{find_condition}  ->  #{find_master.count}"
        return self.target_model.constantize.new
      elsif find_master.count == 1
        return find_master.first
      else
        self.result << "Dieses Object exisitiert schon mehrfach, keine eindeutige Zuweisung möglich: Neues Objekt wird erzeugt (#{row})"
        return self.target_model.constantize.new
      end
    end

    def parse_data_with_method(data,data_function)
      conv = Iconv.new("UTF-8", self.encoding_type)
      output = conv.iconv(data)
      return output
    end
  end
end
