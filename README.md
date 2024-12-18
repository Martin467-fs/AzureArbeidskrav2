# AzureArbeidskrav2: Terraform-prosjekt for webserver tilkoblet til database i Azure

Terraform-prosjekt som oppretter en VM med webtjeneste og 2 VM med database i lastbalansering

## Struktur

- **`main.tf`**: Hovedkonfigurasjonsfilen
- **`variables.tf`**: Definerer variabler
- **`variables.tfvars`**: Variabler ment til å endres av bruker

## Instruksjoner for oppsett

### Forutsetninger

- Installert [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
- Azure-konto med nødvendige rettigheter.
- Installert [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli) og autentisert med `az login`.

### Nedlastning og oppsett

1. **NEDLASTNING**:
- Last ned prosjektet som zip og pakk ut.
2. **ENDRINGER**
- Gjør nødvendige endringer i **`variables.tfvars`**
- Endringer som må gjøres manuelt:
  - Linje 6 og 7 i **`modules/db-install/scripts/install_mariadb.sh`** må ha lik verdi som `admin_username` og `admin_password` i **`terraform.tfvars`**
  - Linje 64 og 65 i **`modules/db-install/scripts/playbook.yml`** må ha lik verdi som `admin_username` og `admin_password` i **`terraform.tfvars`**
3. **KJØRE TERRAFORM VIA POWERSHELL**
- Det kan hende at man ikke klarer å logge inn med `az login`, men da følger man instruksjonene som dukker opp i Powershell.
  ```powershell
  cd <stien til Terraform-mappen>
  az login
  terraform init
  terraform plan
  terraform apply
  ```
- Det kan hende at man får en feilmelding relatert til MariaDB installasjon, men da kan man slette ressursene i Azure og prøve å kjøre Terraform på nytt.
4. **BENYTTE PROSJEKTET**
- Skriv den offentlige IP-adressen som står i `oubl_ipadd = "<IP-adresse>"` som dukker opp på bunnen av cmd etter terraform apply er kjørt i en nettleser for å få vise nettsiden som har kontakt med databasen.
  - Det kan hende at det tar litt tid før nettsiden som henter data fra databasen er ferdig satt opp.
- Skriv `terraform output admin_password` for å vise passordet til adminbrukeren.
- For å koble til webserveren via SSH:
  ```powershell
  ssh <admin_username>@<offentlige IP-adressen>
  <admin_username>@<offentlige IP-adressen> password: <admin_password>
  ```
- For å koble til DB-serverne via SSH fra webserver:
  ```powershell
  ssh <admin_username>@<IP-adressen til VM>
  <admin_username>@<IP-adressen til VM> password: <admin_password>
  ```
5. **ELIMINERE RESSURSER ETTER OPPSETT**
- Plan og apply destroy for prosjektet:
  ```powershell
  terraform plan -destroy -out main.destroy.tfplan
  terraform apply main.destroy.tfplan
  ```
