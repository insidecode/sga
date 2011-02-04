class <%= model_controller_class_name %>Controller < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # GET /<%= model_controller_plural_name %>
  # GET /<%= model_controller_plural_name %>.xml
  def index
    @<%= model_controller_plural_name %> = <%= class_name %>.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= model_controller_plural_name %> }
      format.json { render :json => @<%= model_controller_plural_name %>.to_json }
    end
  end

  # GET /<%= model_controller_plural_name %>/new
  # GET /<%= model_controller_plural_name %>/new.xml
  def new
    @<%= file_name %> = <%= class_name %>.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
  end
 
  # GET /<%= model_controller_plural_name %>/1/edit
  def edit
    @<%= file_name %> = <%= class_name %>.find(params[:id])
  end
 
  # POST /<%= file_name %>
  # POST /<%= file_name %>.xml
  def create
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])
    
    respond_to do |format|
      if @<%= file_name %>.save
        format.html { redirect_to(<%= model_controller_plural_name %>_path, :notice => 'Registro criado com sucesso.') }
        format.xml  { render :xml => @<%= file_name %>, :status => :created, :location => @<%= file_name %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /<%= file_name %>/1
  # PUT /<%= file_name %>/1.xml
  def update
    @<%= file_name %> = <%= class_name %>.new(params[:id])

    respond_to do |format|
      if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
        format.html { redirect_to(<%= model_controller_plural_name %>_path, :notice => 'Registro atualizado com sucesso.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /<%= file_name %>/1
  # DELETE /<%= file_name %>/1.xml
  def destroy
    @<%= file_name %> = <%= class_name %>.new(params[:id])
    @<%= file_name %>.destroy

    respond_to do |format|
      format.html { redirect_to(<%= model_controller_plural_name %>_url) }
      format.xml  { head :ok }
    end
  end
end