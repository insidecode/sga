class Aluno < ActiveRecord::Base

	has_one :endereco, :dependent => :destroy
	
	validates_presence_of :nome, :message => "Deve ser preenchido"
	validates_presence_of :data_nascimento, :message => "Deve ser preenchido"
	validates_presence_of :email, :message => "Deve ser preenchido"
	validates_uniqueness_of :nome, :message => "Nome ja cadastrado"
	validates_uniqueness_of :email, :message => "E-mail ja cadastrado"

	accepts_nested_attributes_for :endereco
	
end
