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
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/session/:id", SessionController, :show

    scope "/account", as: :account do
      delete "/logout", SessionController, :delete

      resources "/events", Account.EventController do
        resources "/invitations", Account.InvitationController, except: [:edit, :update]
        resources "/materials", Account.MaterialController
      end

      resources "/memberships", Account.MembershipController, expect: [:show, :edit, :update]
    end
  end

  scope "/classroom/:event_id", Classlab.Classroom, as: :classroom do
    pipe_through :browser # Use the default browser stack
    resources "/", DashboardController, only: [:show], singleton: true
    resources "/chat_messages", ChatMessageController, except: [:show]
  end
end
