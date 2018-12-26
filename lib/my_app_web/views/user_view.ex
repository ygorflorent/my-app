defmodule MyAppWeb.UserView do
  use MyAppWeb, :view
  alias MyAppWeb.UserView

  def render("index.json", %{userss: userss}) do
    %{data: render_many(userss, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      is_active: user.is_active}
  end
  def render("sign_in.json", %{user: user}) do
    %{
      data: %{
        user: %{
          message: "Login completed! Welcome!",
          email: user.email,
          id: user.id
        }
      }
    }
  end
  def render("logout.json", _params) do
    %{
      data: %{
        user: %{
          message: "Logout completed! See you!"
        }
      }
    }
  end
end
