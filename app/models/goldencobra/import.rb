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
    BlockedAttributes = ["id", "created_at", "updated_at", "url_name", "slug", "upload_id", "images", "article_images", "article_widgets", "permissions", "versions"]
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
      begin
        CSV.read(self.upload.image.path, "r:#{self.encoding_type}", {:col_sep => self.separator})
      rescue
        [["Error in reading File: Please check encoding type"]]
      end
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
      all_data_attribute_assignments = remove_emty_assignments
      master_data_attribute_assignments = all_data_attribute_assignments[self.target_model]
      data = CSV.read(self.upload.image.path, "r:#{self.encoding_type}", {:col_sep => self.separator})
      data.each do |row|
        master_object = nil
        current_object = nil
        #Neues Object anlegen oder bestehendes suchen und aktualisieren
        if self.assignment_groups[self.target_model] == "create"
          master_object = self.target_model.constantize.new
        else
          master_object = find_or_create_by_attributes(master_data_attribute_assignments, row, self.target_model)
        end

        all_data_attribute_assignments.each do |key,sub_assignments|
          if key == self.target_model
            current_object = master_object
          else
            logger.warn("--- #"*40)
            master_object.class.reflect_on_all_associations.collect { |r| r.name }.each do |cass|
              if master_object.send(cass).class == Array
                cass_related_model = eval("master_object.#{cass}.build").class
              else
                cass_related_model = master_object.send("build_#{cass}").try(:class)
              end
              if cass_related_model == key.constantize
                logger.warn("#"*40)
                logger.warn("KEY: #{key}")
                #Neues Unter Object anlegen oder bestehendes suchen und aktualisieren
                if self.assignment_groups[key] == "create"
                  current_object = key.constantize.new
                  logger.warn("Neues Object wird erzeugt")
                else
                  current_object = find_or_create_by_attributes(sub_assignments, row, key)
                  logger.warn("Altes object wird gesucht oder neues angelegt")
                end
                #Das aktuelle unterobjeect wird dem Elternelement hinzugefügt
                master_object.send(cass) << current_object
                break
              end
            end
          end
          #die Werte für das Object werden gesetzt
          sub_assignments.each do |attribute_name,value|
            data_to_save = parse_data_with_method(row[value['csv'].to_i],value['data_function'],value['option'])
            next if data_to_save.blank?
            current_object.send("#{attribute_name}=", data_to_save)
          end
          #Das Object wird gespeichert
          unless current_object.save
            self.result << "#{count} - SubObject: #{current_object.errors.messages}"
          end
        end
        #Das Elternelement wird gespeichert
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

    def find_or_create_by_attributes(attribute_assignments, row, model_name)
      find_condition = []
      attribute_assignments.each do |attribute_name,value|
        data_to_search = parse_data_with_method(row[value['csv'].to_i],value['data_function'],value['option'])
        next if data_to_search.blank?
        find_condition << "#{attribute_name} = '#{data_to_search}'"
      end
      find_master = model_name.constantize.where(find_condition.join(' AND '))

      if find_master.count == 0
        return model_name.constantize.new
      elsif find_master.count == 1
        return find_master.first
      else
        self.result << "Dieses Object exisitiert schon mehrfach, keine eindeutige Zuweisung möglich: Neues Objekt wird erzeugt (#{row})"
        return model_name.constantize.new
      end
    end

    def parse_data_with_method(data,data_function,data_option)
      conv = Iconv.new("UTF-8", self.encoding_type)
      output = conv.iconv(data)
      if data_function == "Default"
        return output
      elsif data_function == "Static Value"
        return data_option
      end
    end

    def remove_emty_assignments
      self.assignment.each do |key, values|
        self.assignment[key].delete_if{|key,value| value['data_function'] == "Default" && value['csv'].blank?}
        if self.assignment[key].blank?
          self.assignment.delete(key)
        end
      end
      self.assignment
    end

  end
end
