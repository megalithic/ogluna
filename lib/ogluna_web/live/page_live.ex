defmodule OglunaWeb.PageLive do
  use OglunaWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [og_image: nil, og_url: ""]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, assign_params(socket, params)}
  end

  @impl true
  def handle_event("view", %{"og_url" => url} = _params, socket)
      when not is_nil(url) and url !== "" do
    {:noreply, push_patch(socket, to: ~p"/?#{%{url: url}}")}
  end

  @impl true
  def handle_event("view", %{"og_url" => url} = _params, socket) do
    Logger.error("Invalid url (#{inspect(url)}); try another.")

    {:noreply, push_patch(socket, to: ~p"/?#{%{url: ""}}")}
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
        phx-focus={JS.dispatch("js:exec", to: "#og_url", detail: %{call: "select", args: []})}
        value={@og_url}
        class="w-[100%] rounded"
        placeholder="insert url for previewing; ex: https://megalithic.io"
      />
      <a :if={not is_nil(@og_image)} rel="noopener noreferrer" target="_blank" href={@og_url}>
        <img
          src={@og_image}
          class={"w-[100%] mx-auto max-w-2xl my-10 transition-all hover:translate-y-1 hover:border-gray-900 invalid:border-brand #{if not is_nil(@og_image), do: "border-black border-8 shadow-md rounded block"}"}
        />
      </a>
    </form>
    """
  end

  defp assign_params(socket, params) do
    url = params["url"] || ""

    socket =
      socket
      |> assign(og_url: url)

    socket =
      if connected?(socket) do
        socket
        |> fetch_og_image()
      else
        socket
      end

    socket
  end

  def fetch_og_image(%{assigns: %{og_url: url}} = socket)
      when not is_nil(url) and url !== "" do
    with {:ok, %Req.Response{body: body}} <- Req.get(url, max_retries: 0),
         {:ok, html} = Floki.parse_document(body) do
      og_image =
        html
        |> Floki.attribute("meta[property='og:image']", "content")

      assign(socket, og_image: og_image)
    else
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
