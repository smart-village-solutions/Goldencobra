xml.instruct! :xml, version: "1.0" 
xml.rss version: "2.0" do
  xml.channel do
    xml.title @article.title
    xml.description @article.summary
    xml.link @article.absolute_public_url

    if @list_of_articles
      @list_of_articles.each do |article|
        xml.item do
          xml.title article.title
          # Eigene Description Darstellung für den Berater Feed
          if article.article_type.present? && article.article_type_form_file == "Consultant"
            xml.description do
              xml.cdata!("<html xmlns:i18n='http://apache.org/cocoon/i18n/2.1'><head><title>#{article.consultant.full_name_with_title}</title><style type='text/css' media='screen'> body{ font-family: 'Trebuchet MS', Tahoma, Geneva, Helvetica, Arial, sans-serif; font-weight: normal; font-size:11px; color: #6A6A6A; margin: 0 10px 10px 10px; padding: 0; } h1, h2{ color: #7E1C3E; font-size: 18px; font-family: Georgia, Palatino, Century, Times New Roman, Times, serif; border-bottom: 1px dotted #6A6A6A; padding: 15px 0 2px 0; } dl{ float: left; margin: 6px 0 0 0; } dl dt{ margin: 0 4px 0 0; font-weight: bold; clear: both; float: left; } dl dt.fullWidth { width: 100%; } dl dt.distance, dl dd.distance{ margin-top: 13px; } dl dd{ margin: 0 5px 0 0; float: none; display: block; } p, address{ clear: both; float: none; } address{ color: #1F697F; } </style></head><body><h1>#{article.consultant.full_name_with_title}</h1><div><dl><dt>Jahrgang:</dt><dd>#{article.consultant.birthday.strftime('%Y') if article.consultant.birthday}</dd><dt>Geburtsort:</dt><dd>#{article.consultant.birthplace}</dd><dt>Aufgewachsen in:</dt><dd>#{article.consultant.grown_up_place}</dd><dt class='fullWidth distance'>Spezialist für:</dt><dd>#{article.consultant.expertise}</dd><dt class='fullWidth distance'>Ausbildung:</dt><dd>#{article.consultant.education}</dd><dt class='fullWidth distance'>Werdegang:</dt><dd>#{article.consultant.career}</dd><dt class='distance'>Sprachen:</dt><dd class='distance'>#{article.consultant.languages}</dd><dt>Liebste Freizeitbeschäftigung:</dt><dd class='fullWidth'>#{article.consultant.hobby}</dd><dt>Liebstes Urlaubsziel:</dt><dd>#{article.consultant.holiday_destination}</dd><dt>Lieblingsbuch:</dt><dd>#{article.consultant.favorite_book}</dd><dt>Lieblingsort in :</dt><dd></dd><dt class='distance'>Telefon:</dt><dd class='distance'>#{article.consultant.phone}</dd><dt class='distance'>Erreichbar:</dt><dd class='distance'>#{article.consultant.available_times}</dd></dl></div><div><h2>Berater kontaktieren</h2><p>Möchten Sie mit #{article.consultant.full_name} Kontakt aufnehmen?</p><dl><dt class='telefon default'><strong>Telefon:</strong></dt><dd class='telefon'>#{article.consultant.phone}</dd><dt class='hide'>Erreichbar von:</dt><dd class='followHide'> #{article.consultant.available_times}</dd></dl><address class='consultantAddress default'>#{article.consultant.email}</address><p>Oder möchten Sie zu einer anderen Zeit von ihm zurückgerufen werden?</p></div></body></html>")
            end
          else
            # normale Description für alle anderen Feeds
            xml.description do
              xml.cdata!(article.content)
            end
          end
          xml.pubDate article.published_at.strftime("%a, %d %b %Y %H:%M:%S %z")
          xml.link article.absolute_public_url
          xml.guid article.absolute_public_url
          if article.images && article.images.count > 0
            ai = article.images.first
            xml.tag! "enclosure", :type => ai.image_content_type, :url => "http://#{Goldencobra::Setting.for_key('goldencobra.url')}#{ai.image.url(:thumb)}", :length => ai.image_file_size
            xml.tag! "enclosure", :type => ai.image_content_type, :url => "http://#{Goldencobra::Setting.for_key('goldencobra.url')}#{ai.image.url(:medium)}", :length => ai.image_file_size
          end
          xml.tag! "quirin:rating", "0.0"
          xml.tag! "quirin:teaser" do
           xml.cdata!(article.teaser)
          end
          xml.comments ""
          if article.respond_to?(:article_type_xml_fields)
            if article.article_type_xml_fields.present?
              article.article_type_xml_fields.each do |field, value|
                xml.tag! field, raw(value)
              end
            end
          end
        end
      end
    end
  end
end
