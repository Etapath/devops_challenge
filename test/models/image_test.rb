require "test_helper"

class ImageTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @image = Image.new(name: "test_image.jpg")
    @image.original.attach(
      io: File.open(Rails.root.join("test/fixtures/files/sample_picture.jpg")),
      filename: "test_image.jpg",
      content_type: "image/jpeg"
    )
  end

  test "should have default status of scheduled" do
    assert_equal "scheduled", @image.status
  end

  test "should change status to processing before create" do
    @image.save
    assert_equal "processing", @image.status
  end

  test "should enqueue ImageDesaturationJob after create" do
    assert_enqueued_with(job: ImageDesaturationJob) do
      @image.save
    end
  end

  test "should have original and thumbnail attachments" do
    assert @image.respond_to?(:original)
    assert @image.respond_to?(:thumbnail)
  end

  test "should have valid status enum values" do
    valid_statuses = ["scheduled", "processing", "completed", "failed"]
    valid_statuses.each do |status|
      @image.status = status
      assert @image.valid?
    end
  end

  test "should have the thumbnail resized to 100x100 after image saved" do
    @image.save
    perform_enqueued_jobs
    @image.reload

    assert @image.thumbnail.attached?

    # Check that the original image is not in grayscale colorspace
    refute_match /Gray/, extract_colorspace(@image.original), "Original image should not be in grayscale colorspace"

    # Use MiniMagick to analyze the thumbnail's colorspace
    assert_match /Gray/, extract_colorspace(@image.thumbnail), "Image should be in grayscale colorspace"
  end

  private

  def extract_colorspace(image)
    image = MiniMagick::Image.read(image.download)
    image.colorspace
  end
end
