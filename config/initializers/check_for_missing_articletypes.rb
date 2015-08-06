Rails.application.config.to_prepare do
	Goldencobra::Articletype.reset_to_default
end
