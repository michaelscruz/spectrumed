defmodule SpectrumedWeb.PageController do
  use SpectrumedWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
