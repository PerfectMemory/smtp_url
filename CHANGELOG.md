# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

- `smtps://` urls, for the SMTP servers which expect implicit TLS (RFC 8314): they
  default to port 465 and set the `tls` option of mail and action mailer

### Fixed

- the user and the password are percent-decoded (RFC 3986) before being passed to mail
  and action mailer: a password with special characters (such as `@` or `/`) failed to
  authenticate. A `+` stays a plus sign.

### Changed

- **BREAKING**: Ruby >= 3.2 is required
- development: bundle update (Rails 8.1, rspec 3), specs use the `expect` syntax only

## 0.3.0 (2015-01-16)

### Fixed

- the railtie configures action mailer in an initializer
- the gemspec only requires `smtp_url/version`: evaluating it no longer loads activesupport

## 0.2.0 (2012-12-27)

### Changed

- the railtie is only loaded when Rails is defined

## 0.1.0 (2012-06-14)

### Added

- first release: parse a SMTP url into mail and action mailer settings, and a railtie
  which configures action mailer from the `SMTP_URL` environment variable
