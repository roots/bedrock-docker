<p align="center">
  <a href="https://roots.io/">
    <img alt="Roots" src="https://cdn.roots.io/app/uploads/logo-roots.svg" height="55">
  </a>
</p>
<h1 align="center"><strong>bedrock-docker</strong></h1>

bedrock-docker is a quick way create a [Bedrock](https://github.com/roots/bedrock/) WordPress install meant for testing and continous integration. It is not a full replacement for development environments like [Trellis](https://github.com/roots/trellis).

bedrock-docker was developed for integration tests in [Bud](https://github.com/roots/bud) and Bedrock itself.

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

## Community

Keep track of development and community news.

- Join us on Roots Slack by becoming a [GitHub
  sponsor](https://github.com/sponsors/roots)
- Participate on the [Roots Discourse](https://discourse.roots.io/)
- Follow [@rootswp on Twitter](https://twitter.com/rootswp)
- Read and subscribe to the [Roots Blog](https://roots.io/blog/)
- Subscribe to the [Roots Newsletter](https://roots.io/subscribe/)
