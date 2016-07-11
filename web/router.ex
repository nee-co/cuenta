defmodule Cuenta.Router do
  use Cuenta.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Cuenta do
    pipe_through :api

    scope "/users" do
      get "/list", UserController, :list
      get "/search", UserController, :search
    end
  end
end
