# encoding: utf-8

module Goldencobra
	class Author < ActiveRecord::Base
    attr_accessible :firstname, :lastname, :email, :googleplus

		has_many  :article_authors
    has_many  :articles, through: :article_authors

		web_url :googleplus

		def title
			[self.try(:firstname), self.try(:lastname)].join(" ")
		end
	end
end

# == Schema Information
#
# Table name: goldencobra_authors
#
#  id         :integer          not null, primary key
#  firstname  :string(255)
#  lastname   :string(255)
#  email      :string(255)
#  googleplus :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
