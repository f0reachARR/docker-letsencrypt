# docker-letsencrypt

container to generate letsencrypt certs using dehydrated + lexicon

## Supported tags and Dockerfile links
- [`latest` (*Dockerfile*)](https://github.com/willfarrell/docker-letsencrypt/blob/master/Dockerfile)

[![](https://images.microbadger.com/badges/version/willfarrell/letsencrypt.svg)](http://microbadger.com/images/willfarrell/letsencrypt "Get your own version badge on microbadger.com")  [![](https://images.microbadger.com/badges/image/willfarrell/letsencrypt.svg)](http://microbadger.com/images/willfarrell/letsencrypt "Get your own image badge on microbadger.com")

## Docs
- https://github.com/lukas2511/dehydrated
- https://github.com/AnalogJ/lexicon
- https://github.com/willfarrell/docker-nginx

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
# CloudFlare example
PROVIDER=cloudflare
LEXICON_CLOUDFLARE_USERNAME=
LEXICON_CLOUDFLARE_TOKEN=

# Route 53 example
PROVIDER=route53
LEXICON_ROUTE53_ACCESS_KEY=
LEXICON_ROUTE53_ACCESS_SECRET=
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

# reload nginx to see changes                                                                         
```

## Deploy
Note the use of `--hook dehydrated-dns`, [dehydrated-dns](https://github.com/AnalogJ/lexicon/blob/master/examples/dehydrated.default.sh) is a script wrapper to call lexicon from dehydrated.
```bash
# private
docker run \
    --volumes-from docker_nginx_1 \
    --env-file letsencrypt.env \
    willfarrell/letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --out /etc/ssl \
        --hook dehydrated-dns \
        --challenge dns-01

# public
docker run -d \
    --volumes-from docker_nginx_1 \
    --env-file letsencrypt.env \
    willfarrell/letsencrypt \
    dehydrated \
        --cron --domain letsencrypt.willfarrell.ca \
        --out /etc/ssl \
        --challenge http-01
```

## Route53 Access Policy
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZonesByName",
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```