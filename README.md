# as-cors

An ArchivesSpace plugin that adds Access-Control-Allow headers to HTTP requests using Rack middleware. Huge thanks to Mark Triggs for the assist on this code.

## Requirements

*   ArchivesSpace instance

## Installation

1.  Download or clone this repository into the ArchivesSpace `plugins/` directory..

        git clone git@github.com:RockefellerArchiveCenter/as-cors.git

2.  Edit `config/config.rb` to include the plugin:

        AppConfig[:plugins] = ['local',  'lcnaf', 'aspace-public-formats', 'as-cors']

3.  Restart ArchivesSpace.

## Usage

Routes on which CORS headers are available can be edited by defining the `AppConfig[:cors_endpoints]` variable.
For production use, `AppConfig[:cors_allow_origin]` should specify a host name, rather than the permissive wildcard `*`.

Edit `config/config.rb` to include the below default configuration.

The default configuration is:

```ruby
AppConfig[:cors_allow_origin] = '*'
AppConfig[:cors_endpoints] = [
  '/version',
  '/users/:id/login',
  '/repositories/:repo_id/archival_objects/:id',
  '/repositories/:repo_id/resources/:id',
  '/repositories/:repo_id/search',
]
```

This gives you sufficient permissions to log in, search, and get information about
a specific resource or archival object.

## Contributing

Pull requests accepted!

## Authors

*   Mark Triggs
*   Hillel Arnold

## License

This code is released under the MIT License. See `LICENSE.md` for more information.
