# docker-letsencrypt

container to generate letsencrypt certs using dehydrated + lexicon

## Supported tags and Dockerfile links
- [`latest` (*Dockerfile*)](https://github.com/willfarrell/docker-letsencrypt/blob/master/Dockerfile)

[![](https://images.microbadger.com/badges/version/willfarrell/letsencrypt.svg)](http://microbadger.com/images/willfarrell/letsencrypt "Get your own version badge on microbadger.com")  [![](https://images.microbadger.com/badges/image/willfarrell/letsencrypt.svg)](http://microbadger.com/images/willfarrell/letsencrypt "Get your own image badge on microbadger.com")

## Docs
- https://github.com/lukas2511/dehydrated
- https://github.com/AnalogJ/lexicon

## Dockerfile
Use to set your own defaults or overwrite in the command
```Dockerfile
FROM willfarrell/letsencrypt:latest

COPY config /etc/dehydrated/config
```

## ENV
```
# defaults to `staging`, use `production` when ready.
LE_ENV=staging
# Only required if you plan to use dns-01 challenges (use for private services)
PROVIDER=cloudflare
LEXICON_CLOUDFLARE_USERNAME=
LEXICON_CLOUDFLARE_TOKEN=
```

## Testing
```bash
docker build -t letsencrypt .

# private
docker run \
    --env-file letsencrypt.env \
    letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --hook dehydrated-dns \
        --challenge dns-01 \
        --force

# public
docker run -d \
    --env-file letsencrypt.env \
    letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --challenge http-01 \
        --force

# reload nginx
docker exec -it nginx_nginx_1 /etc/scripts/make_hpkp && /etc/init.d/nginx reload                                                                          
```

## Deploy
See https://github.com/willfarrell/docker-nginx for full example
```bash
# private
docker run \
    --volumes-from nginx_nginx_1 \
    --env-file letsencrypt.env \
    willfarrell/letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --out /etc/ssl \
        --hook dehydrated-dns \
        --challenge dns-01

# public
docker run -d \
    --volumes-from nginx_nginx_1 \
    --env-file letsencrypt.env \
    willfarrell/letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --out /etc/ssl \
        --challenge http-01
```


Note: `certbot/make_letsencrypt_cert` is an alternate method that one could use with the certbot docker image. However dns-01 is not supported.