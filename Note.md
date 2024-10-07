# Initialisation du projet:
1. On commence par cree le projet avec `mix phx.new TimeManager --no-html`
2. On prepare le docker-compose pour postgresql (cf psql/docker-compose.yaml)
3. On setup le projet avec `mix setup`
4. On cree la base de donnees avec `mix ecto.create`
5. On genere les `gen.json` avec 
    - `mix phx.gen.json Users User users first_name:string last_name:string username:string:unique email:string:unique `  
    - `mix phx.gen.json Clocks Clock clocks time:naive_datetime status:boolean user_id:references:users`
    - `mix phx.gen.json WorkingTimes WorkingTime working_times start:naive_datetime end:naive_datetime user_id:references:users`
    - `mix phx.gen.json Tasks Task tasks title:string description:string due_date:naive_datetime user_id:references:users`
6. On migre les tables avec `mix ecto.migrate`
7. On ajoute les routes dans `lib/time_manager_web/router.ex`
8. On genere les REST avec `mix phx.routes`

## Pour lancer le projet:
- On lance le docker-compose avec `docker-compose -f psql/docker-compose.yaml up -d`
- On lance le serveur avec `mix phx.server`