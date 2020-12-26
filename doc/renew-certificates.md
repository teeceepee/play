## Renew Certificates

Renew certificates manually by using capistrano tasks.

```
cap apollo letsencrypt:gen_certs

cap apollo nginx:reload
```


## acme.sh

```
cd /etc/nginx/sites-enabled
mv play_apollo ..

cp ../foo .
```

```
acme.sh  --issue -d teeceepee.com -d nerv.teeceepee.com --nginx 
```

```
rm foo
mv ../play_apollo .
```

```
cd /var/www/play/current/letsencrypt

cp ~/.acme.sh/teeceepee.com/fullchain.cer teeceepee.com-fullchain.pem
cp ~/.acme.sh/teeceepee.com/teeceepee.com.key teeceepee.com-key.pem

service nginx reload
```

```
server {
  listen 80;
  server_name teeceepee.com nerv.teeceepee.com;

  location / {
    root /var/www/play/current/public;
  }

}
```
