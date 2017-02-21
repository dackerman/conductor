# Conductor
Utility for automating the creation of TestRail projects

Conducter facilitates the creation of project definition files and the subsequent generation of TestRail projects.

## Usage
  After cloning the repo, you may have to do `gem install bundler` then `bundle` to get all the correct dependencies set up

  * `rake conductor:set_auth` to create your authentication configuration
  * `rake conductor:config` to create a project definition file
  * `rake conductor:generate` to create a TestRail project from a project definition file
  * `rake conductor:add_suite` to copy a base suite to an existing TestRail project
  * `rake -T` to see other options
