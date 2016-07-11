require 'test_helper'

class UserAddressesControllerTest < ActionController::TestCase
  setup do
    @user_address = user_addresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_addresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_address" do
    assert_difference('UserAddress.count') do
      post :create, user_address: { address: @user_address.address, city: @user_address.city, company: @user_address.company, email: @user_address.email, fname: @user_address.fname, lname: @user_address.lname, mobile: @user_address.mobile, user_id: @user_address.user_id, zip_code: @user_address.zip_code, zone_id: @user_address.zone_id }
    end

    assert_redirected_to user_address_path(assigns(:user_address))
  end

  test "should show user_address" do
    get :show, id: @user_address
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_address
    assert_response :success
  end

  test "should update user_address" do
    patch :update, id: @user_address, user_address: { address: @user_address.address, city: @user_address.city, company: @user_address.company, email: @user_address.email, fname: @user_address.fname, lname: @user_address.lname, mobile: @user_address.mobile, user_id: @user_address.user_id, zip_code: @user_address.zip_code, zone_id: @user_address.zone_id }
    assert_redirected_to user_address_path(assigns(:user_address))
  end

  test "should destroy user_address" do
    assert_difference('UserAddress.count', -1) do
      delete :destroy, id: @user_address
    end

    assert_redirected_to user_addresses_path
  end
end
