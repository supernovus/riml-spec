# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.12.0] - 2022-03-02
### Added
- This changelog.
- `.methodPrefix` option.
- `.methodSuffix` option.
- `.methodCamelCase` option.
- `.controllerPrefix` option.
- `.controllerSuffix` option.
- `.controllerCamelCase` option.
- The ability to specify `string` type `!method` tags for simple API routes.
### Changed
- Moved to semantic versioning.
- Overhauled the *Route Definitions* section, and made specific sub-sections with nicer examples for each of the different kinds of magic properties.
- Clarified that route methods derived from HTTP Method properties should be case-normalized.
### Removed
- The *Development Notes* and *Version Notes* sections.

## [1.11.0] - 2021-02-04
### Added
- A new table listing the various implementations of RIML in different programming languages.
### Changed
- Rewrote the *Summary* section to be clearer and simpler.
- Changed `authType` and `redirect` descriptions to be less implementation specific.
- Changed the definition of how `!include` and `!includePath` determine if a path is relative to the working directory. The previous definition was far too limiting.
### Removed
- The `userAccess`, `ipAccess`, and `token` predefined values from the `authType` property. Implementations are free to use whatever values they want, no predefined types are required.
### Fixed
- Typos.

## [1.10.0] -- 2017-04-12
### Changed
- Changed the *placeholder* path delimiter from `/` to `|` since the former is used in URLs.
- Updated the examples a bit to make a few variable naming choices better.

## [1.9.0] -- 2017-04-12
### Added
- `Traits` can now have *placeholder values* which allow them to act more like templates.
### Removed
- The entire concept of `Templates` has been removed from the specification. They've been made obsolete by the additions to the `Traits`.

## [1.8.0] -- 2017-04-10
### Added
- This was first version of the RIML specification I imported into git. I have no previous documentation that I can find, so for all intents, this is the first release of RIML.


[Unreleased]: https://github.com/supernovus/simpledom/compare/v1.12.0...HEAD
[1.12.0]: https://github.com/supernovus/simpledom/compare/v1.11.0...v1.12.0
[1.11.0]: https://github.com/supernovus/simpledom/compare/v1.10.0...v1.11.2
[1.10.0]: https://github.com/supernovus/simpledom/compare/v1.9.0...v1.10.0
[1.9.0]: https://github.com/supernovus/simpledom/compare/v1.8.0...v1.9.0
[1.8.0]: https://github.com/supernovus/simpledom/releases/tag/v1.8.0

