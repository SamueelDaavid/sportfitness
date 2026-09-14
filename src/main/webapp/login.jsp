<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>SportFitness - Login</title>
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
        
        h2 { margin-top: 0; margin-bottom: 20px; color: #333; font-size: 1.3rem; }
        .form-group { margin-bottom: 15px; text-align: left; }
        label { display: block; margin-bottom: 5px; color: #666; font-size: 14px; }
        input[type="email"], input[type="password"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        button { width: 100%; padding: 10px; background-color: var(--sf-purple); color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; font-family: 'Open Sans', sans-serif; transition: background 0.2s; }
        button:hover { background-color: #5b00b8; }
        .erro { color: red; text-align: center; font-size: 14px; margin-bottom: 10px; }
        .cadastro-link { text-align: center; margin-top: 15px; font-size: 14px; }
        .cadastro-link a { color: var(--sf-purple); text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

<div class="card">
    <a href="index.jsp" class="logo">SPORT<span>FITNESS</span></a>
    <h2>Entrar na Conta</h2>

    <% if ("1".equals(request.getParameter("erro"))) { %>
        <p class="erro">E-mail ou senha incorretos.</p>
    <% } else if ("db".equals(request.getParameter("erro"))) { %>
        <p class="erro">Erro ao conectar com o banco de dados.</p>
    <% } %>

    <form action="login" method="post">
        <div class="form-group">
            <label for="email">E-mail</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="senha">Senha</label>
            <input type="password" id="senha" name="senha" required>
        </div>
        <button type="submit">Entrar</button>
    </form>

    <div class="cadastro-link">
        Ainda não tem conta? <a href="cadastro.jsp">Cadastre-se</a>
    </div>
</div>

</body>
</html>