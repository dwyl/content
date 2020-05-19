<div align="center">

# `content` (negotiation plug)

`content` adds Content Negotiation
to _any_ Phoenix App
so you can render HTML and JSON for the _same_ route.

[![Build Status](https://img.shields.io/travis/dwyl/content/master.svg?style=flat-square)](https://travis-ci.org/dwyl/content)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/content/master.svg?style=flat-square)](http://codecov.io/github/dwyl/content?branch=master)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/content/issues)
[![HitCount](http://hits.dwyl.io/dwyl/content.svg)](https://github.com/dwyl/content)

</div>

# Why? 🤷

We need to ~~reduce~~ _eliminate_ duplication of effort
while building our App+API so we can ship features _much faster_. <br />
Using this Plug we are able to build our App (Phoenix Web UI)
_and_ a REST (JSON) API in the _same_ codebase with _minimal_ effort.


# What? 💭

A Plug that can be added to _any_ Phoenix App
to render both `HTML` and `JSON` in the _same_ route/controller
so that we save dev time.
By ensuring that all Web UI
has a corresponding JSON response
we guarantee that _everyone_ has
access to their data in the most convenient way.

Returning an `HTML` view for people using the App in a Web Browser
and return `JSON` for people requesting the _same_ endpoint
from a script (_or a totally independent front-end_)
we guarantee that all features of our Web App
are automatically available in the API.

We have built several Apps and APIs in the past
and felt the pain of having to maintain
two separate codebases.
It's fine for
[mega corp](https://en.wikipedia.org/wiki/Evil_corporation)
with hundreds/thousands
of developers to maintain a _separate_ web UI
and API applications.
We are a small team
that has to do (_a lot_) more with fewer resources!

If you are new to content negotiation in _general_
or _how_ to implment it in Phoenix from scratch,
please see:
[dwyl/phoenix-content-negotiation-tutorial](https://github.com/dwyl/phoenix-content-negotiation-tutorial)

# Who? 👥

This project is "for us by us".
We are _using_ it in our product in production.
It serves our needs _exactly_.
As with _everything_ we do it's Open Source
so that anyone else can benefit.
If it looks useful to you, use it!
If you have any ideas/requests for features,
please open an
[issue](https://github.com/dwyl/content/issues).


# How? 💡

In _less_ than ***2 minutes*** and 3 easy steps
you will have content negotiation enabled
in your Phoenix App
and can get back to building your app!


<br />

## 1. Install ⬇️

Add `content` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:content, "~> 1.0.0"}
  ]
end
```

Then run `mix deps.get`.

<br />

## 2. Add the `Content` Plug to your `router.ex` 🔧

Open the `router.ex` file in your Phoenix App.
Locate the `pipeline :browser do` section.
And replace it:

Before:

```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_flash
  plug :protect_from_forgery
  plug :put_secure_browser_headers
end
```

_After_:

```elixir
pipeline :any do
  plug :accepts, ["html", "json"]
  plug Content, %{html_plugs: [
    &fetch_session/2,
    &fetch_flash/2,
    &protect_from_forgery/2,
    &put_secure_browser_headers/2
  ]}
end
```

Pass the plugs you want to run for `html`
as `html_plugs` (_in the order you want to execute them_).

> **Note**: the `&` and `/2` additions to the names of plugs
are the `Elixir` way of passing functions by reference. <br />
The `&` means "capture" and the `/2` is the
[arity](https://en.wikipedia.org/wiki/Arity)
of the function we are passing. <br />
We would _obviously_ prefer if functions were just variables
like they are in some other programming languages,
but this _works_. <br />
See:
https://dockyard.com/blog/2016/08/05/understand-capture-operator-in-elixir <br />
and:
https://culttt.com/2016/05/09/functions-first-class-citizens-elixir

Example:
[`router.ex#L6-L11`](https://github.com/dwyl/phoenix-content-negotiation-tutorial/blob/22501adbbe8159d28b37f39d912519f39346d1bd/lib/app_web/router.ex#L6-L11)

<br />

## 3. Use the `Content.reply/5` in your Controller 📣

In your controller(s),
add the following line to invoke `Content.reply/5` <br />
which will render `HTML` or `JSON`
depending on the `accept` header:

```elixir
Content.reply(conn, &render/3, "index.html", &json/2, data)
```

> Again, those `&` and `/3` are just to let `Elixir`
know which `render` and `json` function to use.

The `Content.reply/5` accepts the following 5 argument:
1. `conn` - the `Plug.Conn` where we get the `req_headers` from.
2. `render/3` - the `Phoenix.Controller.render/3` function,
  or your own implementation of a render function that
  takes `conn`, `template` and `data` as it's 3 params.
3. `template` - the `.html` template to be rendered
  if the `accept` header matches `"html"`; e.g: `"index.html"`
4. `json/2` - the `Phoenix.Controller.json/2` function
  that renders `json` data.
  Or your own implementation that accepts the two params:
  `conn` and `data` corresponding to the `Plug.Conn`
  and the `json` data you want to return.
5. `data` - the data we want to render as `HTML` or `JSON`.


Example:
[`quotes_controller.ex#L13`](https://github.com/dwyl/phoenix-content-negotiation-tutorial/blob/22501adbbe8159d28b37f39d912519f39346d1bd/lib/app_web/controllers/quotes_controller.ex#L13)


If you need more control over the rendering of `HTML` or `JSON`,
you can always write custom logic such as:

```elixir
if Content.get_accept_header(conn) =~ "json" do
  data = transform_data(q)
  json(conn, data)
else
  render(conn, "index.html", data: q)
end
```

If you get stuck at at any point,
please reference our tutorial:
[/dwyl/phoenix-content-negotiation-tutorial](https://github.com/dwyl/phoenix-content-negotiation-tutorial#part-2)

<br />

## Docs? 📖

Documentation can be found at
[https://hexdocs.pm/content](https://hexdocs.pm/content/Content.html).

<br />

## Love it? Want _More_? ⭐

If you are _using_ this package in your project,
please ⭐ the repo on GitHub. <br />
If you have any questions/requests,
please open an [issue](https://github.com/dwyl/content/issues).
