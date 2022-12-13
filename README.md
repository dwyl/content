<div align="center">

# `content` (negotiation plug)

`content` adds Content Negotiation
to _any_ Phoenix App
so you can render HTML and JSON for the _same_ route.

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/dwyl/hits/Elixir%20CI?label=build&style=flat-square)](https://github.com/dwyl/hits/actions/workflows/ci.yml)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/content/master.svg?style=flat-square)](https://codecov.io/github/dwyl/content?branch=master)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/content/issues)
[![HitCount](https://hits.dwyl.com/dwyl/content.svg?style=flat-square&show=unique)](https://hits.dwyl.com/dwyl/content)

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
and returning `JSON` for people requesting the _same_ endpoint
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
or _how_ to implement it in Phoenix from scratch,
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
    {:content, "~> 1.3.0"}
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

## 4. Wildcard Routing

If you want to allow people to view the `JSON` representation
of _any_ route in your application in a Web Browser
without having to _manually_ set the Accept header
to `application/json`, there's a handy function for you:
`wildcard_redirect/3`

To use it, simply create a
[wildcard](https://stackoverflow.com/questions/32189311/catch-all-wildcard-route)
route in your `router.ex` file.
e.g:

```elixir
get "/*wildcard", QuotesController, :redirect
```

And create the corresponding controller to handle this request:

```elixir
def redirect(conn, params) do
  Content.wildcard_redirect(conn, params, AppWeb.Router)
end
```

The 3 arguments for `wildcard_redirect/3` are:
+ `conn` - a `Plug.Conn` the usual for a Phoenix controller.
+ `params` - the params for the request, again standard for a Phoenix controller.
+ `router` - the router module for your Phoenix App e.g: `MyApp.Router`

For an example of this in action, see:
[`README.md#10-view-json-in-a-web-browser`](https://github.com/dwyl/phoenix-content-negotiation-tutorial/blob/8f34f205427d6cb6eeec79d111531235e9e122fc/README.md#10-view-json-in-a-web-browser)



### Error Handling

If a route does not exist in your app you will see an error.
To handle this error you can use a
[Try Catch](https://elixir-lang.org/getting-started/try-catch-and-rescue.html#errors),
e.g:

```elixir
try do
  Content.wildcard_redirect(conn, params, AppWeb.Router)
rescue
  # below this line will only render if redirect fails:
  UndefinedFunctionError ->
    conn
    |> Plug.Conn.send_resp(404, "not found")
    |> Plug.Conn.halt()
end
```

Alternatively, for a more robust approach to
Error handling, see `action_fallback/1`:
https://hexdocs.pm/phoenix/Phoenix.Controller.html#action_fallback/1

<hr />

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
