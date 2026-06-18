# VSCode

## Installed Modules

Cf .vscode/extensions.json

Disable autoupdate for dbt and YAML extensions to avoid compatibility problems.
It's up to you to decide when updating these extensions.

NB : SQLTools requires Node.js to work.

NB : Beware Zscaler if you have it.

The 2 Zscaler certificates must be included in the cacert.pem npm certificate store.

Cf `$env:USERPROFILE\.npmrc`

```conf
cafile=<path_to>/cacert.pem
```

## User configuration

The user configuration file contains personal choices.

cf `$env:USERPROFILE\SCOOP\apps\vscode\current\data\user-data\User\profiles\xxxxxxxx\settings.json`

```json
{
    "dbt.dbtPath": "C:\\Users\\<user>\\.local\\bin\\dbt.exe",
    // dbt core doesn't work with "dbt vscode extention" : unsupported dbt version
    "sqlfluff.executablePath": "C:\\Users\\<user>\\SCOOP\\persist\\python\\venvs\\sqlfluff\\Scripts\\sqlfluff.exe",
    "sqltools.connections": [
        {
            "name": "BigQuery",
            "authenticator": "SERVICE_ACCOUNT",
            "location": "us",
            "previewLimit": 50,
            "driver": "BigQuery",
            "keyfile": "C:\\Users\\<user>\\.dbt\\dbt-jaffle-shop-xxxxxx-yyyyyyyyyyyy.json"
        },
        {
            "pgOptions": {
                "ssl": {
                    "rejectUnauthorized": true,
                    "ca": "C:\\Users\\<user>\\SCOOP\\persist\\ssl\\mkcert\\rootCA.pem",
                    "cert": "C:\\Users\\<user>\\SCOOP\\persist\\ssl\\mkcert\\server.cert.pem",
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
    //https://code.visualstudio.com/docs/copilot/ai-powered-suggestions
    "github.copilot.enable": {
        "*": false,
        "plaintext": false,
        "markdown": false,
        "scminput": false,
        "yaml": true,
        "jinja-sql": true
    },
    // customized terminals
    "terminal.integrated.profiles.windows": {
        "PowerShell": null,
        "Command Prompt": null,
        "Git Bash": null,
        "Pwsh_vdbt": {
            "path": "pwsh.exe",
            "args": [
                "-noexit",
                "-nologo",
                "-file",
                "C:\\Users\\<user>\\SCOOP\\persist\\python\\venvs\\sqlfluff\\Scripts\\Activate.ps1"
            ]
        },
        "Pwsh": {
            "path": "pwsh.exe"
        },
    },
}
```
