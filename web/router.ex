defmodule Classlab.Router do
  use Classlab.Web, :router

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

  scope "/", Classlab do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/events", EventController
    resources "/memberships", MembershipController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Classlab do
  #   pipe_through :api
  # end
end
