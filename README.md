Bienvenue dans le depot du tutorial DBT

### Modules installés sous vscode:
Better Jinja
BigQuery Driver for SQLTools
dbt
GitHub Copilot
GitHub Copilot Chat
sqlfluff
SQLTools


NB : SQLTools a besoin de Nodejs pour fonctionner.
Le dossier de configuration de SQLTools se trouve ici :
C:\Users\<user>\AppData\Local\vscode-sqltools

C:\Users\<user>\AppData\Local\vscode-sqltools\Data> npm list
Data@ C:\Users\<user>\AppData\Local\vscode-sqltools\Data
+-- @google-cloud/bigquery@7.9.0
`-- google-auth-library@9.14.1

NB : Attention a zscaler. 
Les 2 certificats de zscaler doivent être inclus dans le magasin de certificats cacert.pem.
cf C:\Users\<user>\.npmrc
cafile=<chemin_vers>/cacert.pem


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
    "files.associations": {
        "*.sql": "jinja-sql",
        "*.yml": "jinja-yaml",
        "*.md": "jinja-md"
    },
    "sqltools.connections": [
        {
            "name": "BigQuery",
            "authenticator": "SERVICE_ACCOUNT",
            "location": "us",
            "previewLimit": 50,
            "driver": "BigQuery",
            "keyfile": "<chemin_vers>\\dbt-jaffle-shop-481313-0d88fc5a6686.json"
        }
    ],
    "sqltools.useNodeRuntime": true
}
```

NB : SQLFluff a besoin de Python et dbt pour fonctionner.
Packages installés dans le venv sqlfluff :
pip install  sqlfluff sqlfluff-templater-dbt dbt-core dbt-bigquery

NB : dbt fusion doit etre mentionné dans le PATH pour pouvoir être utilisé dans le terminal.

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
