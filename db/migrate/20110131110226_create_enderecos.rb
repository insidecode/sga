class CreateEnderecos < ActiveRecord::Migration
  def self.up
    create_table :enderecos do |t|
      t.string :rua
      t.integer :numero
      t.string :bairro
      t.string :complemento, :limit => 100
      t.string :cep, :limit => 10
      t.integer :cidade_id
      t.integer :aluno_id
      t.timestamps
    end

    add_index(:enderecos, :cidade_id)
    add_index(:enderecos, :aluno_id)
  end

  def self.down
    drop_table :enderecos
  end
end
