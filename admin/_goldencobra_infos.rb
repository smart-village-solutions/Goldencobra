# encoding: utf-8

# ActiveAdmin.register_page "GoldencobraInfos" do

#   menu :priority => 20, :label => "Golden Cobra Infos"

#   content do
#     panel "Über Golden Cobra" do
#       div do

#       end
#     end
#     panel "Installation" do
#     	div do
#         h3 "Installation von Golden Cobra"

#         para "Um mit Golden Cobra ein neues Projekt zu erstellen, sind folgende Schritte notwenig:"
#         para "Im Gemfile: gem 'goldencobra', :git => 'git://github.com/ikusei/Goldencobra.git'"
#         para "Wurde das Gem ins Gemfile geschrieben, fuehren Sie fuer die Installation folgenden Befehl aus: 'rails generate goldencobra:install'"
#         para "Nun wurden alle Notwendigen Datein und Defaultwerte installiert."

#         h4 "Einstellungen bei der Installation:"
#           para "Es gibt viele Einstellungen, die im Backend fuer die jeweilige Installation angepasst werden koennen:"
#           para "goldencobra.widgets.recreate_cache: diese Einstellung ist ein boolean wert, der aussagt, ob der Cache bei den Widgets (Schnipsel) nach jeder Aenderung neu erstellt wird (true) oder nicht (false)."
#           para "goldencobra.menues.recreate_cache: dieselbe Einstellung wie bei den Widgets nur fuer die Menues."
#           para "goldencobra.geocode_ip_address: "
#           para "goldencobra.html2pdf_uid: "
#           para "goldencobra.use_solr: wird Solr verwendet (true) oder nicht (false). Solr ist eine open source Suchplattform von Apache Lucene, die vor allem fuer Volltextsuche, suche durch Filter, Datenbank integration und Dokumentverarbeitung wie PDF verwendet wird."
#       end
#     end
#     panel "Backend Verwaltung" do
#       div do
#         h2 "Verwendung des Backends von Golden Cobra"

#         h3 "Menue erstellen:"
#         para "Unter Navigationspunkt 'Content-Management' den Punkt 'Menüpunkte' oeffnen. Rechts oben den Button 'Menü erstellen' anklicken. Nach dem korrekten ausfuellen des Formularen auf den grauen Button 'Menue erstellen' klicken. Wenn alles richtig eingegeben wurde, wurde das Menue erstellt und ist nun auf der Uebersichtsseite sichtbar."

#         h3 "Artikel erstellen:"
#         para "Unter Navigationspunkt 'Content-Management' den Punkt  'Artikel' oeffnen. Rechts oben den Button 'Artikel erstellen' anklicken."
#         para  "Beim Typ des Artikels gibt es immer eine Uebersicht und eine Einzelseite. Bei der Uebersicht kann zusaetzlich zu den 'normalen' Angaben noch angegeben werde, welche Tags der Artikel hat, nach was Sortiert wird und wie viele Artikel es dazu geben darf.  Der Tag ist hilfreich fuer die Anzeige im Frontend. Wird z.B. Berlin angegeben, werden alle Artikel des gleichen Typs mit dem Tag Berlin angezeigt."

#         para  "Bei den Einzelseiten, kann z.B. beim Typ 'Berater Einzelseite' alles zum Berater angegeben werden. Also Name, Geburtsdatum usw. vom Berater. Nach dem angeben des Titels und des Types, auf den Button 'Artikel erstellen' klicken. Es erfolgt eine Weiterleitung zum Bearbeiten des Artikels."
#         para  "Nach dem angeben der moeglichen Eingaben, auf 'Artikel aktualisieren' klicken. Der Artikel wird gespeichert und in der Uebersicht angezeigt."

#         para  "Ein Artikel kann auch Importiert werden. Auf Button 'Import' rechts neben 'Artikel erstellen' klicken. Bei Upload den gewuenschten Artikel auswaehlen und auf 'Import erstellen' klicken."

#       h3 "Widget Options:"
#         para "Optionen um die Seite im Frontend zu gestalten. z.B. Slider 1 wird angeklickt, dann erscheint bei dem Artikel im Frontend auch Slider 1."

#       h3 "Medium erstellen:"
#         para "Unter Navigationspunkt 'Content-Management' den Punkt 'Medien' oeffnen. Rechts oben den Button 'Medium erstellen' klicken. Der Button 'Durchsuchen' oeffnet den Arbeitsplatz. Hier kann ein Bild gesucht werden und dieses hochgeladen werden. Nach dem ausfuellen der restlichen Angaben, auf 'Medium erstellen' klicken. Das Medium wurde gespeichert und erscheint in der Uebersicht."
#         para "Bei den Medien gibt es auch die Moeglichkeit eine Zip-Datei hoch zu laden. Wird eine Zip-Datei ausgewaehlt, erscheint nach dem hochladen ein Button 'Zip-Datei entpacken'. Wird die Datei entpackt, haben alle Bilder die selben angaben beim Quellenverzeichnis, den Tags und dem Rechteinhaber."

#       h3 "Schnipsel:"
#         para "Schnipsel dienen dazu, die Widget-Options bei den Artikeln zu erstellen. Um ein neues Schnipsel zu erstellen auf 'Content-Management' -> 'Schnipsel' -> 'Schnipsel erstellen' klicken. Nach dem ausfuellen des Formulars auf 'Schnipsel erstellen' klicken."
#         para "Der erstellte Schnipsel wird nun bei allen Artikeln, die angeklickt wurden, bei den Widget-Options angezeigt."

#       h3 "Benutzer erstellen:"
#         para "Ein neuer Benutzer wird angelegt unter: 'Einstellungen' -> 'Benutzer' -> 'Benutzer erstellen'. Formular ausfuellen und auf 'Benutzer erstellen' klicken. Der Benutzer wird angezeigt. Mit Klick auf 'Benutzer' rechts ueber 'Benutzer erstellen' kann auf die Uebersichtsseite zurueck geschalten werden."

#       h3 "Benutzerrollen:"
#         para "Neue Rollen koennen hinzugefuegt werden. z.B. Manager. Unter 'Einstellungen' -> 'Benutzerrollen' -> 'Benutzerrolle erstellen' kann ein neue Rolle hinzugefuegt werden. Unter 'Einstellungen' -> 'Zugriffsrechte' -> 'Zugriffsrechte erstellen' kann z.B fuer Manager die Rechte erstellt werden."

#       h3 "Einstellungen:"
#         para "dienen dazu, die Werte, die im Frontend angezeigt werden, zu aendern. z.B. 'weiterlesen' bei einem Artikel auf 'mehr' umzuaendern. der Pfad gibt an, wie die jeweilige Einstellung abgespeichert ist. z.B. 'link_to_article' hat den Pfad 1/4/5. Der Pfad bedeutet, dass vor 'link_to_article' noch 'goldencobra' mit ID 1 und 'article_index' mit ID 4 steht. 'link_to_article' hat die ID 5. Die Einstellungen koennen angezeigt, bearbeitet und geloescht werden."

#       h3 "Imports:"
#         para "bei den Imports wird angezeigt, welche Imports schon durchgefuehrt wurden."
#       end
#     end
#   end

#   sidebar "Angebundene Services" do
#     para "Frontend Bugtracker: http://www.bugherd.com/"
#   end
# end
