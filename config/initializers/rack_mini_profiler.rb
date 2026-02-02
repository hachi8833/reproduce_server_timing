if defined?(Rack::MiniProfiler)
  Rack::MiniProfiler.config.position = "bottom-left"
  Rack::MiniProfiler.config.enable_hotwire_turbo_drive_support = true
  # Rack::MiniProfiler.config.start_hidden = true # 必要に応じて有効化
end
