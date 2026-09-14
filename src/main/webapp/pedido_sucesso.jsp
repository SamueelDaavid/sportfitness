<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pedido Confirmado | SportFitness</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --sf-purple: #8000ff;
            --sf-purple-dark: #5b00b8;
            --sf-green-tag: #ccff00;
            --sf-text: #333333;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background-color: #f8f9fa; color: var(--sf-text); display: flex; flex-direction: column; min-height: 100vh; justify-content: center; align-items: center; }
        
        .success-card {
            background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            text-align: center; max-width: 500px; width: 90%;
        }
        .success-icon {
            font-size: 4rem; color: #28a745; margin-bottom: 20px;
        }
        h1 { font-size: 1.5rem; font-weight: 800; color: #222; margin-bottom: 10px; text-transform: uppercase; }
        p { color: #666; font-size: 0.95rem; margin-bottom: 30px; line-height: 1.5; }
        
        .btn-home {
            background: var(--sf-purple); color: white; padding: 12px 25px; border-radius: 4px;
            text-decoration: none; font-weight: bold; text-transform: uppercase; font-size: 0.9rem;
            display: inline-block; transition: background 0.2s;
        }
        .btn-home:hover { background: var(--sf-purple-dark); }
    </style>
</head>
<body>

    <div class="success-card">
        <i class="fa-solid fa-circle-check success-icon"></i>
        <h1>Pedido confirmado!</h1>
        <p>Sua compra foi realizada com sucesso. Já estamos processando o seu pedido e em breve você receberá atualizações.</p>
        <a href="index.jsp" class="btn-home"><i class="fa-solid fa-arrow-left"></i> Voltar à Página Inicial</a>
    </div>

</body>
</html>