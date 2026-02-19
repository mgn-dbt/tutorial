Bienvenue dans le depot du tutorial DBT

### Modules installés sous vscode:
- Better Jinja                    samuelcolvin.jinjahtml
- BigQuery Driver for SQLTools    evidence.sqltools-bigquery-driver
- dbt                             dbtlabsinc.dbt
- GitHub Copilot                  github.copilot
- GitHub Copilot Chat             github.copilot-chat
- sqlfluff                        sqlfluff.vscode-sqlfluff
- SQLTools                        mtxr.sqltools
- YAML                            redhat.vscode-yaml (1.19.1)


NB : SQLTools a besoin de Nodejs pour fonctionner.<BR>
Le dossier de configuration de SQLTools se trouve ici :<BR>
C:\Users\\<user\>\AppData\Local\vscode-sqltools

C:\Users\\<user\>\AppData\Local\vscode-sqltools\Data\> npm list
```
Data@ C:\Users\<user>\AppData\Local\vscode-sqltools\Data
+-- @google-cloud/bigquery@7.9.0
`-- google-auth-library@9.14.1
```

NB : Attention a zscaler.<BR>
Les 2 certificats de zscaler doivent être inclus dans le magasin de certificats cacert.pem.<BR>
cf C:\Users\\<user\>\\.npmrc
```
cafile=<chemin_vers>/cacert.pem
```


### vscode configuration
```json
{
    "dbt.dbtPath": "<chemin_vers>\\.local\\bin\\dbt.exe",
    "sqlfluff.executablePath": "<chemin_vers>\\python\\venvs\\sqlfluff\\Scripts\\sqlfluff.exe",
    "sqlfluff.linter.run": "onSave",
    "python.pythonPath": "<chemin_vers>\\python\\venvs\\sqlfluff\\bin\\python",
    "sqltools.connections": [
        {
            "name": "BigQuery",
            "authenticator": "SERVICE_ACCOUNT",
            "location": "us",
            "previewLimit": 50,
            "driver": "BigQuery",
            "keyfile": "<chemin_vers>\\dbt-jaffle-shop-xxxxxx-yyyyyyyyyyyy.json"
        }
    ],
    "sqltools.useNodeRuntime": true,
}
```

NB : SQLFluff a besoin de Python et dbt pour fonctionner.<BR>
Packages installés dans le venv sqlfluff :
```
python -m venv <chemin_vers>\venvs\sqlfluff
<chemin_vers>\venvs\sqlfluff\Scripts\activate.ps1
python.exe -m pip install --upgrade pip
pip install sqlfluff sqlfluff-templater-dbt dbt-core dbt-bigquery pip_system_certs
(pip_system_certs pour zscaler, en remplacement de certifi qui n'est plus maintenu)
Ne pas installer :
pip install dbt-metricflow dbt-metricflow[dbt-bigquery]
car ils provoquent une descente de version dbt pour la compatibilite 
```

Pour utiliser autofix, il est recommandé de faire un deuxième venv
```
python -m venv <chemin_vers>\venvs\autofix
<chemin_vers>\venvs\autofix\Scripts\activate.ps1
python.exe -m pip install --upgrade pip
pip install dbt-autofix pip_system_certs

dbt-autofix deprecations --json --all
dbt-autofix deprecations --semantic-layer
```

NB : dbt fusion doit etre mentionné dans le PATH pour pouvoir être utilisé dans le terminal.<BR>
Mise à jour : dbt system update (dans le dossier de l'executable)

json schema cf https://github.com/dbt-labs/dbt-jsonschema
cf https://docs.getdbt.com/docs/about-dbt-extension


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
