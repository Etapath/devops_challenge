require "test_helper"

class ImageDesaturationJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  setup do
    @image = Image.new(name: "test_image.jpg")
    @image.original.attach(
      io: File.open(Rails.root.join("test/fixtures/files/sample_picture.jpg")),
      filename: "test_image.jpg",
      content_type: "image/jpeg"
    )
    @image.save
  end

  test "should process image and update status" do
    perform_enqueued_jobs do
      ImageDesaturationJob.perform_later(@image.id)
    end

    @image.reload
    assert_equal "completed", @image.status
    assert @image.thumbnail.attached?
  end

  test "should convert image to grayscale" do
    perform_enqueued_jobs do
      ImageDesaturationJob.perform_later(@image.id)
    end

    @image.reload

    # Check thumbnail is in grayscale colorspace
    thumbnail = MiniMagick::Image.read(@image.thumbnail.download)
    assert_match /Gray/, thumbnail.colorspace
  end
end
