# frozen_string_literal: true

# Lookbook configuration
# https://lookbook.build/guide/configuration

if defined?(Lookbook)
  Lookbook.configure do |config|
    # Preview paths
    config.preview_paths = ["#{Rails.root}/test/components/previews"]

    # Preview layout
    config.preview_layout = "lookbook"

    # Project name
    config.project_name = "enno.jp Components"

    # UI theme
    config.ui_theme = "blue"

    # Enable experimental features
    config.experimental_features = true
  end
end
