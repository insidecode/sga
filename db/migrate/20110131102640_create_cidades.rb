class CreateCidades < ActiveRecord::Migration
  def self.up
    create_table :cidades do |t|
      t.string :nome, :limit => 100
      t.string :uf, :limit => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :cidades
  end
end
