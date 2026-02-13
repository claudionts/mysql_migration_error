defmodule MysqlMigrationErrorPhxWeb.PageController do
  use MysqlMigrationErrorPhxWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
