###
# Markdown
###
set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true, :with_toc_data => true
set :markdown_engine, :redcarpet


###
# Compass
###
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

# Add-on dynamic pages
data.tools.each do |addon_data|
  proxy "/addons/#{addon_data[:page]}.html", "/addons/addon.html", ignore: true, locals: addon_data
end

# Hook ready, because the sitemap has definitely been built at this point
ready do
  data.tools.each do |tool_data|
    resource = sitemap.find_resource_by_path "/addons/#{tool_data[:page]}.html"
    resource.add_metadata page: {
      title: "#{tool_data['title']} add-on | Dradis Framework",
      description: tool_data['description']
    }
  end
end

###
# Helpers
###

require 'lib/helpers/seo'
helpers Helpers::Seo

# Asset pipeline
# activate :sprockets

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# Methods defined in the helpers block are available in templates
helpers do
  def gzip_css_on_build(key)
    o = stylesheet_link_tag(key)
    # o.sub!(".css", ".css.gz") if build?
    o
  end

  def gzip_js_on_build(key)
    o = javascript_include_tag(key)
    # o.sub!(".js", ".js.gz") if build?
    o
  end
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'


# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets
  # set :relative_links, true
  # activate :directory_indexes

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  # Create favicons from source/_favicon_template.png
  activate :favicon_maker, icons: {
    "_favicon_template.png" => [
    { icon: "apple-touch-icon-152x152-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPad with iOS7.
    { icon: "apple-touch-icon-114x114-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPhone with iOS6 or prior.
    { icon: "apple-touch-icon-72x72-precomposed.png" },               # Same as apple-touch-icon-57x57.png, for non-retina iPad with iOS6 or prior.
      { icon: "favicon.png", size: "16x16" },                           # The classic favicon, displayed in the tabs.
      { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" },         # Used by IE, and also by some other browsers if we are not careful.
    ]
  }
end

# Deploy over rsync
activate :deploy do |deploy|
  deploy.method = :rsync
  deploy.host = 'viper'
  deploy.port = 22121
  deploy.path = '/var/www/dradisframework/www'
end
