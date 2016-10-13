defmodule <%= module %> do
  use <%= base %>.Web, :model

  # Fields
  schema <%= inspect plural %> do
<%= for {k, _} <- attrs do %>    field <%= inspect k %>, <%= inspect types[k] %><%= schema_defaults[k] %>
<% end %><%= for {k, _, m, _} <- assocs do %>    belongs_to <%= inspect k %>, <%= m %>
<% end %>
    timestamps()
  end

  # Composable Queries

  # Changesets & Validations
  @fields ~w(<%= Enum.map_join(attrs, " ", &elem(&1, 0)) %>)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
<%= for k <- uniques do %>    <%= "## " %><%= k |> Atom.to_string |> String.replace_prefix(":", "") %>
    |> unique_constraint(<%= inspect k %>)
<% end %>  end

  # Model Functions
end
