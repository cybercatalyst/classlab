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
alias Classlab.{Repo, Role}

Repo.insert!(%Role{id: 1, name: "Owner"})
Repo.insert!(%Role{id: 2, name: "Trainer"})
Repo.insert!(%Role{id: 3, name: "Attendee"})