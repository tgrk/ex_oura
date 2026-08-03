defmodule ExOura.Test.Support.ReqFinchAdapter do
  @moduledoc false

  def run(request) do
    finch_request =
      Finch.build(
        request.method,
        request.url,
        Req.Fields.get_list(request.headers),
        request.body
      )

    case Finch.request(finch_request, ExOuraMockClient) do
      {:ok, response} -> {request, Req.Response.new(response)}
      {:error, exception} -> {request, exception}
    end
  end
end
