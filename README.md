# GitHub Action to fetch configuration values from Azure App Configuration
This action helps you automate your workflows.

With this action you don't have to write your own scripts for getting configs from [Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/).

# Note
Please take into attention that this action does not install Azure CLI.
Azure CLI should be installed, so 
* if it's a GitHub-hosted runner then `az` is installed by default, but version is always used latest
* if it's a self-hosted runner, you can install `az` on your runner

Or you can always run inside a [container](https://docs.github.com/en/actions/using-jobs/running-jobs-in-a-container):
```yaml
jobs:
    runs-on: ubuntu-latest
    container:
        image: mcr.microsoft.com/azure-cli:2.41.0
```
## Dependencies on other GitHub Actions
[Azure/Login](https://github.com/Azure/login) – **optional** Login with your Azure credentials. Authentication via connection strings or keys is not supported.

# Usage
Default usage will look like this:
```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: dmitriybobrovskiy/get-azure-app-configuration-values@v1.0.0
        with:
          login_credentials: ${{ secrets.AZURE_CREDENTIALS }}
          app_configuration: company-main-appconf
          secrets: |
            DatabasePassword=platform-api-password
            ClientSecret=platform-api-client-secret
            AuthToken=platform-auth-token
            Serilog__WriteTo__ApplicationInsights__Args__telemetryConfiguration__ConnectionString=ai-connection-string
          configs: |
            User=platform-api-user
            ApiUrl=platform-api-url
        
      - name: Some step to consume configs
        run: |
          echo "${{ env.User }} ${{ env.ApiUrl }}"
```
What is going on under the hood:
1. Login to Azure using provided credentials (if they are provided)
2. Get all configs with this label
3. For each config found
   1. Save value to GitHub environment variable

# Customizing
## inputs
| Name                | Mandatory | Description                                                                                                                                                                                                                                                                                                             |
| ------------------- | --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `app_configuration`          | `true`    | App Configuration where configs will be fetched from.                                                                                                                                                                                                                                                                           |
| `login-credentials` | `false`   | Credentials to login to Azure. If not provided login action won't be performed.                                                                                                                                                                                                                                         |
| `configs`           | `false`   | List of environment variables and config names divided by equation sign (`=`) and separated by new line. Config value will be taken from App Configuration by it's name and saved to GitHub environment by name provided on the left from equation sign (`=`) |
| `secrets`           | `false`   | Same as `configs` but values are masked out. Should be used in case if you link Azure Key Vault secrets to App Configuration configs. Values masked out, so they will be not printed to log. |

# Contributing
You are absolutely welcome to contribute, create suggestions and write about issues.