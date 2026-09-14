# Documentação do Ambiente Azure para a aplicação SportFitness

O **SportFitness** é uma aplicação que utiliza `JSP - Java Server Pages` e web server Apache Tomcat, com a finalidade de e-commerce de produtos esportivos e itens performance de um modo geral. Inicialmente, a estutura era hospedada em servidor on-premises atendendo a demanda local inicial. Neste projeto, com a arquitetura atualizada e voltada a ambientes  modernos com capacidade de atender às variações de demanda de forma dinâmica e escalável, será provisionada em ambiente Microsoft Azure usando **Terraform** como ferramenta de criação dos recursos. O projeto foi desenhado para ser portável e automatizado, separando a infraestrutura da aplicação, contendo uma esteira de CI/CD do **GitHub Actions** para gerenciar o build e o deploy do código diretamente para o App Service a cada atualização.

---

## Estrutura do Repositório

* main.tf: Código unificado de infraestrutura como código (IaC).
* variables.tf: Definição das variáveis de entrada do Terraform.
* output.tf: Usado para exibir as URLs da aplicação, banco e o nome dos recursos criados.
* init.sql: Script do banco contendo os comandos SQL necessários para criar a estrutura (tabelas, foreign keys e restrições) que o banco de dados utilizará.

## Arquitetura dos Componentes

* **Azure Resource Group**: Agrupamento lógico que contém os recursos da aplicação (`${var.prefix}-rg`).
* **Azure Storage Account & Container**: Armazenamento em nuvem responsável por receber os arquivos de backup gerados.
* **MySQL Flexible Server (v5.7)**: Banco de dados relacional, versão usada no projeto.
* **App Service Plan & Web App**: Ambiente de hospedagem da aplicação, e a aplicação em si.
* **Azure Container App Job**: Rotina automatizada agendada para realizar o dump do banco e salvá-lo no Storage Account.

---

## Descrição dos blocos do código (`main.tf`)

* **Provider e Resource Group (Bloco 1)**: Inicializa o provider do Azure (`azurerm`) e cria o Resource Group (`azurerm_resource_group.rg`) utilizando as variáveis com prefixo e localização definidas no projeto.
* **Storage Account e Container (Blocos 2 e 3)**: Cria o Storage Account (`azurerm_storage_account.storage`) e o Container Blob (`azurerm_storage_container.container`) para gerenciar os arquivos de backup.
* **Servidor e o banco de dados (Bloco 4 e 5)**: Provisiona a instância do MySQL Flexible Server (`azurerm_mysql_flexible_server.mysql`) com o SKU `B_Standard_B1s` e o banco de dados (`azurerm_mysql_flexible_database.database.name`) que será utilizado pela aplicação para consulta e armazenamento dos dados do cliente e suas transações.
* **App Service Plan (Bloco 6)**: Configura o ambiente de hospedagem Linux (`azurerm_service_plan.plan`) sob o SKU `B1`, para a execução do web serber Apache Tomcat.
* **App Service (Bloco 7)**: Cria o Web App (`azurerm_linux_web_app.app`) configurado para Java 17 e Tomcat 10. No bloco de `app_settings`, injeta as credenciais do banco de dados.
* **Container App Environment e Job de Backup (Blocos 8 e 9)**: Configura o ambiente de Containers (`azurerm_container_app_environment.env`) e agenda a execução diária, às 3h da manhã (`cron 0 3 * * *`) de um Container App Job (`azurerm_container_app_job.backup_job`). Ele consome a imagem pública do Docker (`samueeldaavid/backup-do-banco:latest`) passando todas as variáveis de conexão do banco e do Storage Account necessárias para realizar o dump automatizado.

---

### Variáveis Necessárias (`variables.tf`)

Para o funcionamento correto do código, o arquivo de variáveis deve conter:

