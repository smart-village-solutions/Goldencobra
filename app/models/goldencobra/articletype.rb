# encoding: utf-8

module Goldencobra
  class Articletype < ActiveRecord::Base
    attr_accessible :default_template_file, :name, :fieldgroups_attributes
    has_many :articles, :class_name => Goldencobra::Article, :foreign_key => :article_type, :primary_key => :name
    validates_uniqueness_of :name

    has_many :fieldgroups, :class_name => Goldencobra::ArticletypeGroup, :dependent => :destroy
    accepts_nested_attributes_for :fieldgroups, :allow_destroy => true

    ArticleFieldOptions = {
        :title => %{<% f.input :title, :hint => I18n.t("goldencobra.article_field_hints.title") %>},
        :subtitle => %{<% f.input :subtitle %>},
        :content => %{<% f.input :content, :input_html => { :class => "tinymce" } %>},
        :teaser => %{<% f.input :teaser, :hint => I18n.t("goldencobra.article_field_hints.teaser"), :input_html => { :rows => 5 } %>},
        :summary => %{<% f.input :summary, hint: "Dient einer zusammenfassenden Einleitung in den Haupttext und wird hervorgehoben dargestellt", :input_html => { :rows => 5 } %>},
        :tag_list => %{<% f.input :tag_list, :hint => "Tags sind komma-getrennte Werte, mit denen sich ein Artikel intern gruppiern l&auml;sst", :wrapper_html => { class: 'expert' } %>},
        :frontend_tag_list => %{<% f.input :frontend_tag_list, hint: "Hier eingetragene Begriffe werden auf &Uuml;bersichtsseiten als Filteroptionen angeboten.", :wrapper_html => { class: 'expert' } %>},
        :active => %{<% f.input :active, :hint => "Soll dieser Artikel im System aktiv und online sichtbar sein?", :wrapper_html => { class: 'expert' } %>},
        :active_since => %{<% f.input :active_since, :hint => "Wenn der Artikel online ist, seit wann ist er online? Bsp: 02.10.2011 15:35", as: :string, :input_html => { class: "", :size => "20" }, :wrapper_html => { class: 'expert' } %>},
        :context_info => %{<% f.input :context_info, :input_html => { :class => "tinymce" }, :hint => "Dieser Text ist f&uuml;r eine Sidebar gedacht" %>},
        :metatags => %{<% f.has_many :metatags do |m|
          m.input :name, :as => :select, :collection => Goldencobra::Article::MetatagNames, :input_html => { :class => 'metatag_names'}, :hint => "Hier k&ouml;nnen Sie die verschiedenen Metatags definieren, sowie alle Einstellungen f&uuml;r den OpenGraph vonehmen"
          m.input :value, :input_html => { :class => 'metatag_values'}
          m.input :_destroy, :label => "entfernen/zurücksetzen", :hint => "hiermit werden die Werte entfernt bzw. auf ihren Ursprung zurückgesetzt", :as => :boolean
        end %>},
        :breadcrumb => %{<% f.input :breadcrumb, :hint => "Kurzer Titel f&uuml;r die Breadcrumb-Navigation" %>},
        :url_name => %{<% f.input :url_name, :hint => "Nicht mehr als 64 Zeichen, sollte keine Umlaute, Sonderzeichen oder Leerzeichen enthalten. Wenn die Seite unter 'http://meine-seite.de/mein-artikel' erreichbar sein soll, tragen Sie hier 'mein-artikel' ein.", required: false %>},
        :parent_id => %{<% f.input :parent_id, :hint => "Auswahl des Artikels, der in der Seitenstruktur _oberhalb_ liegen soll. Beispiel: http://www.meine-seite.de/der-oberartikel/mein-artikel", :as => :select, :collection => Goldencobra::Article.all.map{|c| [c.parent_path, c.id]}.sort{|a,b| a[0] <=> b[0]}, :include_blank => true, :input_html => { :class => 'chzn-select-deselect', :style => 'width: 70%;', 'data-placeholder' => 'Elternelement auswählen' } %>},
        :canonical_url => %{<% f.input :canonical_url, :label => "Canonical URL", :hint => "Falls auf dieser Seite Inhalte erscheinen, die vorher schon auf einer anderen Seite erschienen sind, sollte hier die URL der Quellseite eingetragen werden, um von Google nicht f&uuml;r doppelten Inhalt abgestraft zu werden" %>},
        :enable_social_sharing => %{<% f.input :enable_social_sharing, :label => "'Social Sharing'-Aktionen anzeigen", :hint => "Sollen Besucher Aktionen angezeigt bekommen, um diesen Artikel in den sozialen Netzwerken zu verbreiten?" %>},
        :robots_no_index => %{<% f.input :robots_no_index, :label => "Artikel nicht durch Suchmaschinen finden lassen", :hint => "Um bei Google nicht in Konkurrenz zu anderen wichtigen Einzelseiten der eigenen Webseite zu treten, kann hier Google mitgeteilt werden, diese Seite nicht zu indizieren" %>},
        :cacheable => %{<% f.input :cacheable, :label => "Artikel cachebar", :as => :boolean, :hint => "Dieser Artikel darf im Cache liegen" %>},
        :commentable => %{<% f.input :commentable, :label => "Artikel kommentierbar", :as => :boolean, :hint => "Kommentarfunktion für diesen Artikel aktivieren?" %>},
        :dynamic_redirection => %{<% f.input :dynamic_redirection, :label => "Automatische Weiterleitung", :as => :select, :collection => Goldencobra::Article::DynamicRedirectOptions.map{|a| [a[1], a[0]]}, :include_blank => false %>},
        :external_url_redirect => %{<% f.input :external_url_redirect, :label => "Weiterleitung zu externer URL" %>},
        :redirect_link_title => %{<% f.input :redirect_link_title, :label => "Name des externen Links" %>},
        :redirection_target_in_new_window => %{<% f.input :redirection_target_in_new_window, :label => "Weiterleitung in neuem Fenster öffnen?" %>},
        :author => %{<% f.input :author, :label => "Autor", :hint => "Wer ist der Verfasser dieses Artikels?" %>},
        :permissions => %{<% f.has_many :permissions do |p|
          p.input :role, :include_blank => "Alle"
          p.input :action, :as => :select, :collection => Goldencobra::Permission::PossibleActions, :include_blank => false
          p.input :_destroy, :as => :boolean
        end %>},
        :article_images => %{<% f.has_many :article_images do |ai|
          ai.input :image, :as => :select, :collection => Goldencobra::Upload.order("updated_at DESC").map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'article_image_file chzn-select', :style => 'width: 70%;', 'data-placeholder' => 'Medium auswählen' }, :label => "Medium wählen"
          ai.input :position, :as => :select, :collection => Goldencobra::Setting.for_key("goldencobra.article.image_positions").split(",").map(&:strip), :include_blank => false
          ai.input :_destroy, :as => :boolean
        end %>}
    }

  end
end
