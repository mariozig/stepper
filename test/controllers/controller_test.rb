require 'helper'

class CompaniesControllerTest < ActionController::TestCase
  tests CompaniesController

  test "should raise error if commit is unknown" do
    Company.expects(:new).with({'name' => 'Hina'}).returns(mock_company)
    mock_company.expects(:save).returns(true)
    mock_company.stubs(:id).returns(1)
    assert_raise Stepper::StepperException do
      post(:create, {:company => {:name => "Hina"}, :commit => "some commit"})
    end
  end

  test "should assign resource if params[:id] exists" do
    Company.expects(:find).with('1').returns(mock_company)
    get :new, :id => 1
    assert_response :success
    assert_equal assigns(:company), mock_company
  end

  test "should get existing assigns" do
    @controller.instance_variable_set(:@company, mock_company)
    get :new, :id => 1
    assert_equal assigns(:company), mock_company
  end

  protected
    def mock_company(stubs={})
      @mock_company ||= mock(stubs)
    end
end

class CompaniesCreateControllerTest < ActionController::TestCase
  tests CompaniesController

  setup do
    Company.expects(:new).with({'name' => 'Hina'}).returns(mock_company)
    mock_company.expects(:save).returns(true)
    mock_company.stubs(:id).returns(1)
  end

  test "should redirect to next step if commit 'Next step'" do
    post(:create, {:company => {:name => "Hina"}, :commit => "Next step"})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies/new?id=1"
  end

  test "should redirect to index if commit 'Finish later'" do
    mock_company.stubs(:current_step).returns("step1")
    post(:create, {:company => {:name => "Hina"}, :commit => "Finish later"})
    assert_response :redirect
    assert_equal flash[:notice], "Step Step1 was successfully created."
    assert_redirected_to "http://test.host/companies"
  end

  protected
  def mock_company(stubs={})
    @mock_company ||= mock(stubs)
  end
end

class CompaniesUpdateControllerTest < ActionController::TestCase
  tests CompaniesController

  setup do
    Company.expects(:find).with('1').returns(mock_company)
    mock_company.expects(:attributes=).with({'code' => '23'}).returns(true)
    mock_company.expects(:save).returns(true)
    mock_company.stubs(:id).returns(1)
  end

  test "should redirect to next step if commit 'Next step'" do
    put(:update, {:company => {:code => "23"}, :commit => "Next step", :id => 1})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies/new?id=1"
  end

  test "should redirect to index if commit 'Finish later'" do
    mock_company.stubs(:current_step).returns("step2")
    put(:update, {:company => {:code => "23"}, :commit => "Finish later", :id => 1})
    assert_response :redirect
    assert_equal flash[:notice], "Step Step2 was successfully created."
    assert_redirected_to "http://test.host/companies"
  end

  test "should redirect to previous step if commit 'Previous step'" do
    mock_company.expects(:previous_step!)
    mock_company.stubs(:current_step).returns("step2")
    put(:update, {:company => {:code => "23"}, :commit => "Previous step", :id => 1})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies/new?id=1"
  end

  protected
  def mock_company(stubs={})
    @mock_company ||= mock(stubs)
  end
end