defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller

  alias MyApp.Auth
  alias MyApp.Auth.User

  action_fallback MyAppWeb.FallbackController

  def index(conn, _params) do
    userss = Auth.list_userss()
    render(conn, "index.json", userss: userss)
  end

  def create(conn, %{"user" => user_params}) do
    case Auth.create_user(user_params) do
      {:ok, %User{} = user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, _user} ->
        conn
        |> put_status(:unauthorized)
        |> render(MyAppWeb.ErrorView, "401.json", message: "Unable to create user! Try again with other options!")
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)

    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_status(:ok)
        |> render(MyAppWeb.UserView, "sign_in.json", user: user)

      {:error, message} ->
        conn
        # |> delete_session(:current_user_id)
        |> put_status(:unauthorized)
        |> render(MyAppWeb.ErrorView, "401.json", message: message)
    end
  end

  def logout(conn, _params) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
      |> delete_session(:current_user_id)
      |> render(MyAppWeb.UserView, "logout.json")
    else
      conn
      |> put_status(:unauthorized)
      |> render(MyAppWeb.ErrorView, "401.json", message: "Unauthenticated user")
      |> halt()
    end
  end
end
