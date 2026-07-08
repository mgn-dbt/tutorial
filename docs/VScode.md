# VSCode

## Installed Modules

Cf .vscode/extensions.json

Disable autoupdate for dbt and YAML extensions to avoid compatibility problems.
It's up to you to decide when updating these extensions.

## User configuration

The user configuration files contains personal choices.

`$env:USERPROFILE\SCOOP\persist\vscode\data\user-data\User\settings.json`  
and (if profiles used)  
`$env:USERPROFILE\SCOOP\persist\vscode\data\user-data\User\profiles\xxxxxxxx\settings.json`  

```json
{
    "dbt.dbtPath": "C:\\Users\\<user>\\.local\\bin\\dbt.exe",
    // dbt core doesn't work with "dbt vscode extention" : unsupported dbt version
    "sqlfluff.executablePath": "C:\\Users\\<user>\\SCOOP\\persist\\python\\venvs\\sqlfluff\\Scripts\\sqlfluff.exe",
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
        "Pwsh": {
            "path": "pwsh.exe",
            "args": []
        }
    },
    "terminal.integrated.defaultProfile.windows": "Pwsh",
}
```
