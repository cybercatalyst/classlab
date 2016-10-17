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


  scope "/", Classlab do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/session/:id", SessionController, :show
    delete "/logout", SessionController, :delete
    get "/invitation/:event_slug/:invitation_token", InvitationController, :new
    post "/invitation/:event_slug/:invitation_token", InvitationController, :create
    get "/invitation/:event_slug/:invitation_token/complete", InvitationController, :show
  end

  #############################################################################
  ### Account
  #############################################################################
  pipeline :account do
    plug :put_layout, {Classlab.LayoutView, :account}
  end

  scope "/account", Classlab.Account, as: :account do
    pipe_through [:browser, :account]
    resources "/", DashboardController, only: [:show], singleton: true
    resources "/events", EventController
    resources "/feedbacks", FeedbackController
    resources "/invitations", InvitationController, only: [:index, :update, :delete]
    resources "/memberships", MembershipController, only: [:index, :delete]
    resources "/user", UserController, only: [:edit, :update], singleton: true
  end

  #############################################################################
  ### Classroom
  #############################################################################
  pipeline :classroom do
    plug :put_layout, {Classlab.LayoutView, :classroom}
  end

  scope "/classroom/:event_id", Classlab.Classroom, as: :classroom do
    pipe_through [:browser, :classroom] # Use the default browser stack
    resources "/", DashboardController, only: [:show], singleton: true
    resources "/chat_messages", ChatMessageController, except: [:show]
    resources "/feedbacks", FeedbackController, only: [:index]
    resources "/invitations", InvitationController, except: [:show, :edit, :update]
    resources "/materials", MaterialController
    resources "/memberships", MembershipController, only: [:index, :delete]
  end

  #############################################################################
  ### Superadmin
  #############################################################################
  pipeline :superadmin do
    plug :put_layout, {Classlab.LayoutView, :superadmin}
  end

  scope "/superadmin", Classlab.Superadmin, as: :superadmin do
    pipe_through [:browser, :superadmin] # Use the default browser stack
    resources "/", DashboardController, only: [:show], singleton: true
    resources "/users", UserController
  end
end
