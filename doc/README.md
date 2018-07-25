## Renew Certificates

Renew certificates manually by using capistrano tasks.

```
cap apollo letsencrypt:gen_certs

cap apollo nginx:reload
```
