# SportFitness - Documentação da Aplicação & Backend

Repositório do projeto e-commerce **SportFitness**, plataforma web de comercialização de produtos esportivos.

---

## 🏗️ Visão Geral e Arquitetura

O **SportFitness** opera como uma aplicação web robusta desenvolvida em **Java (Servlets & JSPs)**, projetada e organizada em camadas entre a interface de usuário, a lógica de controle de negócios e a persistência de dados.

Na camada de apresentação, páginas JSP dinâmicas entregam a vitrine do e-commerce para os clientes, desde a exibição de produtos esportivos até o fluxo de carrinho e fechamento de pedidos. Por trás da interface, os Servlets atuam como controladores que processam a autenticação, sessões de usuário e as transações de compra. A ponte com o banco de dados é realizada utilizando o driver JDBC gerenciado pelas dependências no Maven, integrando a aplicação ao banco.

### Stack Tecnológica
* **Linguagem:** Java (JDK 17+)
* **Tecnologia Web:** Servlets & JavaServer Pages (JSP)
* **Gerenciamento de Dependências:** Apache Maven (`pom.xml`)
* **Banco de Dados:** MySQL

---

## 📁 Estrutura do Repositório (`src/`)

```text
sportfitness/
├── pom.xml                                     <-- Configuração do Maven (bibliotecas e dependências)
└── src/
    └── main/
        ├── java/
        │   └── com/
        │       └── sportfitness/
        │           ├── model/
        │           │   └── ItemCarrinho.java    <-- Representa os itens adicionados ao carrinho
        │           ├── servlet/
        │           │   ├── CadastroServlet.java      <-- Processa o cadastro de novos usuários
        │           │   ├── CarrinhoServlet.java      <-- Gerencia os produtos no carrinho
        │           │   ├── CheckoutServlet.java      <-- Prepara a tela de fechamento da compra
        │           │   ├── FinalizarCompraServlet.java <-- Grava o pedido definitivo no banco
        │           │   ├── LoginServlet.java         <-- Autentica o usuário no sistema
        │           │   └── LogoutServlet.java        <-- Encerra a sessão do usuário
        │           └── util/
        │               └── ConexaoDB.java        <-- Faz a ponte (conexão) com o banco de dados
        └── webapp/
            ├── WEB-INF/
            │   └── web.xml                       <-- Configuração central do roteamento web
            ├── index.jsp                         <-- Página principal (vitrine da loja)
            ├── cadastro.jsp                      <-- Tela de cadastro de clientes
            ├── carrinho.jsp                      <-- Tela de revisão do carrinho de compras
            ├── login.jsp                         <-- Tela de acesso do usuário
            ├── pedido_sucesso.jsp                <-- Confirmação de compra finalizada
            └── checkout.jsp                      <-- Tela para preencher dados de pagamento/entrega
````

A Main Page (.jsp): O cliente entra em index.jsp, clica em se cadastrar (cadastro.jsp) ou fazer login (login.jsp).

Os Controladores (servlet/): Quando o usuário clica em "Entrar" ou "Comprar", a requisição vai direto para os Servlets (como LoginServlet ou CarrinhoServlet). Eles recebem os dados, processam a lógica no Java e decidem o próximo passo.

Os Dados e Conexão (model/ e util/): Para salvar ou buscar coisas, os Servlets chamam o ConexaoDB.java, que agora está apontando diretamente para o banco de dados, utilizando classes como o ItemCarrinho.java para organizar os produtos.

---

## 🗄️ Esquema do Banco de Dados (MySQL)

```text
SQL
CREATE DATABASE IF NOT EXISTS sportfitness_db;
USE sportfitness_db;

CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    imagem_url VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE IF NOT EXISTS itens_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);
````

---

## 🔀 Rotas e Mapeamento de Servlets

O fluxo de navegação do e-commerce é controlado através dos endpoints processados pelos servlets:
```text
POST /cadastro (CadastroServlet): Processa os dados de cadastro.jsp e persiste o usuário no banco.

POST /login (LoginServlet): Valida credenciais informadas em login.jsp e inicializa a sessão HTTP.

GET /logout (LogoutServlet): Encerra a sessão ativa e redireciona o cliente para a vitrine (index.jsp).

POST /carrinho (CarrinhoServlet): Gerencia a inclusão/remoção de instâncias baseadas em ItemCarrinho.

GET /checkout (CheckoutServlet): Prepara as informações para a tela de revisão de pagamento (checkout.jsp).

POST /finalizar-compra (FinalizarCompraServlet): Efetiva a transação gravando o registro mestre na tabela pedidos e os itens associados em itens_pedido.
````
---

## ⚙️ Configuração e Execução Local

### Pré-requisitos: 

* Java JDK 17+, Apache Maven e MySQL configurados na máquina.
* Banco de Dados: Execute o script SQL acima em sua instância de banco.
* Dependência do Driver JDBC: O projeto utiliza o driver do MySQL (mysql-connector-j) para a comunicação via JDBC. Certifique-se de que a dependência está declarada no pom.xml ou que o arquivo .jar do driver está presente no pacote


---

Compilação e Empacotamento:

```text
mvn clean package
````

Deploy Local: Suba o arquivo gerado (.war) em um servidor compatível com Servlet (como Apache Tomcat) ou execute o projeto integrado à sua IDE de preferência.