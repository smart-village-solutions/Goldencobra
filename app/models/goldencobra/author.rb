module Goldencobra
	class Author < ActiveRecord::Base
		has_many :article

		def title
			[self.try(:firstname),self.try(:lastname)].join(" ")
		end
	end
end