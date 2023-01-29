# *og*viewer

## 🚀 Setup

_Please note: this app requires [Elixir](https://elixir-lang.org/) 1.14+ and [Erlang](https://elixir-lang.org/install.html#installing-erlang) 0.25+ to be installed on your system._

To get right to using it, without local setup, visit: <https://ogviewer.fly.dev/>

To set up locally:

- Clone this repo as you normally would
- Run `mix setup` to install and setup dependencies
- Start the Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
- Visit the the **og**viewer in your browser of choice at <http://localhost:4003>

## 🧑‍💻 Usage

Using **og**viewer™ couldn't be any easier!

Upon visiting the app, assuming you aren't using something invasive (and very useful) -- like SurfingKeys (or other similar browser extensions that might forcefully hijack inputs) -- the url input will be focused.

You can then enter a URL, such as `https://megalithic.io` to use as a test for grabbing the `og:image` meta tag's content for that website. To take it further, feel free to try invalid URLs, we have basic URL RegEx matching to validate that, at the very least, it is a valid URI.

Once entering the URL, hit enter to submit the form. In real-time (asynchronously), a request to the URL will be made to gather the image; if it fails, you'll receive an error.

I'm using the default-bundled [`topbar`](https://github.com/buunguyen/topbar) node module to handle the "in-progress" interactions for the user.

## ✨ The Approach™

Using [`Phoenix LiveView`](https://hexdocs.pm/phoenix/Phoenix.html), I can to take advantage of it's websocket connection to perform real-time updates of the DOM from the server, in response to client-side events.

I added a handler to validate that the URL given is valid; if it is, we use [`Req`](https://hexdocs.pm/req/Req.html) to get the html document, and then [`Floki`](https://hexdocs.pm/floki/readme.html) to parse the html we received.

_NOTE:_ the take home instructions mentioned persistence for this, however, there is no need; processing happens without any storage.

### 🐉 Trade-offs/Additional Thoughts

I could have used the `type="url"` input element instead of a standard `text` element, however, I wanted to showcase the power of Phoenix LiveView's form bindings for handling the validations. One could have also offloaded this responsibility to a Phoenix hook, though you'd also need access to this validation check in the live view.

In addition, I've not included any tests, nor additional error handling for other potential error states.

Before sending to production; I'd certainly include tests to handle a variety of inputs, and their expected behaviors (which would reveal those additional possible error states).
