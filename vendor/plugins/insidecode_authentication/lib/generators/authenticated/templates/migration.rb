class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table "<%= table_name %>", :force => true do |t|
      t.string     :login,                     :limit => 40, :null => false
      t.string     :nome,                      :limit => 40, :null => false
      t.string     :sobrenome,                 :limit => 60
      t.string     :crypted_password,          :limit => 40
      t.string     :salt,                      :limit => 40
      t.references :role
      t.timestamp  :last_login_at
      
      t.timestamp
    end
    add_index :<%= table_name %>, :login, :unique => true
    
    <%= class_name %>.create( :login => "admin", 
                    :nome => "Administrador", 
                    :password => "admin", 
                    :password_confirmation => "admin",
                    :role => Role.find_by_name("Administrador") )
  end

  def self.down
    drop_table "<%= table_name %>"
  end
end