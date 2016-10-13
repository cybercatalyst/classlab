defmodule Classlab.Factory do
  alias Calecto.DateTimeUTC
  use ExMachina.Ecto, repo: Classlab.Repo

  def event_factory do
    %Classlab.Event{
      public: false,
      name: sequence(:name, &"My Event #{&1}"),
      slug: sequence(:slug, &"event-#{&1}"),
      description: "My awesome event!",
      invitation_token: sequence(:invitation_token, &"inivitation-token-#{&1}"),
      invitation_token_active: false,
      starts_at: DateTimeUTC.cast!("2001-07-29T01:02:03"),
      ends_at: DateTimeUTC.cast!("2001-07-29T01:02:03"),
      timezone: "Berlin/Europe",
      location: build(:location)
    }
  end

  def user_factory do
    %Classlab.User{
      first_name: "John",
      last_name: "Doe",
      email: sequence(:email, &"john-#{&1}@example.com"),
      access_token: sequence(:access_token, &"access-token-#{&1}"),
      access_token_expired_at: DateTimeUTC.cast!("2001-07-29T01:02:03"),
      superadmin: false
    }
  end

  def location_factory do
    %Classlab.Location{
      name: "Meet and Greet with Sascha and Martin",
      address_line_1: "Kopstadtplatz 24/25",
      city: "Essen",
      zipcode: "45127",
      country: "Germany"
    }
  end

  def membership_factory do
    %Classlab.Membership{
      user: build(:user),
      event: build(:event),
      role: 1
    }
  end
end
