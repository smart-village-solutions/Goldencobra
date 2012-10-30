*In Anlehnung an http://www.concrete5.org/documentation/*

# Introduction
## Basic CMS Features
- WYSIWYG text editor
- Preview your changes before publishing
- File manager with upload and preview generation
- Flexible meta data & vanity URLs for Search Engine Optimization (SEO)
- Content scheduling – write something now, and have it go live automatically later
- Sitemap
- RSS Feed
- Solr Suchserver
- Artikeltypen
- Mehrsprachigkeit möglich
- Widgets (statische und dynamische Inhalte)
- User- & Rollenverwaltung 
- Kommentarfunktion
- Export zu CSV, XML

- CMS ist der Held
- Conrad Content
- Mimi Medienverwaltung
- Eddie Event (Event-, Sponsoren, Ticketverwaltung)
- Newsletter-Modul mit Stammdatenverwaltung

- Kommunikation mit externen CRMs (siehe quirin bank)
- Anbindung an JavaScript MVC Frameworks möglich (siehe ulmen.tv)

### Projekte die mit Goldencobra laufen
4 Tagesspiegel-Portale, berlin-greeter.org, www.ulmen.tv ikusei.de, quirinbank.de


## System Requirements
- Ruby 1.9.2 or higher (recommended: 1.9.3)
- Ruby on Rails 3.2.8 or higher
- ImageMagik
- Ghostscript
- MySQL 5.x or higher
- Apache/nginx

### Wann ist ein Artikel online und aufrufbar?

1. Wenn das Häkchen „online“ gesetzt ist
2. Wenn das Datum nicht in der Zukunft liegt
3. Wenn unter **Einstellungen**—> Automatische Weiterleitung zu–> „deaktiviert“ ist
4. Wenn „Weiterleitung zu externer URL“ leer ist
- Wenn der unmittelbare und **alle weiteren Elternartikel** online sind (Punkte 1.– 4. müssen auch dort jeweils kontrolliert werden)

## License
The MIT License

Copyright (c) 2010, ikusei GmbH

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.