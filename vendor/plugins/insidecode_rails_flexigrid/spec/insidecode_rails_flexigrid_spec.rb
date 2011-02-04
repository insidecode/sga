require 'rubygems'
require 'rspec'
require 'active_support'
require 'action_view' # ugly but temporary

require File.dirname(__FILE__) + '/../lib/insidecode_rails_flexigrid'
Array.send :include, FlexigridJson
include Flexigrid

class User
  attr_accessor :id
  attr_accessor :username
  attr_accessor :email
  attr_accessor :password
  attr_accessor :parent
  
  def initialize(options = {})
    @id       = options[:id]
    @username = options[:username]
    @email    = options[:email]
    @password = options[:password]
  end
  
  def a_virtual_attribute
    username.reverse
  end
  
  def to_json # This method is available by default on all ActiveRecord objects
    "{\"user\": {\"username\": \"#{username}\", \"id\": #{id}, \"email\": \"#{email}\", \"password\": \"#{password}\"}}"
  end
  
  def attributes # This method is available by default on all ActiveRecord objects
    { 'id' => id, 'username' => username, 'email' => email, 'password' => password }
  end
end

describe "to_flexigrid_json" do
  
  before(:each) do 
    @data = []
    5.times do |i|
      @data << User.new(:id => i+1, :username => "user_#{i+1}", :email => "user_#{i+1}@test.be", :password => "a_password")
    end
  end
  
  it "should generate a valid JSON representation of the data" do
    json = @data.to_flexigrid_json([:id, :username, :email, :password], 1, @data.size)
    json.should == "{\"page\":\"1\",\"total\":\"5\",\"rows\":[{\"id\":\"1\",\"cell\":[\"1\",\"user_1\",\"user_1@test.be\",\"a_password\"]},{\"id\":\"2\",\"cell\":[\"2\",\"user_2\",\"user_2@test.be\",\"a_password\"]},{\"id\":\"3\",\"cell\":[\"3\",\"user_3\",\"user_3@test.be\",\"a_password\"]},{\"id\":\"4\",\"cell\":[\"4\",\"user_4\",\"user_4@test.be\",\"a_password\"]},{\"id\":\"5\",\"cell\":[\"5\",\"user_5\",\"user_5@test.be\",\"a_password\"]}]}"
  end
  
  it "should include only specified attributes" do
    json = @data.to_flexigrid_json([:id, :username], 1, @data.size)
    json.should == "{\"page\":\"1\",\"total\":\"5\",\"rows\":[{\"id\":\"1\",\"cell\":[\"1\",\"user_1\"]},{\"id\":\"2\",\"cell\":[\"2\",\"user_2\"]},{\"id\":\"3\",\"cell\":[\"3\",\"user_3\"]},{\"id\":\"4\",\"cell\":[\"4\",\"user_4\"]},{\"id\":\"5\",\"cell\":[\"5\",\"user_5\"]}]}"
  end
  
  it "should include virtual attributes if they are specified" do
    json = @data.to_flexigrid_json([:id, :username, :a_virtual_attribute], 1,  @data.size)
    json.should == "{\"page\":\"1\",\"total\":\"5\",\"rows\":[{\"id\":\"1\",\"cell\":[\"1\",\"user_1\",\"1_resu\"]},{\"id\":\"2\",\"cell\":[\"2\",\"user_2\",\"2_resu\"]},{\"id\":\"3\",\"cell\":[\"3\",\"user_3\",\"3_resu\"]},{\"id\":\"4\",\"cell\":[\"4\",\"user_4\",\"4_resu\"]},{\"id\":\"5\",\"cell\":[\"5\",\"user_5\",\"5_resu\"]}]}"
  end
  
  it "should not generate rows if there is no data" do
    @data = []
    json = @data.to_flexigrid_json([:id, :username], 1, @data.size)
    json.should == "{\"page\":\"1\",\"total\":\"0\"}"
  end
  
  it "should use the index of the array as an ID if no ID is specified" do
    @data.each { |user| user.id = nil }
    json = @data.to_flexigrid_json([:username], 1, @data.size)
    json.should == "{\"page\":\"1\",\"total\":\"5\",\"rows\":[{\"id\":\"0\",\"cell\":[\"user_1\"]},{\"id\":\"1\",\"cell\":[\"user_2\"]},{\"id\":\"2\",\"cell\":[\"user_3\"]},{\"id\":\"3\",\"cell\":[\"user_4\"]},{\"id\":\"4\",\"cell\":[\"user_5\"]}]}"
  end
  
  it "should be possible to specify nested attributes using associations" do
    @data.each do |user|
      parent = User.new(:username => "Parent #{user.id}")
      user.parent = parent
    end
    json = @data.to_flexigrid_json([:id, :username, "parent.username"], 1, @data.size)
    json.should == "{\"page\":\"1\",\"total\":\"5\",\"rows\":[{\"id\":\"1\",\"cell\":[\"1\",\"user_1\",\"Parent 1\"]},{\"id\":\"2\",\"cell\":[\"2\",\"user_2\",\"Parent 2\"]},{\"id\":\"3\",\"cell\":[\"3\",\"user_3\",\"Parent 3\"]},{\"id\":\"4\",\"cell\":[\"4\",\"user_4\",\"Parent 4\"]},{\"id\":\"5\",\"cell\":[\"5\",\"user_5\",\"Parent 5\"]}]}"
  end
  
  it "should be possible to specify nested attributes using associations on multiple levels" do
    @data.each do |user|
      parent = User.new(:username => "Parent #{user.id}")
      parent_of_parent = User.new(:username => "Parent Parent #{user.id}")
      parent.parent = parent_of_parent
      user.parent = parent
    end
    json = @data.to_flexigrid_json([:id, :username, "parent.username", "parent.parent.username"], 1, @data.size)
    json.should == "{\"page\":\"1\",\"total\":\"5\",\"rows\":[{\"id\":\"1\",\"cell\":[\"1\",\"user_1\",\"Parent 1\",\"Parent Parent 1\"]},{\"id\":\"2\",\"cell\":[\"2\",\"user_2\",\"Parent 2\",\"Parent Parent 2\"]},{\"id\":\"3\",\"cell\":[\"3\",\"user_3\",\"Parent 3\",\"Parent Parent 3\"]},{\"id\":\"4\",\"cell\":[\"4\",\"user_4\",\"Parent 4\",\"Parent Parent 4\"]},{\"id\":\"5\",\"cell\":[\"5\",\"user_5\",\"Parent 5\",\"Parent Parent 5\"]}]}"
  end
  
  it "should return an empty string if the associated object is nil" do
    json = @data.to_flexigrid_json([:id, "parent.username"], 1, @data.size)
    p json
  end
  
