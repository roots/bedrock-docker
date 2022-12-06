# Roots dev environment

## Quickstart

Run `./dev.sh` to clone `bedrock` and `sage` into `./bedrock`:

```sh
./dev.sh
```

Configure the `WP_HOME` and `WP_SITEURL` variables as needed in `.env`.

Build and run the container in the background:

```sh
docker compose up --build -d
```

Get a bash session going:

```sh
docker compose run bedrock bash
```

This bash session has access to `composer`, `node` and the wordpress cli.

Setup dev environment as needed:

```sh
cd web/app/themes/sage
composer install
yarn install
yarn build
wp theme activate sage
```

## Existing installs

1. Copy `build` and `docker-compose.yml` into the root of an existing bedrock install.
2. Edit `services.bedrock.volumes` in `docker-compose.yml` to reference the correct path. `./bedrock:/srv/bedrock` becomes `./:/srv/bedrock`.
