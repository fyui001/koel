APP_CONTAINER_ID = `docker compose ps -q app`

init:
	@cp .env.example .env

init_mutagen:
	@curl -L https://github.com/mutagen-io/mutagen/releases/download/v0.16.2/mutagen_linux_amd64_v0.16.2.tar.gz | sudo tar -zxf - -C /usr/local/bin
	@curl -L https://github.com/mutagen-io/mutagen-compose/releases/download/v0.16.2/mutagen-compose_linux_amd64_v0.16.2.tar.gz | sudo tar -zxf - -C /usr/local/bin

koel_init:
	@docker compose exec app php artisan koel:init --no-assets
	@docker compose exec app php artisan koel:admin:change-password

docker_build:
	@docker compose build --no-cache

composer_install:
	@docker compose exec app composer install

cache_clear:
	@docker compose exec app php artisan cache:clear
	@docker compose exec app php artisan view:clear
	@docker compose exec app php artisan route:clear
	@docker compose exec app php artisan config:clear

permission:
	@docker compose exec app chmod -R 777 /code/storage bootstrap/cache /music

migrate:
	@docker compose exec app php artisan migrate

migrate_seed:
	@docker compose exec app php artisan migrate:fresh --seed --drop-views

bash:
	@docker compose exec app bash

node-ssh:
	@docker compose exec js bash

up:
	@mutagen-compose up -d

down:
	@mutagen-compose down

stop:
	@mutagen-compose stop

sync:
	@docker compose exec app php artisan koel:sync

setup:
	@make composer_install
	@docker compose exec app php artisan key:generate
	@make cache_clear
	@make migrate_seed
	@make permission
	@docker compose exec app php artisan storage:link
	@make koel_init
