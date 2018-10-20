
## Configure sshd

```

```

## Provision

```
PROVISION=1 cap athena provision:swap_file:add
PROVISION=1 cap athena provision:swap_file:swapon
PROVISION=1 cap athena provision:install_deps

PROVISION=1 cap athena provision:install_rbenv
PROVISION=1 cap athena provision:install_ruby
PROVISION=1 cap athena provision:install_nvm
PROVISION=1 cap athena provision:install_node
```

## Prepare

```
cap athena prepare:create_db_user
cap athena prepare:upload_files
```

## Deploy

```
DB_SETUP=1 cap athena deploy 
```

## Deploy with exported db data

### Import Data
TODO: Refactored with Capistrano 

On local:
```
scp tmp/20181020074633.sql athena:/tmp
```


On server:
```
createdb pg_production
psql -d pg_production < /tmp/20181020074633.sql
```

### Deploy
```
cap athena deploy
```

