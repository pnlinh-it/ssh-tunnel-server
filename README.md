### Create ssh key-pair and environment file
- Run `ssh-keygen`
- Enter your key name.
- Run `cp .env.example .env`
- Populate `PUBLIC_KEY` value with the content of `id_rsa.pub` that generated from above step.

```sh
pnlinh@Linhs-MacBook-Pro:~# ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/pnlinh/.ssh/id_rsa): id_rsa
```
### Create container from Docker file
This repository already has a `docker-compose.yml` so you just need to run `docker-compose up -d --build`

### Create container from Github container registry
```yml
version: "3.8"

services:
  open-ssh-server:
    image: ghcr.io/pnlinh-it/ssh-tunnel-server:latest
    container_name: ssh-tunnel-server
    restart: unless-stopped
    environment:
      PUBLIC_KEY: "${PUBLIC_KEY}"
    ports:
      - "2223:22"
```

### Nginx proxy and let's encrypt SSL
If you use [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) and [acme-companion](https://github.com/nginx-proxy/acme-companion), you can consider below compose file:
```yml
version: "3.8"

services:
  open-ssh-server:
    image: ghcr.io/pnlinh-it/ssh-tunnel-server:latest
    container_name: open-ssh-server
    restart: unless-stopped
    environment:
      PUBLIC_KEY: "${PUBLIC_KEY}"
      VIRTUAL_HOST: <your_domain>
      LETSENCRYPT_HOST: <your_domain>
    networks:
      - tunnel
      - nginx-proxy
    ports:
      - "2223:22"
    expose:
      - "80"

networks:
  tunnel:
    driver: bridge
    name: tunnel

  nginx-proxy:
    external: true
    name: nginx-proxy

```
