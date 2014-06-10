class Asset < ActiveRecord::Base
  # SCOPES
  scope :cover, -> { where(cover: true) }

  # ASSOCIATIONS
  belongs_to :assetable, polymorphic: true

  # MACROS
  mount_uploader :asset, AssetUploader
  include Rails.application.routes.url_helpers

  # INSTANCE METHODS
  def cover?
    cover == true
  end
end
