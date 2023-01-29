# og|viewer

## 🚀 Setup

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
- Visit the the og|viewer in your browser of choice at <http://localhost:4003>

## 🧑‍💻 Usage

Using og|viewer™ couldn't be any easier!

Upon visiting the app, assume you aren't using something invasive (and very useful), like SurfingKeys (or other similar browser extensions that might forcefully hijack inputs), the url input will be focused.

You can then enter a URL, such as `https://megalithic.io` to use as a test for grabbing the `og:image` meta tag's content for that website. To take it further, feel free to try invalid URLs, we have basic URL RegEx matching to validate that, at the very least, it is a valid URI.

Once entering the URL, hit enter to submit the form. In real-time (asynchronously), a request to the URL will be made to gather the image; if it fails, you'll receive an error.

I'm using the default-bundled topbar node module to handle the "in-progress" interactions for the user.

## ✨ The Approach™

Using Phoenix LiveView, I can to take advantage of it's websocket connection to perform real-time updates of the DOM from the server, in response to client-side events.

I added a handler to validate that the URL given is valid; if it is, we use `Req` to get the html document, and then `Floki` to parse the html we received.

### 🐉 Trade-offs/Additional things

I could have used the `type="url"` input element, instead of a standard `text` element, however, I wanted to show the power of LiveView's form bindings for handling the validations.

In addition, I've not included any tests, nor additional error handling for more error states that might occur with so many moving parts (http requests + html parsing).

Before sending to production; I'd certainly include tests to handle a variety of inputs, and their expected behaviours.
