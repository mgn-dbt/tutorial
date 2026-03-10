Welcome to my DBT tutorial repository

I tried to make the dbt tutorial work with BigQuery and PostgreSql.
I use SCOOP under windows.
Tables data is loaded separately cf https://github.com/mgn-dbt/external

### Modules installed in vscode

```
- Better Jinja                          samuelcolvin.jinjahtml
- BigQuery Driver for SQLTools          evidence.sqltools-bigquery-driver
- SQLTools PostgreSQL/Cockroach Driver  mtxr.sqltools-driver-pg
- dbt                                   dbtlabsinc.dbt
- GitHub Copilot                        github.copilot
- GitHub Copilot Chat                   github.copilot-chat
- sqlfluff                              sqlfluff.vscode-sqlfluff
- SQLTools                              mtxr.sqltools
- YAML                                  redhat.vscode-yaml (1.19.1)
```

NB : SQLTools requires Node.js to work.<br>
The SQLTools configuration folder is located here:<br>
$env:LOCALAPPDATA\vscode-sqltools

C:\Users\\<user\>\AppData\Local\vscode-sqltools\Data\> npm list
```
Data@ C:\Users\<user>\AppData\Local\vscode-sqltools\Data
+-- @google-cloud/bigquery@7.9.0
`-- google-auth-library@9.14.1
```

NB : Beware zscaler.<BR>
The 2 zscaler certificates must be included in the cacert.pem certificate store.<BR>
cf C:\Users\\<user\>\\.npmrc
```
cafile=<path_to>/cacert.pem
```


### vscode user configuration (C:\Users\<user>\SCOOP\apps\vscode\current\data\user-data\User\profiles\xxxxxxxx\settings.json)
```json
{
    "dbt.dbtPath": "C:\\Users\\<user>\\.local\\bin\\dbt.exe",
    "sqlfluff.executablePath": "C:\\Users\\<user>\\SCOOP\\persist\\python\\venvs\\sqlfluff\\Scripts\\sqlfluff.exe",
    
    "sqltools.connections": [
        {
            "name": "BigQuery",
            "authenticator": "SERVICE_ACCOUNT",
            "location": "us",
            "previewLimit": 50,
            "driver": "BigQuery",
            "keyfile": "<path_to>\\dbt-jaffle-shop-xxxxxx-yyyyyyyyyyyy.json"
        },
        {
            "pgOptions": {
                "ssl": {
                    "rejectUnauthorized": true,
                    "ca": "C:\\Users\\<user>\\SCOOP\\persist\\ssl\\CA\\certs\\ca.cert.pem",
                    "cert": "C:\\Users\\<user>\\SCOOP\\persist\\ssl\\CA\\certs\\server.cert.pem",
                }
            },
            "ssh": "Disabled",
            "previewLimit": 50,
            "server": "localhost",
            "driver": "PostgreSQL",
            "name": "pg",
            // pg in SSL mode with server certificate verification only
            "connectString": "postgres://jaffle:jaffle@localhost:5432/jaffle_shop?sslmode=verify-ca"
        },
    ],
    "sqltools.useNodeRuntime": true,
    "redhat.telemetry.enabled": false,
    "github.copilot.enable": {
        "*": false,
        "plaintext": false,
        "markdown": false,
        "scminput": false,
        "yaml": true,
        "jinja-sql": true
    },
    "chat.viewSessions.orientation": "stacked",
}
```

NB : SQLFluff requires Python and dbt to function.<BR>
Packages installed in the sqlfluff venv:
```
python -m venv <path_to>\venvs\sqlfluff
<path_to>\venvs\sqlfluff\Scripts\activate.ps1
python.exe -m pip install --upgrade pip
pip install sqlfluff sqlfluff-templater-dbt dbt-core dbt-bigquery pip_system_certs
(pip_system_certs pour zscaler, en remplacement de certifi qui n'est plus maintenu)
Dont't install :
pip install dbt-metricflow dbt-metricflow[dbt-bigquery]
because they cause a DBT version downgrade for compatibility
```

To use autofix, it is recommended to do a second venv
```
python -m venv <path_to>\venvs\autofix
<path_to>\venvs\autofix\Scripts\activate.ps1
python.exe -m pip install --upgrade pip
pip install dbt-autofix pip_system_certs

dbt-autofix deprecations --json --all
dbt-autofix deprecations --semantic-layer
```

NB : dbt fusion must be listed in the PATH to be used in the terminal.<BR>
Update: dbt system update (in the executable's folder)

json schema cf https://github.com/dbt-labs/dbt-jsonschema
cf https://docs.getdbt.com/docs/about-dbt-extension


### Profiles.yml file
```yaml
default:
  target: dev
  outputs:
    dev:
      type: bigquery
      threads: 4
      project: dbt-jaffle-shop-xxxxxx
      dataset: dbt_<user>
      method: service-account
      keyfile: C:\Users\<user>\.dbt\dbt-jaffle-shop-xxxxxx-yyyyyyyyyyyy.json
      location: US
pg:
  target: dev
  outputs:
    dev:
      dbname: jaffle_shop
      host: localhost
      password: jaffle
      port: 5432
      schema: dbt_<user>
      search_path: dbt_<user>,public
      threads: 1
      type: postgres
      user: jaffle
      sslmode: verify-ca
      sslrootcert: C:\Users\<user>\SCOOP\persist\ssl\CA\certs\ca.cert.pem
```

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
