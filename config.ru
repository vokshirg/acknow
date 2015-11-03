use Rack::Static,
  :urls => Dir.glob("#{root}/*").map { |fn| fn.gsub(/#{root}/, '')},
  :root => root,
  :index => 'index.html',
  :header_rules => [[:all, {'Cache-Control' => 'public, max-age=3600'}]]

headers = {'Content-Type' => 'text/html', 'Content-Length' => '9'}
run lambda { |env| [404, headers, ['Not Found']] }

require 'vienna'
run Vienna

static_page_mappings = {
  '/permissions.html' => 'permissions.html'
  '/pages-edit-profile.html'   => '/pages-edit-profile.html',
}

static_page_mappings.each do |req, file|
  map req do 
    run Proc.new { |env|
      [
        200, 
        {
          'Content-Type'  => 'text/html', 
          'Cache-Control' => 'public, max-age=6400',
        },
        File.open(file, File::RDONLY)
      ]
    }
  end
end
