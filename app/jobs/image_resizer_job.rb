class ImageResizerJob < ApplicationJob
  queue_as :default

  def perform(image_id)
    sleep 3 # simulate a long running job

    image = Image.find(image_id)
    original = image.original

    # Use MiniMagick to resize
    resized = MiniMagick::Image.read(original.download)
    resized.resize "100x100"

    image.thumbnail.attach(
      io: StringIO.new(resized.to_blob),
      filename: "thumb.jpg",
      content_type: "image/jpeg"
    )

    image.status = :completed
    image.save!

    broadcast_image_update(image)
  end

  private

  def broadcast_image_update(image)
    Turbo::StreamsChannel.broadcast_replace_to(
      image,
      target: ApplicationController.helpers.dom_id(image, :image),
      partial: 'images/image',
      locals: { image: image }
    )
  end
end
