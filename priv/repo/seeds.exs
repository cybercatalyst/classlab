# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Classlab.Repo.insert!(%Classlab.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Calendar
alias Classlab.{Repo, Role, User}

Repo.insert!(%User{
  id: 1,
  first_name: "Super",
  last_name: "Admin",
  email: "info@classlab.org",
  access_token: "1234",
  access_token_expired_at: Calendar.DateTime.now_utc(),
  superadmin: true
})

Repo.insert!(%Role{id: 1, name: "Owner"})
Repo.insert!(%Role{id: 2, name: "Trainer"})
Repo.insert!(%Role{id: 3, name: "Attendee"})