Bienvenue dans le depot du tutorial DBT

### Modules installés sous vscode:
- Better Jinja
- BigQuery Driver for SQLTools
- dbt
- GitHub Copilot
- GitHub Copilot Chat
- sqlfluff
- SQLTools
- vscode-dbt (https://marketplace.visualstudio.com/items?itemName=bastienboutonnet.vscode-dbt)


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
    "editor.quickSuggestions": {
        "strings": true
    },
    "editor.rulers": [100],
    "diffEditor.ignoreTrimWhitespace": false,
    "dbt.dbtPath": "<chemin_vers>\\dbtf\\dbt.exe",
    "sqlfluff.executablePath": "<chemin_vers>\\python\\venvs\\sqlfluff\\Scripts\\sqlfluff.exe",
    "sqlfluff.linter.run": "onSave",
    "python.pythonPath": "<chemin_vers>\\python\\venvs\\sqlfluff\\bin\\python",
    "files.associations": {
        "*.sql": "jinja-sql"
    },
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
    "sqltools.useNodeRuntime": true
}
```

NB : SQLFluff a besoin de Python et dbt pour fonctionner.<BR>
Packages installés dans le venv sqlfluff :
```
pip install  sqlfluff sqlfluff-templater-dbt dbt-core dbt-bigquery python-certifi-win32  (pour zscaler)
pip install  dbt-metricflow dbt-metricflow[dbt-bigquery] ???
```

NB : dbt fusion doit etre mentionné dans le PATH pour pouvoir être utilisé dans le terminal.<BR>
Mise à jour : dbt system update (dans le dossier de l'executable)

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
