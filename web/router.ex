defmodule Cuenta.Router do
  use Cuenta.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Cuenta do
    pipe_through :api

    scope "/auth" do
      post "/login", AuthController, :login
    end

    scope "/users" do
      get "/", UserController, :index
      get "/search", UserController, :search
      get "/:id", UserController, :show
      post "/image", UserController, :image
    end

    # 内部バックエンドシステム向けAPI
    scope "/internal" do
      scope "/users" do
        get "/list", UserController, :list
      end
    end
  end
end