end

module FlexigridTestHelper
  def flexigrid_shortcut(options = {})
    flexigrid("Users", "users", "/users",
            [
          		{ :field => "id", :display => "ID", :width => 35 },
          		{ :field => "username", :display => "Username" },
          		{ :field => "email", :display => "Email" },
          		{ :field => "password", :display => "Password" }
          	], options
          )
  end

  def flexigrid_with_search_shortcut(options = {})
    flexigrid("Users", "users", "/users",
            [
          		{ :field => "id", :display => "ID", :width => 35 },
          		{ :field => "username", :display => "Username", :searchable => true },
          		{ :field => "email", :display => "Email" },
          		{ :field => "password", :display => "Password" }
          	], options
          )
  end
end

describe "flexigrid helper method" do
  
  include FlexigridTestHelper
  
  describe "generating a simple flexigrid without options" do
  
    before(:each) do
      @grid = flexigrid_shortcut
    end
  
    it "should generate required HTML tags and set them in the JS" do
      @grid.include?(%Q(<table id="users")).should be_true
      @grid.include?(%Q($("#users").flexigrid)).should be_true
    end
    
    it "should set a title and an URL" do
      @grid.include?(%Q(title: 'Users')).should be_true
      @grid.include?(%Q(url: '/users')).should be_true
    end
  
    it "should generate a valid data model" do
      @grid.include?("dataType: 'json'").should be_true
      @grid.include?(%Q(colModel:[{display:'ID', name:'id',width:35},{display:'Username', name:'username'},{display:'Email', name:'email'},{display:'Password', name:'password'}])).should be_true
    end
    
  end
  
  describe "generating a flexigrid with options" do
    
    it "should be possible to add the search toolbar" do
      @grid = flexigrid_with_search_shortcut
      @grid.include?("searchitems : [{display:'Username', name:'username'}]").should be_true
    end
    
    it "should be possible to overwrite sorting default behaviors" do
      @grid = flexigrid_shortcut(:sort_name => 'username', :sort_order => 'desc')
      @grid.include?("sortname: 'username'").should be_true
      @grid.include?("sortorder: 'desc'").should be_true
    end
    
    it "should be possible to resize the grid" do
      @grid = flexigrid_shortcut(:height => 500, :width => 800)
      @grid.include?("height: 500").should be_true
      @grid.include?("width: 800").should be_true
    end
    
    it "should be possible to show row numbers and set rows per page" do
      @grid = flexigrid_shortcut(:rows_per_page => 5, :use_rp => true)
      @grid.include?("rp: 5").should be_true
      @grid.include?("useRp: true").should be_true
    end
  end
end