require 'test_helper'

class UniqueControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get info" do
    get :info
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get destinations" do
    get :destinations
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get send_contact_mail" do
    get :send_contact_mail
    assert_response :success
  end

end
