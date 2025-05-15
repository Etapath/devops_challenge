require "application_system_test_case"

class ImagesTest < ApplicationSystemTestCase
  setup do
    @image = images(:one)
  end

  test "visiting the index" do
    visit images_url
    assert_selector "h1", text: "Images"
  end

  test "should create image" do
    visit images_url
    click_on "New image"

    fill_in "Name", with: @image.name
    find("input[type='file']").send_keys(Rails.root.join("test/fixtures/files/sample_picture.jpg"))
    click_on "Create Image"

    assert_text "Image was successfully created"

    click_on "Back"
  end

  test "should destroy Image" do
    visit image_url(@image)
    accept_confirm { click_on "Destroy this image", match: :first }

    assert_text "Image was successfully destroyed"
  end
end
