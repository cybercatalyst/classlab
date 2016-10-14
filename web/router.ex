defmodule Classlab.Router do
  use Classlab.Web, :router

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Classlab.AssignUserPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Classlab do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/session/:id", SessionController, :show
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete


    resources "/events", EventController do
      resources "/invitations", InvitationController, except: [:edit, :update]
      resources "/materials", MaterialController
    end
    resources "/memberships", MembershipController, expect: [:show, :edit, :update]
  end
end
