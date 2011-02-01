require 'test_helper'

class AlunosControllerTest < ActionController::TestCase
  setup do
    @aluno = alunos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:alunos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create aluno" do
    assert_difference('Aluno.count') do
      post :create, :aluno => @aluno.attributes
    end

    assert_redirected_to aluno_path(assigns(:aluno))
  end

  test "should show aluno" do
    get :show, :id => @aluno.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @aluno.to_param
    assert_response :success
  end

  test "should update aluno" do
    put :update, :id => @aluno.to_param, :aluno => @aluno.attributes
    assert_redirected_to aluno_path(assigns(:aluno))
  end

  test "should destroy aluno" do
    assert_difference('Aluno.count', -1) do
      delete :destroy, :id => @aluno.to_param
    end

    assert_redirected_to alunos_path
  end
end
