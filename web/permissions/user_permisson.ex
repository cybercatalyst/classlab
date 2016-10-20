defimpl Classlab.Permission, for: Classlab.User do
  @moduledoc false
  use Classlab.Web, :permission

  def collection(user, %User{} = current_user, _) do
    if current_user.superadmin? do
      user
    else
      user |> Ecto.Query.where(id: ^current_user.id)
    end
  end

  def member(user, %User{} = current_user, _) do
    user
    |> Ecto.Query.where(id: ^current_user.id)
  end

  def can?(%User{} = user, %User{} = current_user, action) when action in [:edit, :update] do
    # user.id == current_user.id => true
    # user.superadmin => true
  end
end
