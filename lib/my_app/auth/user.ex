defmodule MyApp.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "userss" do
    field :email, :string
    field :is_active, :boolean, default: false
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :is_active, :password])
    |> unsafe_validate_unique([:email], MyApp.Repo, message: "email is already in use")
    |> validate_required([:email, :is_active])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> put_password_hash()

  end

  defp put_password_hash(
           %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
         ) do
      change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end

end
