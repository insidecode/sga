class AlunosController < ApplicationController
  # GET /alunos
  # GET /alunos.xml
  def index
    @alunos = Aluno.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @alunos }
    end
  end

  # GET /alunos/1
  # GET /alunos/1.xml
  def show
    @aluno = Aluno.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aluno }
    end
  end

  # GET /alunos/new
  # GET /alunos/new.xml
  def new
    @aluno = Aluno.new(:endereco => Endereco.new)
    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @aluno }
    end
  end

  # GET /alunos/1/edit
  def edit
    @aluno = Aluno.find(params[:id])
  end

  # POST /alunos
  # POST /alunos.xml
  def create
    @aluno = Aluno.new(params[:aluno])

    respond_to do |format|
      if @aluno.save
        format.html { redirect_to(@aluno, :notice => 'Registro foi gravado com sucesso!') }
        format.xml  { render :xml => @aluno, :status => :created, :location => @aluno }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /alunos/1
  # PUT /alunos/1.xml
  def update
    @aluno = Aluno.find(params[:id])

    respond_to do |format|
      if @aluno.update_attributes(params[:aluno])
        format.html { redirect_to(@aluno, :notice => 'Registro foi atualizado com sucesso!') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /alunos/1
  # DELETE /alunos/1.xml
  def destroy
    @aluno = Aluno.find(params[:id])
    @aluno.destroy

    respond_to do |format|
      format.html { redirect_to(alunos_url) }
      format.xml  { head :ok }
    end
  end
end
