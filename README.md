# github-proxy-buildpack

A buildpack for enabling custom HTTP headers for GitHub pages.
[More details in this blog post](https://www.rzegocki.pl/blog/custom-http-headers-with-github-pages).

## Adding extra modules to nginx

This buildpack should have everything you need to set up a simple GitHub proxy.
However if you need to include some extra modules in nginx, you should:

* fork this repository
* clone the fork
* alter [scripts/build_nginx.sh](scripts/build_nginx.sh)
* run [build.sh](build.sh) to rebuild nginx binaries and put them in `bin/`
* push changes to your fork
* set your app buildpack to your fork URL

## Basic configuration

Buildpack can be configured via heroku environment vairables (`heroku config:set ...`).
Supported ENVs are:

* `ROUTE_TO_URL` - URL to your github pages, for example: https://ajgon.github.io/
* `HTTP_X_CUSTOM_HEADER_NAME` - will be translated to `add_header `X-Custom-Header-Name "<env value>";`
* `HIDE_GITHUB_HEADERS` - if set to `1` - it would configure nginx proxy to skip
  all response headers which can identify webpage as github hosted.

For more details how those parameters are handled, please refer to `config/nginx.conf.erb`.

## Advanced configuration

You can override `config/nginx.conf.erb` completely with your custom setup. To do this you need:

* create an empty repository with `git init`
* create a `config/nginx.conf.erb` file with your contents
* push those two files to your heroku application git repository

## CSP Nonce

Support for nonces is built in, and it's following the approach from
[this excellent article](https://scotthelme.co.uk/csp-nonce-support-in-nginx/).
From this buildpack perspective, you need to set a `CSP_NONCE_ID` variable which
will be an ID of your nonce replaced by nginx. In your CSP header you need to use
`$cspNonce` nginx variable. Example:

```bash
heroku config:set CSP_NONCE_ID="**CSP_NONCE**"
heroku config:set HTTP_CONTENT_SECURITY_POLICY="default-src 'self'; script-src 'self' 'nonce-$cspNonce';"
# Somewhere in HTML page
<script nonce="**CSP_NONCE**">alert('Hello World!!!');</script>
```

## Dummy app

Heroku won't work with raw buildpack only. It needs app files as well. Since all
the logic is handled by the buildpack, what you need to do is put some empty
file to the repo of the heroku app using this buildpack, and this should do the trick.

## Example

```bash
mkdir example && cd example
git init && touch .keep && git add -A && git commit -m 'initial commit'
heroku apps:create --buildpack https://github.com/ajgon/github-proxy-buildpack my-example-app
heroku config:set ROUTE_TO_URL=https://my-username.github.io/
heroku config:set HIDE_GITHUB_HEADERS=1 --app my-example-app
heroku config:set HTTP_EXPECT_CT="enforce, max-age=30" --app my-example-app
heroku config:set HTTP_X_FRAME_OPTIONS=deny --app my-example-app
heroku git:remote --app my-example-app
git push heroku master
curl -I https://my-example.app.herokuapp.com/
```
