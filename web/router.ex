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

    scope "/token" do
      post "/", TokenController, :create
      post "/refresh", TokenController, :refresh
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

      get "/search", UserListController, :search
    end

    # 内部バックエンドシステム向けAPI
    scope "/internal" do
      scope "/users" do
        get "/list", UserListController, :list
        get "/:id", UserController, :show
      end
    end
  end
end
