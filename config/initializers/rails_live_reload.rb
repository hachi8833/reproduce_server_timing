# frozen_string_literal: true

# rails_live_reload の設定
# app/views/components/ 以下の .rb ファイル（簡易コンポーネント）も監視対象に追加
if defined?(RailsLiveReload) && Rails.env.development?
  RailsLiveReload.configure do |config|
    config.enabled = true
    
    # デフォルトの監視パスに加えて、コンポーネントの .rb ファイルも監視
    config.watch %r{app/views/.+\.erb$}, reload: :always
    config.watch %r{app/components/.+\.rb$}, reload: :always
    config.watch %r{app/components/.+\.html\.erb$}, reload: :always
    config.watch %r{app/components/.+\.js$}, reload: :always
    config.watch %r{app/components/.+\.css$}, reload: :always
    config.watch %r{app/javascript/.+\.js$}, reload: :always
    config.watch %r{app/assets/builds/.+\.css$}, reload: :always
    config.watch %r{config/locales/.+\.yml$}, reload: :always
    config.watch %r{app/assets/tailwind/application.css$}, reload: :always
  end
end
