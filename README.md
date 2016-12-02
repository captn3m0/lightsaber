# lightsaber [![Build Status](https://travis-ci.org/captn3m0/lightsaber.svg?branch=master)](https://travis-ci.org/captn3m0/lightsaber)

Lightsaber is a simple DNS Redirect service. It offers 301/302 redirects for
your domains. The configuration is stored in TXT records.

## Usage

To add a DNS record, point your domain via a CNAME entry to `lightsaber.captnemo.in`.

Then create a TXT record for the `_redirect` subdomain and use the following as the value:

    v=lr1;https://google.com

where https://google.com is the redirect URL.

## License

Released under the [MIT License](http://nemo.mit-license.org/).