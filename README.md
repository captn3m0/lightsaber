# lightsaber [![Build Status](https://travis-ci.org/captn3m0/lightsaber.svg?branch=master)](https://travis-ci.org/captn3m0/lightsaber)

Lightsaber is a simple DNS Redirect service. It offers 301/302 redirects for
your domains. The configuration is kept public on this github repository itself.

## Usage

To add a DNS record, point your domain via a CNAME entry to `lightsaber.captnemo.in`.

You can also have fallthrough domain redirects
(thanks to @vivekprakash for the suggestion), by making the redirect a hash
with a `root` key set to the url prefix.

```yaml
# This is a fallthrough redirect
# so t.co/ev would redirect to twitter.com/ev
t.co:
  root: https://twitter.com
# All goo.gl routes will forward to google.com, and not use fallthrough
goo.gl: https://google.com
```

Next, you will need to do the following:

1. Fork this repo
2. Edit the redirects.yml file and add your redirect in the relevant section
3. File a Pull Request with your edit

Once the Pull Request is approved, the redirect will automatically be deployed
via Travis.

If you do not wish to make your domain redirects public, or give away your domain
names, you can self host this as well.

## License

Released under the [MIT License](http://nemo.mit-license.org/).