# T-POO-700-LYO
# TimeManager

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


# Note:
1- Go to psql/ and run the following command:
```sudo docker-compose up -d```
2- Go to the root of the project and run the following command:
```mix setup```
3- Go to the root of the project and run the following command:
```mix ecto.migrate```
4- Run the following command to start the server:
```mix phx.server```
5- Enjoy the app!

## Dbeaver
You can use dbeaver to connect to database with the following information:
1- install dbeaver (https://dbeaver.io/download/ | sudo apt instalk dbveaver-ce)
2- open dbeaver
3- create a new connection
4- select PostgreSQL
5- in the connection settings, use the following information:
  - Host: localhost
  - Port: 5432
  - Database: time_manager_dev
  - User: postgres
  - Password: postgres
6- click on finish
7- enjoy the database!
```