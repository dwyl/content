<div align="center">

# `content` (negotiation plug)

`content` is a `Plug` that adds Content Negotiation
to _any_ Elixir/Phoenix App
so you can render HTML and JSON for the _same_ route.

[![Build Status](https://img.shields.io/travis/dwyl/content/master.svg?style=flat-square)](https://travis-ci.org/dwyl/content)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/content/master.svg?style=flat-square)](http://codecov.io/github/dwyl/content?branch=master)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/content/issues)
<!-- [![HitCount](http://hits.dwyl.io/dwyl/content.svg)](https://github.com/dwyl/content) -->

</div>

# Why? 🤷

We need to ~~reduce~~ _eliminate_ duplication of effort
while building our App+API so we can ship features _much faster_. <br />
Using this Plug we are able to build our App (Phoenix Web UI)
_and_ a REST (JSON) API in the _same_ codebase with _minimal_ effort.


# What? 💭

A Plug that can be added to _any_ Phoenix App
to render both `HTML` and `JSON` in the _same_ route/controller
so that we save dev time and ship faster.
By ensuring that all Web UI
has a corresponding JSON response
we guarantee that _everyone_ has
access to their data in the most convenient way.

By returning an `HTML` view for people using the App in a Web Browser
and return `JSON` for people requesting the _same_ endpoint
from a script (_or a totally independent front-end_)
we guarantee that all features of our Web App
are automatically available in the API.

We have built several Apps and APIs in the past
and felt the pain of having to maintain
two separate codebases.
It's fine for mega corp with hundreds/thousands
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


# How?

In _less_ than 5 minutes you will have
content negotiation enabled in your Phoenix App
and can get back to building your app.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `content` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:content, "~> 0.1.0"}
  ]
end
```

Documentation can be found at
[https://hexdocs.pm/content](https://hexdocs.pm/content).
