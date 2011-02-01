# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110131112133) do

  create_table "alunos", :force => true do |t|
    t.string   "nome"
    t.string   "telefone",        :limit => 15
    t.string   "celular",         :limit => 15
    t.string   "email",           :limit => 50
    t.date     "data_nascimento"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cidades", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.string   "uf",         :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enderecos", :force => true do |t|
    t.string   "rua"
    t.integer  "numero"
    t.string   "bairro"
    t.string   "complemento", :limit => 100
    t.string   "cep",         :limit => 10
    t.integer  "cidade_id"
    t.integer  "aluno_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "enderecos", ["aluno_id"], :name => "index_enderecos_on_aluno_id"
  add_index "enderecos", ["cidade_id"], :name => "index_enderecos_on_cidade_id"

end
