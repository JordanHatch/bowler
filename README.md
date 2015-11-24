# Bowler

Bowler manages Foreman process dependencies for large applications.

Bowler wraps the `foreman start` command with `bowl <processes>`, calculates the dependencies required, and automatically enables and disables the relevant processes in Foreman.

## Installation

Install from the command line:

```
gem install bowler
```

## Usage

Bowler reads from a `Pinfile` to find your process dependencies. Declaring dependencies is easy:

```ruby
process :app => [:database, :tiles]
process :api => :database
```

You can specify a global dependency too.

```ruby
dependency :database

process :app => :tiles
process :api
```

To run a process, use the `bowl` executable:

```
bowl app
```

You can run multiple processes at once:

```
bowl app api
```

## Releasing the gem

- Update the version in `lib/bowler/version.rb`
- `gem build bowler.gemspec`
- `gem push <artefact>.gem`

## License

MIT License
