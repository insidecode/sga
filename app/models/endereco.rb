class Endereco < ActiveRecord::Base

	belongs_to :cidade
	belongs_to :aluno 

	validates_presence_of :rua, :message => "Deve ser preenchido"
	validates_presence_of :cep, :message => "Deve ser preenchido"

end
