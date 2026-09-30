# SmtpURL setup

This gem allows you to configure your smtp settings for mail and 
action mailer using a url.  The intention is to keep those settings 
out of your code and allow easily setting them with an environment 
variable.

## Installation

Add to your `Gemfile`:

    gem "smtp_url"

## Usage

If you are in Rails it will automatically setup your email settings if 
you have the SMTP_URL enviroment variable set.

Use a SMTP_URL that looks like so:

    smtp://<user>:<password>@<hostname>:<port>/?<options>

Options is a query string of key value pairs and is used for setting
both the domain and authentication options. For example:

    smtp://user:secret@mailserver:587/?domain=test.com&authentication=digest

Only `hostname`, is required. Everything else is optional. It will
default to port 25 if it is not specified.

Use the `smtps` scheme for a server which expects implicit TLS (the
connection is encrypted from the start, RFC 8314): it defaults to port
465, and sets the `tls` option of mail and action mailer.

    smtps://user:secret@mailserver/?domain=test.com

With the `smtp` scheme, mail and action mailer upgrade the connection with
STARTTLS when the server offers it (usually on port 587).

Percent-encode the special characters of the user and the password
(RFC 3986), for example `@` as `%40` and `/` as `%2F`: they are decoded
before being passed to mail or action mailer.

Set SMTP_URL in your server setup like so:

    export SMTP_URL=smtp://user:secret@mailserver:587/?domain=test.com

## Development

Can be very useful in development when paired with something like
[Mailcatcher](http://mailcatcher.me/):

    export SMTP_URL=smtp://localhost:1025


## License

SmtpURL is MIT Licensed

Copyright (C) 2012 by Daniel Farrell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

