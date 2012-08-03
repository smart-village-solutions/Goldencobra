ActiveAdmin.register_page "GoldencobraInfos" do

  menu :priority => 20, :label => "Goldencobra Infos"
  
  content do
    panel "Ueber Goldencobra" do
    	div do
    		
    		end
    	end
      "Hier steht etwas text.... https://github.com/ikusei/Goldencobra"
      <h2>Menü erstellen:</h2>

          <p>Unter Navigationspunkt "Content-Management" den Punkt "Menüpunkte" öffnen. Rechts oben den Button "Menü erstellen" anklicken. Nach dem korrekten ausfüllen des Formularen auf den grauen Button "Menü erstellen" klicken. Wenn alles richtig eingegeben wurde, wurde das Menü erstellt und ist nun auf der Übersichtsseite sichtbar. </p>


        <h2>Artikel erstellen:</h2>

          <p>Unter Navigationspunkt "Content-Management" den Punkt  "Artikel" öffnen. Rechts oben den Button "Artikel erstellen" anklicken. 
          <p>Beim Typ des Artikels gibt es immer eine Übersicht und eine Einzelseite. Bei der Übersicht kann zusätzlich zu den "normalen" Angaben noch angegeben werde, welche Tags der Artikel hat, nach was Sortiert wird und wie viele Artikel es dazu geben darf.  Der Tag ist hilfreich für die Anzeige im Frontend. Wird z.B. Berlin angegeben, werden alle Artikel des gleichen Typs mit dem Tag Berlin angezeigt. </p>

          <p>Bei den Einzelseiten, kann z.B. beim Typ "Berater Einzelseite" alles zum Berater angegeben werden. Also Name, Geburtsdatum usw. vom Berater. Nach dem angeben des Titels und des Types, auf den Button "Artikel erstellen" klicken. Es erfolgt eine Weiterleitung zum Bearbeiten des Artikels. </p>
          <p>Nach dem angeben der möglichen Eingaben, auf "Artikel aktualisieren" klicken. Der Artikel wird gespeichert und in der Übersicht angezeigt.

          <p>Ein Artikel kann auch Importiert werden. Auf Button "Import" rechts neben "Artikel erstellen" klicken. Bei Upload den gewünschten Artikel auswählen und auf "Import erstellen" klicken. </p>

          <h3>Widget Options:
          <p>Optionen um die Seite im Frontend zu gestalten. z.B. Slider 1 wird angeklickt, dann erscheint bei dem Artikel im Frontend auch Slider 1.


        <h2>Medium erstellen:</h2>

          <p>Unter Navigationspunkt "Content-Management" den Punkt "Medien" öffnen. Rechts oben den Button "Medium erstellen" klicken. Der Button "Durchsuchen…" öffnet den Arbeitsplatz. Hier kann ein Bild gesucht werden und dieses hochgeladen werden. Nach dem ausfüllen der restlichen Angaben, auf "Medium erstellen" klicken. Das Medium wurde gespeichert und erscheint in der Übersicht.</p>

          <p>Bei den Medien gibt es auch die Möglichkeit eine Zip-Datei hoch zu laden. Wird eine Zip-Datei ausgewählt, erscheint nach dem hochladen ein Button "Zip-Datei entpacken". Wird die Datei entpackt, haben alle Bilder die selben angaben beim Quellenverzeichnis, den Tags und dem Rechteinhaber.</p>


        <h2>Schnipsel:</h2>

          <p>Schnipsel dienen dazu, die Widget-Options bei den Artikeln zu erstellen. Um ein neues Schnipsel zu erstellen auf "Content-Management" -> "Schnipsel" -> "Schnipsel erstellen" klicken. Nach dem ausfüllen des Formulars auf "Schnipsel erstellen" klicken.</p>
          <p>Der erstellte Schnipsel wird nun bei allen Artikeln, die angeklickt wurden, bei den Widget-Options angezeigt.


        <h2>Benutzer erstellen:</h2>

          <p>Ein neuer Benutzer wird angelegt unter: "Einstellungen" -> "Benutzer" -> "Benutzer erstellen". Formular auffüllen und auf "Benutzer erstellen" klicken. Der Benutzer wird angezeigt. Mit Klick auf "Benutzer" rechts über "Benutzer erstellen" kann auf die Übersichtsseite zurück geschalten werden.</p>


        <h2>Benutzerrollen:</h2>

          <p>Neue Rollen können hinzugefügt werden. z.B. Manager. Unter "Einstellungen" -> "Benutzerrollen" -> "Benutzerrolle erstellen" kann ein neue Rolle hinzugefügt werden. Unter "Einstellungen" -> "Zugriffsrechte" -> "Zugriffsrechte erstellen" kann z.B für Manager die Rechte erstellt werden.</p>


        <h2>Einstellungen:</h2>

          <p>dienen dazu, die Werte, die im Frontend angezeigt werden, zu ändern. z.B. "weiterlesen" bei einem Artikel auf "mehr" umzuändern. der Pfad gibt an, wie die jeweilige Einstellung abgespeichert ist. z.B. "link_to_article" hat den Pfad 1/4/5. Der Pfad bedeutet, dass vor "link_to_article" noch "goldencobra" mit ID 1 und "article_index" mit ID 4 steht. "link_to_article" hat die ID 5. Die Einstellungen können angezeigt, bearbeitet und gelöscht werden.</p>


        <h2>Imports:</h2>

          <p>bei den Imports wird angezeigt, welche Imports schon durchgeführt wurden.</p>
    end
  end  

  sidebar "Optional eine Sidebar" do
    "Hi World"
  end
end


