class Image < ApplicationRecord
  has_one_attached :original
  has_one_attached :thumbnail

  enum :status, [:processing, :completed, :failed].map(&:to_s).index_by(&:itself), default: :scheduled

  before_create -> { self.status = :processing }
  after_create_commit :process_image

  private

  def process_image
    ImageResizerJob.perform_later(id)
  end
end
