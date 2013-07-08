module Goldencobra
	class Author < ActiveRecord::Base
		has_one :article

		def title
			self.try(:firstname) + " " + self.try(:lastname)
		end
	end
end