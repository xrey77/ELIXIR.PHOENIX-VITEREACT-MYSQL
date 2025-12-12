defmodule ElixirMyqlWeb.Router do
  use ElixirMyqlWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    # plug :put_root_layout, html: {ElixirMyqlWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug ElixirMyqlWeb.Plug.Authenticate
  end

  pipeline :user do
    plug :accepts, ["json"]
  end

  scope "/", ElixirMyqlWeb do
    pipe_through :user
    post "/user/signup", RegisterController, :signup_api
    post "/user/signin", LoginController, :signin_api
    patch "/user/mfa/verifytotp/:id", MfaverifyController, :mfaVerify_api
    get "/user/products/list/:page", ListController, :productList_api
    get "/user/products/search/:page/:keyword", SearchController, :productSearch_api
  end

  scope "/", ElixirMyqlWeb do
    pipe_through :api
    patch "/api/mfa/activate/:id", MfaactivateController, :mfaActivate_api
    get "/api/getuserid/:id", GetuseridController, :getUserid_api
    get "/api/getallusers", GetallusersController, :getAllusers_api
    patch "/api/changepassword/:id", ChangepasswordController, :changePassword_api
    patch "/api/updateprofile/:id", UpdateprofileController, :updateProfile_api
    patch "/api/uploadpicture/:id", UploadpictureController, :uploadPicture_api
  end

  scope "/", ElixirMyqlWeb do
    pipe_through :browser

    get "/", PageController, :home
  end



  # Other scopes may use custom stacks.
  # scope "/api", ElixirMyqlWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elixir_myql, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ElixirMyqlWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
