require 'test_helper.rb'

class BarcodesControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get barcodes_url
    assert_response :success
  end

  test "should get import" do
    get '/barcodes/import'
    assert_response :success
  end

end