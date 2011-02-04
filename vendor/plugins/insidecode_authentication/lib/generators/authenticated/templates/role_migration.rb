#coding: utf-8

class CreateRoles < ActiveRecord::Migration
	def self.up
	  create_table :roles do |t|
	    t.string :name, :limit => 20, :null => false

	    t.timestamps
	  end
  
	  Role.create(:name =>"Administrador")
	  Role.create(:name =>"Gerente")
	  Role.create(:name =>"Funcionário")
	end

	def self.down
	  drop_table :roles
	end
end