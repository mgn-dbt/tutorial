# Welcome to my repository on DBT tutorials

## Goals

After following tutorials in [dbtlabs learning](https://learn.getdbt.com/learn)  
I tried to make the dbt tutorial work with BigQuery, PostgreSql or Duckdb.

Cf [cross-database-macros](https://docs.getdbt.com/reference/dbt-jinja-functions/cross-database-macros)

- BigQuery with Dbt Fusion and the dbt vscode extension (also working in dbt cloud).
- PostgreSql or Duckdb with Dbt core in sqlfluff venv (cf further in this page).

I tried to make the code as generic as possible.  
VSCode extension is made to work with dbt fusion.  
But it can be used to edit dbt core projects if you restrict to CLI in terminal.

There is a Git branch called develop for BigQuery  
[branch develop](https://github.com/mgn-dbt/tutorial/tree/develop)

There is a Git branch called develop_pg for PostgreSQL  
[branch develop_pg](https://github.com/mgn-dbt/tutorial/tree/develop_pg)

There is a Git branch called develop_duck for Duckdb  
[branch develop_duck](https://github.com/mgn-dbt/tutorial/tree/develop_duck)  
But VSCode should not be used with duckdb.  
See why in this [readme](https://github.com/mgn-dbt/external/blob/main/README.md#duckdb)

Changing git branch (changing database) should be followed by closing/reopening terminal.  
Cf customized terminals in the vscode user configuration settings

Table data is loaded separately cf [external repository](https://github.com/mgn-dbt/external)  
Seeds are not for loading real live data but lookup tables or mock data for tests.  
So this other project is a bit of an exception.

## VSCode

### Installed Modules

Cf .vscode/extensions.json

Disable autoupdate for dbt and YAML extensions.

NB : SQLTools requires Node.js to work.

NB : Beware zscaler if you have it.

The 2 zscaler certificates must be included in the cacert.pem npm certificate store.

```powershell
Cf $env:USERPROFILE\.npmrc

cafile=<path_to>/cacert.pem
```

### User configuration

($env:USERPROFILE\SCOOP\apps\vscode\current\data\user-data\User\profiles\xxxxxxxx\settings.json)

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
            "keyfile": "<path_to>\\dbt-jaffle-shop-xxxxxx-yyyyyyyyyyyy.json"
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

## DBT

Beware upgrading dbt fusion or the dbt vscode extension.  
Keep the dbt vscode extension version one release behind to avoid problems.

You can choose the version you want.  
Under the dbt vscode extension page : `Uninstall / Install Specific Version`

Current vscode extension version v0.60.0  => fusion version 2.0.0-preview.164

Compatibility between the dbt fusion and vscode extension is important.  
So Install the dbt fusion version that match or vscode will propose an upgrade.

![dbt vscode extension](dbt_vscode_extension.png)

```powershell
iwr -uri https://public.cdn.getdbt.com/fs/install/install.ps1 -OutFile install.ps1
& install.ps1 -Version "2.0.0-preview.164"
```

or if fusion is already installed

```powershell
& install.ps1 -Update -Version "2.0.0-preview.164"  
```

Check your PATH environment variable after using install.ps1.

NB : Fusion installation process updates the profile file Microsoft.PowerShell_profile.ps1 :  
Cf $env:USERPROFILE\Documents\Powershell\Microsoft.PowerShell_profile.ps1  
or $env:USERPROFILE\Documents\WindowsPowershell\Microsoft.PowerShell_profile.ps1  
It ensure dbtf alias is created.

Beware package-lock.yml yaml file, dbt fusion upgrade it with a bad format for dbt cloud.  
After executing "dbt deps" under source control "Discard changes" for package-lock.json.  
Keep dbt cloud version of package-lock.json for compatibility.  
Bug or new format ???

I put generic tests under "macros/generic" instead of "tests/generic" for convenience.  
They are macros so it seems their right place.

### Environment variable

This environment user variable corresponds with a variable defined in dbt cloud following tutorials  

```powershell
[Environment]::SetEnvironmentVariable("DBT_ENV_NAME", 'dev', [System.EnvironmentVariableTarget]::User)
```

### Profiles.yml

cf [external repository](https://github.com/mgn-dbt/external#my-dbt-profiles)

### Python venvs

NB : SQLFluff requires Python and dbt to work.

Packages installed in the sqlfluff venv:

```cmd
python -m venv <path_to>\venvs\sqlfluff
<path_to>\venvs\sqlfluff\Scripts\activate.ps1
python.exe -m pip install --upgrade pip
pip install sqlfluff sqlfluff-templater-dbt dbt-core dbt-bigquery dbt-postgres dbt-duckdb pip_system_certs
(pip_system_certs for zscaler, replacing certifi which is no longer maintained)

Installing dbt-metricflow, dbt-metricflow[dbt-postgres], dbt-metricflow[dbt-duckdb]
causes a DBT version downgrade for compatibility
```

PostgreSQL or Duckdb works only in SQLFluff venv (dbt core) !  
It means using Pwsh_vdbt terminal.

To use autofix, it is recommended to create a second venv

```cmd
python -m venv <path_to>\venvs\autofix
<path_to>\venvs\autofix\Scripts\activate.ps1
python.exe -m pip install --upgrade pip
pip install dbt-autofix pip_system_certs

dbt-autofix deprecations --json --all
dbt-autofix deprecations --semantic-layer
```

Autofix can help in migrating SL Legacy spec to the new spec.  

SL legacy spec example  
[SL Legacy](https://github.com/dbt-labs/Semantic-Layer-Online-Course/tree/main/models/metrics)

SL new spec example  
[SL new specs](https://github.com/dbt-labs/Semantic-Layer-Online-Course/tree/fusion_spec/models/marts)

### Semantic Layer (SL)

[SL Commands](https://docs.getdbt.com/docs/build/metricflow-commands)

New SL works only with dbt fusion and dbt cloud. => "dbt sl" command  

Commands

```cmd
dbt sl validate
dbt sl list metrics
dbt sl list dimensions --metrics m_large_order
dbt sl list entities --metrics m_large_order
dbt sl list saved-queries

Add [--compile] to verify SQL query
dbt sl query --metrics m_revenue --group-by metric_time --order-by -metric_time
dbt sl query --metrics m_new_customers --group-by metric_time --order-by -metric_time
dbt sl query --metrics m_new_customers --group-by metric_time --order-by -metric_time
dbt sl query --metrics m_new_customers --group-by metric_time__week --order-by -metric_time__week
dbt sl query --metrics m_food_revenue --group-by metric_time,order_items__is_food_item --limit 10 --order-by -metric_time --where "order_items__is_food_item = 1"
```

dbt core needs Legacy SL. => "mf" command  

Commands (dbt core)

```cmd
mf validate-configs (instead of validate)
Add [--explain] to verify SQL query instead of [--compile]
--order (instead of --order-by)
```

Beware entity names :  
Entities must have the same name between primary model and foreign model for automatic join to operate.  
For convenience my entities begin with "e_".  
[Join logic](https://docs.getdbt.com/docs/build/join-logic)

### JSON

json schema  
cf [dbt jsonschema](https://github.com/dbt-labs/dbt-jsonschema)  
cf [dbt artifact jsonschema](https://schemas.getdbt.com/)

json schema applied is specified in .vscode/settings.json

### Resources

- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

## PostgreSQL

cf [external repository](https://github.com/mgn-dbt/external#postgresql)

## Duckdb

cf [external repository](https://github.com/mgn-dbt/external#duckdb)
