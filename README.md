# AzureArbeidskrav2: Terraform-prosjekt for webserver tilkoblet til database i Azure

Terraform-prosjekt som oppretter en VM med webtjeneste og 2 VM med database i lastbalansering

## Struktur

- **`main.tf`**: Hovedkonfigurasjonsfilen
- **`variables.tf`**: Definerer variabler

## Instruksjoner for oppsett

### Forutsetninger

- Installert [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
- Azure-konto med nødvendige rettigheter.
- Installert [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli) og autentisert med `az login`.

### Nedlastning og oppsett

1. **NEDLASTNING**:
- Last ned prosjektet som zip og pakk ut.
2. **KJØRE TERRAFORM VIA POWERSHELL**
- Det kan hende at man ikke klarer å logge inn med `az login`, men da følger man instruksjonene som dukker opp i Powershell.
  ```powershell
  cd <stien til Terraform-mappen>
  az login (Når du har sukksesfult logget inn med az login vill din Subscription ID bli vist i kommano feltet ditt,
  denne IDen må du kopiere og legge inn i root main.tf filen.
  Øverst i den main.tf filen ligger det et felt for subscription_id der må du lime inn din ID.)
  
  terraform init
  terraform plan
  terraform apply
  ```
- Det kan hende at man får en feilmelding relatert til MariaDB installasjon, men da kan man slette ressursene i Azure og prøve å kjøre Terraform på nytt.
3. **BENYTTE PROSJEKTET**
- Skriv den offentlige IP-adressen som står i `publ_ipadd = "<IP-adresse>"` som dukker opp på bunnen av cmd etter terraform apply er kjørt i en nettleser for å få vise nettsiden som har kontakt med databasen.
  - Det kan hende at det tar litt tid før nettsiden som henter data fra databasen er ferdig satt opp.
- Skriv `terraform output admin_password` for å vise passordet til adminbrukeren.
- For å koble til webserveren via SSH:
  ```powershell
  ssh <admin_username>@<offentlige IP-adressen> -i .ssh/id_rsa 
  ```
- For å koble til DB-serverne via SSH fra webserver:
  Du kan ssh inn til database serverne ved å laste opp den samme private keyen til webservern.
  ```
  scp .ssh/id_rsa  <admin_username>@<offentlige ip adressen>:/home/<admin_username>/id_rsa
  ssh <admin_username>@<offentlige IP-adressen> -i .ssh/id_rsa
  ssh <db_username>@<privat ip adresse db server> -i id_rsa
  ```
  Privat IP adresse på DB server er 10.0.0.6 og 10.0.0.7
4. **ELIMINERE RESSURSER ETTER OPPSETT**
- Destroy for prosjektet:
  ```powershell 
  terraform destroy
  ```
