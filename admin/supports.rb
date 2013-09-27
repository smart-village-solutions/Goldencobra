# encoding: utf-8

ActiveAdmin.register_page "Support" do

  menu :priority => 50, :label => "Live Support (⌘ + i)", :if => proc{Goldencobra::Setting.for_key("goldencobra.live-support.active") == "true"}

  content do
    panel "Support Anfrage" do
      div do
      	h3 "Anleitung"
      	para "So fordern Sie Hilfe an: Unterstüzt von https://togetherjs.com"
      	para raw("<button onclick='call_for_help();''>Hilfe Anfordern!</button>")
      end
    end
	end

end
