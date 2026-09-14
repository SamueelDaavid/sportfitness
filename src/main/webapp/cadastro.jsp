<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>SportFitness - Cadastro</title>    
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --sf-purple: #8000ff;
            --sf-green-tag: #ccff00;
        }

        body { font-family: 'Open Sans', Arial, sans-serif; background-color: #f4f4f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 320px; text-align: center; }

        .logo { font-size: 1.8rem; font-weight: 800; font-style: italic; color: var(--sf-purple); text-decoration: none; display: inline-block; margin-bottom: 15px; }
        .logo span { color: #a3d900; } /* Ajustado para melhor contraste em fundo branco se necessário, ou use var(--sf-green-tag) */

        h2 { margin-top: 0; text-align: center; color: #333; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; color: #666; font-size: 14px; }
        input[type="text"], input[type="email"], input[type="password"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background-color: #28a745; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; }
        button:hover { background-color: #218838; }
        .erro { color: red; text-align: center; font-size: 14px; margin-bottom: 10px; }
        .login-link { text-align: center; margin-top: 15px; font-size: 14px; }
        .login-link a { color: var(--sf-purple); text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

<div class="card">
    <a href="index.jsp" class="logo">SPORT<span>FITNESS</span></a>
    <h2>Criar Conta</h2>

    <% if ("1".equals(request.getParameter("erro"))) { %>
        <p class="erro">Por favor, preencha todos os campos.</p>
    <% } else if ("db".equals(request.getParameter("erro"))) { %>
        <p class="erro">Erro ao cadastrar. E-mail já utilizado ou erro no banco.</p>
    <% } %>

    <form action="cadastro" method="post">
        <div class="form-group">
            <label for="nome">Nome Completo</label>
            <input type="text" id="nome" name="nome" required>
        </div>
        <div class="form-group">
            <label for="email">E-mail</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="senha">Senha</label>
            <input type="password" id="senha" name="senha" required>
        </div>
        <button type="submit">Cadastrar</button>
    </form>

    <div class="login-link">
        Já tem uma conta? <a href="login.jsp">Faça login</a>
    </div>
</div>

</body>
</html>