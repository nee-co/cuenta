defmodule Cuenta.Router do
  use Cuenta.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Cuenta.Plug.RequireLogin
  end

  scope "/", Cuenta do
    pipe_through :api

    scope "/auth" do
      post "/login", AuthController, :login
    end

    scope "/user" do
      pipe_through :authenticated

      get "/", UserController, :index
      post "/image", UserController, :image
      patch "/password", UserController, :update_password
      patch "/note", UserController, :update_note
    end

    scope "/users" do
      pipe_through :authenticated

      get "/search", UserController, :search
      get "/:id", UserController, :show
    end

    # 内部バックエンドシステム向けAPI
    scope "/internal" do
      scope "/users" do
        get "/list", UserController, :list
        get "/:id", UserController, :show
      end
    end
  end
end
