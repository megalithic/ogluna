defmodule OglunaWeb.PageLive do
  use OglunaWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [og_image: nil, og_url: "", is_valid: false]}
  end

  @impl true
  def handle_event("view", %{"og_url" => url} = _params, socket)
      when not is_nil(url) and url !== "" do
    socket =
      socket
      |> assign(og_url: url)
      |> fetch_og_image()

    {:noreply, socket}
  end

  @impl true
  def handle_event("view", %{"og_url" => url} = _params, socket) do
    Logger.error("Invalid url (#{inspect(url)}); try another.")

    {:noreply, assign(socket, is_valid: is_valid?(url))}
  end

  @impl true
  def handle_event("validate", %{"value" => url} = _params, socket) do
    {:noreply, assign(socket, is_valid: is_valid?(url))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <form id="og_viewer" phx-submit="view" class="flex flex-col justify-center items-center">
      <input
        type="text"
        id="og_url"
        name="og_url"
        required
        autofocus
        phx-focus={JS.dispatch("js:exec", to: "#og_url", detail: %{call: "select", args: []})}
        phx-blur="validate"
        value={@og_url}
        class="w-[100%] rounded"
        placeholder="insert url for previewing; ex: https://megalithic.io"
      />
      <a :if={not is_nil(@og_image)} rel="noopener noreferrer" target="_blank" href={@og_url}>
        <img
          src={@og_image}
          class={"w-[100%] mx-auto max-w-2xl my-10 transition-all hover:translate-y-1 hover:border-gray-600 invalid:border-brand #{if not is_nil(@og_image), do: "border-black border-8 shadow-md rounded block"}"}
        />
      </a>
    </form>
    """
  end

  def is_valid?(url) when url === "", do: true

  def is_valid?(url) when url !== "" do
    Regex.match?(
      ~r/(https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&\/\/=]*))/,
      url
    )
  end

  def fetch_og_image(%{assigns: %{og_url: url}} = socket)
      when not is_nil(url) and url !== "" do
    with true <- is_valid?(url),
         {:ok, %Req.Response{body: body}} <- Req.get(url, max_retries: 0),
         {:ok, html} = Floki.parse_document(body) do
      og_image =
        html
        |> Floki.attribute("meta[property='og:image']", "content")

      socket =
        socket
        |> assign(og_image: og_image)
        |> clear_flash()
    else
      false ->
        Logger.error("Invalid url (#{inspect(url)})")

        socket
        |> put_flash(:error, "Invalid URL")
        |> assign(og_image: nil)

      _ ->
        Logger.error("Something happened when trying to parse the given url (#{inspect(url)})")

        socket
        |> put_flash(:error, "There was a problem parsing that url!")
        |> assign(og_image: nil)
    end
  end

  def fetch_og_image(%{assigns: %{og_url: _}} = socket) do
    assign(socket, og_image: nil)
  end
end
