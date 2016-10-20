defimpl Classlab.Permission, for: Classlab.Event do
  @moduledoc false
  alias Classlab.Event
  use Classlab.Web, :permission

  def collection(%Event{} = _event, _, %User{} = _user) do
    # event
    # |> preload([:memberships])
    # |> where(membership.role = :owner and membership.user_id == user.id)
  end

  def can?(%Event{}, action, %User{}) when action in [:edit, :update] do
  end
end
