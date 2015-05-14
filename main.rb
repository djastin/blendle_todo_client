require './dependencies'
(Dir['./lib/*.rb'].sort).each do |file|
  load file
end

class Main < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :sprockets, Sprockets::Environment.new(root)
  set :digest_assets, false
  set :assets_precompile, [/^([a-zA-Z0-9_-]+\/)?([a-zA-Z0-9_-]+\/)?(?!_)([a-zA-Z0-9_-]+.\w+)$/]
  set :assets_prefix, %w(assets)
  set :assets_protocol, :http
  set :assets_paths, %w(fonts images javascripts stylesheets)
  set :assets_css_compressor, YUI::CssCompressor.new
  set :assets_js_compressor, YUI::JavaScriptCompressor.new
  set :assets_compress, $env == 'development' ? false : true

  register Sinatra::AssetPipeline

  Slim::Engine.options[:disable_escape] = true

  (Dir['./app/helpers/*.rb'].sort + Dir['./app/concerns/*.rb'].sort + Dir['./app/models/*.rb'].sort  + Dir['./app/controllers/*/*.rb'].sort).each do |file|
    require file
  end
end
