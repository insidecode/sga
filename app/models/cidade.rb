class Cidade < ActiveRecord::Base

	has_many :enderecos

	validates_presence_of :nome, :message => "Deve ser preenchido"
	validates_presence_of :uf, :message => "Deve ser preenchido"
end
