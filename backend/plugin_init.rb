unless AppConfig.has_key? :cors_allow_origin
  # Origin to allow for CORS requests ('*' is any host)
  AppConfig[:cors_allow_origin] = '*'
end

unless AppConfig.has_key? :cors_endpoints
  # Comma-separated list of ArchivesSpace API endpoints you want accessible via Javascript
  AppConfig[:cors_endpoints] = [
    '/version',
    '/users/:id/login',
    '/repositories/:repo_id/archival_objects/:id',
    '/repositories/:repo_id/resources/:id',
    '/repositories/:repo_id/search',
  ]
end

CORS_ALLOW_ORIGIN = AppConfig[:cors_allow_origin]
CORS_ENDPOINTS = AppConfig[:cors_endpoints]

class CORSMiddleware

  def initialize(app)
    @app = app
    @patterns = build_patterns(CORS_ENDPOINTS)
  end

  def call(env)
    result = @app.call(env)

    # Add CORS headers to specific endpoints
    if env['REQUEST_METHOD'] == 'GET' &&
       result[0] == 200 &&
       @patterns.any? {|pattern| env['PATH_INFO'] =~ pattern}

      # Add CORS headers
      headers = result[1]
      headers["Access-Control-Allow-Origin"] = CORS_ALLOW_ORIGIN
      headers["Access-Control-Allow-Methods"] = "GET, POST"
      headers["Access-Control-Allow-Headers"] = "X-ArchivesSpace-Session"
    end

    result
  end

  private

  def build_patterns(uri_templates)
    uri_templates.map {|uri|
      regex = uri.gsub(/:[a-z_]+/, '[^/]+')
      Regexp.compile("\\A#{regex}$\\z")}
  end

end


# Support OPTIONS, which is necessary for certain browsers (for example Google Chrome)
CORS_ENDPOINTS.each do |uri|
  ArchivesSpaceService.options uri do
    response.headers["Access-Control-Allow-Origin"] = CORS_ALLOW_ORIGIN
    response.headers["Access-Control-Allow-Methods"] = "GET, POST"
    response.headers["Access-Control-Allow-Headers"] = "X-ArchivesSpace-Session"

    halt 200
  end
end

# Add Rack middleware to ArchivesSpace
ArchivesSpaceService.use(CORSMiddleware)