* `prefix`: Prefixo alfanumérico para padronizar os nomes dos recursos.
* `location`: Região padrão do Azure (ex: `eastus`).
* `location-db`: Região específica para o banco de dados.
* `location-app`: Região específica para o App Service.
* `db_admin_login`: Nome de usuário administrador do MySQL.
* `db_admin_password`: Senha forte do administrador do MySQL.

Obs.: As variáveis de credenciais estão em formato `sensitive`, sendo necessário informá-las no momento da execução do código.

---

## Passo a Passo para Execução

1. Abra o terminal na pasta do projeto e inicialize os provedores:


```bash
terraform init

```


2. Valide o planejamento da infraestrutura e informe as variáveis exigidas:
```bash
terraform plan

```


3. Execute o provisionamento completo do ambiente de ponta a ponta:
```bash
terraform apply

```

5. Após o término da execução do código e com o servidor MySQL ativo, será necessário criar a estrutura inicial das tabelas (usuarios, pedidos e itens_pedido) no banco. Para isso, siga os seguintes passos:

1. Adicione uma exceção no Firewall do banco de dados. Na aba `Networking`, vá até a área `Firewall rule name` e adicione o IP do dispositivo que irá acessar o banco. Caso esteja acessando do mesmo dispositivo que está acessando o portal, basta clicar em `+ Add current client IP address (seu_ip)`
2. Execute o script `init.sql` diretamente no banco recém-criado usando uma ferramenta de gerenciamento de banco de dados (DBeaver, MySQL Workbench) ou via MySQL CLI usando este comando (necessário ter o `MySQL Command Line` Client instalado):

```bash
mysql -h <fqdn_do_banco> -u <usuario> -p<senha> -P 3306 <nome_do_banco> < <init.sql>

```

## Configuração da Esteira de CI/CD (GitHub Actions)

Para automatizar o deploy da aplicação diretamente no ambiente provisionado, ou sempre que houver um `push` na branch `main`, configure o repositório do código utilizando o Publish Profile do App Service:

---

### Passo 1: Baixar o Publish Profile no Azure

1. Acesse o **Portal do Azure**.
2. Vá até o seu **Web App** recém-criado pelo Terraform.
3. Na página **Visão Geral (Overview)**, clique no botão **"Baixar perfil de publicação"** (`Download publish profile`).
4. Um arquivo com a extensão `.PublishSettings` será baixado para o seu computador. Abra-o com um editor de texto (Obs.: O arquivo baixado contém credenciais de acesso ao seu Web App. Não compartilhe este arquivo publicamente!).

---

### Passo 2: Configurar os Secrets no GitHub
 
No repositório do seu código-fonte no GitHub, adicione as credenciais de acesso:
 
1. Acesse o seu repositório e clique na aba **Settings** (Configurações).
2. No menu lateral esquerdo, vá em **Secrets and variables** $\rightarrow$ **Actions**.
3. Clique em **New repository secret** e adicione os seguintes segredos:

* **Secret 1:**
  * **Name:** `AZURE_WEBAPP_PUBLISH_PROFILE`
  * **Secret:** Cole **todo** o conteúdo do arquivo `.PublishSettings` copiado no Passo 1.

* **Secret 2:**
  * **Name:** `AZURE_WEBAPP_NAME`
  * **Secret:** O nome exato do seu Web App no Azure (ex: `app-sportfitness-prod`, sem o sufixo `.azurewebsites.net`).

---

---

### Passo 3: Executar o Deploy 

1. No GitHub, vá até a aba **Actions**
2. No menu lateral, clique em **Build e Deploy da aplicação Java para o App Services**
3. Clique no botão **Run workflow**
4. Clique no botão verde **Run workflow**

Neste momento, a Build da aplicação e o Deploy no App Service será iniciado.

5. Aguarde o workflow executar.

---


## Conclusão

Parabéns! Você concluiu o deploy da aplicação Sportfitness. Agora você tem uma aplicação web hospedada no Azure App Service, com deploy automático via GitHub (push = deploy)

---