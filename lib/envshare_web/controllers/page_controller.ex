defmodule EnvshareWeb.PageController do
  use EnvshareWeb, :controller

  def index(conn, _params) do
    projects = ProjectWrapper.get_projects
    render conn, "index.html", projects: projects
  end

  def add(conn, _params) do
    render conn, :add
  end

  def create(conn, params) do
    name = params["project"]["name"]
    description = params["project"]["description"]
    commands =
      params["project"]["commands"]
      |> String.split("\r\n")

    Blockchain.insert(%{name: name,
      description: description, commands: commands})

    redirect conn, to: "/"
  end

  def start(conn, %{"hash" => hash}) do
    hash
    |> Blockchain.find_by_hash
    |> Map.get(:commands)
    |> Docker.make_dockerfile

    redirect conn, to: "/"
  end
end
