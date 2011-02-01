class CreateAlunos < ActiveRecord::Migration
  def self.up
    create_table :alunos do |t|
      t.string :nome
      t.string :telefone, :limit => 15
      t.string :celular, :limit => 15
      t.string :email, :limit => 50
      t.date :data_nascimento
      t.timestamps
    end
  end

  def self.down
    drop_table :alunos
  end
end
