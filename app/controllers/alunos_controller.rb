class AlunosController < ApplicationController
  # GET /alunos
  # GET /alunos.xml
  def index

    page = params[:page]
    rp = params[:rp]

    @alunos = Aluno.flexigrid_find(params)
    total = @alunos.size
    @alunos = @alunos.paginate({:page => page, :per_page => rp})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @alunos }
      format.xml  { render :xml => @enderecos }
      format.json { render :json => @alunos.to_flexigrid_json([:id, :nome, :telefone, :celular, :email, :data_nascimento, "endereco.rua", "endereco.numero", "endereco.bairro", "endereco.complemento", "endereco.cep", "endereco.cidade.nome", "endereco.cidade.uf"], page, total)}

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
        format.html { redirect_to(alunos_path, :notice => 'Registro foi gravado com sucesso!') }
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
        format.html { redirect_to(alunos_path, :notice => 'Registro alterado com sucesso!') }
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
