Rails.application.config.to_prepare do
  if !File.exists?(File.join(::Rails.root,"app","controllers","extend_goldencobra_articles_controller.rb"))
    t = File.open(File.join(Goldencobra::Engine.root,'lib/generators/goldencobra/templates/extend_goldencobra_articles_controller.rb'), "r")
    f = File.open(File.join(::Rails.root, 'app/controllers/extend_goldencobra_articles_controller.rb'), "w+") {|f| f.write(t.read)}
  end
  if defined?(ExtendGoldencobraArticlesController) == 'constant' && ExtendGoldencobraArticlesController.class == Module
    Goldencobra::ArticlesController.class_eval { include ExtendGoldencobraArticlesController  }
  end
end