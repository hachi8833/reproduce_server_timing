# README

To run the app (Rails 8.1.2), install [mise](https://github.com/jdx/mise) first to setup env.

The app uses ViewComponent, Lookbook, Tailwind and some other gems, but the setup is minimum.

## Setup

Requirement: Ruby 4.0.1

1. `gh repo clone hachi8833/reproduce_server_timing`

2. Move to the directory and `mise trust` to activate env, and `bundle install` to setup.

3. make sure the current branch is `main` and run `bin/dev`

## Reproduce

On the `main` branch with ZJIT: 

1. Open `http://localhost:3000/lookbook` and just reload it some times

You'd receive `NoMethod error: undefined method '<<' for nil`

2. Open `http://localhost:3000/` from browser and reload the page several times (around 20 times)

You'd receive `Puma caught this error: undefined method 'group_by' for nil (NoMethodError)`

## Compare with YJIT 

Run `RUBY_YJIT_ENABLE=1 RUBY_ZJIT_ENABLE=0 bin/dev` and repeat the steps above: should work fine and nothing happens.

## Compare with patche version on ZJIT

Run `git sw to_suppress_errors`, run `bin/dev`, and repeat the steps above: should work fine and nothing happens.

The diffs are:

- config/initializers/lookbook_patch.rb
- config/initializers/puma_patch.rb
- onfig/environments/developments.rb: changed `config.server_timing` (default: `true`) to `false`