defmodule ElixirMyql.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :mobile, :string
    field :username, :string
    field :password, :string
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :roles, :string
    field :isactivated, :integer
    field :isblocked, :integer
    field :mailtoken, :integer
    field :userpic, :string
    field :secret, :string
    field :qrcodeurl, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :email, :mobile, :username, :password, :roles, :isactivated, :isblocked, :mailtoken, :userpic, :secret, :qrcodeurl])
    |> validate_required([:firstname, :lastname, :email, :mobile, :username, :password, :roles, :isactivated, :isblocked, :mailtoken, :userpic, :secret, :qrcodeurl])
  end
end
