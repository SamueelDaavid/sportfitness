<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sportfitness.model.ItemCarrinho" %>
<%
    String usuarioNome = (String) session.getAttribute("usuarioNome");
    List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
    double totalGeral = 0.0;
    if (carrinho != null) {
        for (ItemCarrinho item : carrinho) {
            totalGeral += item.getSubtotal();
        }
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Meu Carrinho | SportFitness</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background: #f5f5f5; color: #333; }
        
        header { background: #8000ff; color: white; padding: 15px 8%; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.8rem; font-weight: 800; font-style: italic; color: white; text-decoration: none; }
        .logo span { color: #ccff00; }

        .container { max-width: 1000px; margin: 30px auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { font-size: 1.5rem; margin-bottom: 20px; border-bottom: 2px solid #eee; padding-bottom: 10px; }

        .cart-item { display: flex; align-items: center; justify-content: space-between; padding: 15px 0; border-bottom: 1px solid #eee; gap: 15px; }
        .img-wrapper-cart { width: 80px; height: 80px; min-width: 80px; border-radius: 4px; overflow: hidden; background: #eee; }
        .cart-item img { width: 100%; height: 100%; object-fit: cover; }
        .item-info { flex: 1; }
        .item-title { font-weight: bold; font-size: 0.95rem; margin-bottom: 6px; }
        .item-price { color: #8000ff; font-weight: 800; font-size: 1.1rem; }

        .qty-controls { display: flex; align-items: center; gap: 8px; margin-top: 5px; }
        .qty-btn { background: #eee; border: none; width: 25px; height: 25px; border-radius: 4px; font-weight: bold; cursor: pointer; display: flex; align-items: center; justify-content: center; text-decoration: none; color: #333; }
        .qty-btn:hover { background: #ddd; }
        
        .btn-trash { background: none; border: none; color: #ff4d4d; cursor: pointer; font-size: 1rem; padding: 5px; }
        .btn-trash:hover { color: #cc0000; }

        .summary { margin-top: 25px; text-align: right; background: #fafafa; padding: 20px; border-radius: 6px; }
        .total-price { font-size: 1.6rem; font-weight: 800; color: #111; margin: 10px 0; }

        .btn-checkout { background: #ccff00; color: #000; font-weight: 800; padding: 12px 30px; border: none; border-radius: 4px; cursor: pointer; text-transform: uppercase; font-size: 1rem; text-decoration: none; display: inline-block; }
        .btn-checkout:hover { background: #b3e600; }
        .btn-continue { color: #8000ff; text-decoration: none; font-weight: bold; margin-right: 20px; }
    </style>
</head>
<body>

    <header>
        <a href="index.jsp" class="logo">SPORT<span>FITNESS</span></a>
        <div><i class="fa-regular fa-user"></i> <%= (usuarioNome != null) ? "Olá, " + usuarioNome : "<a href='login.jsp' style='color:white;'>Entrar</a>" %></div>
    </header>

    <div class="container">
        <h2><i class="fa-solid fa-cart-shopping"></i> Seu Carrinho de Compras</h2>

        <% if (carrinho == null || carrinho.isEmpty()) { %>
            <p style="padding: 40px 0; text-align: center;">Seu carrinho está vazio.</p>
            <div style="text-align: center;">
                <a href="index.jsp" class="btn-checkout">Voltar às Compras</a>
            </div>
        <% } else { %>
            <% for (ItemCarrinho item : carrinho) { %>
                <div class="cart-item">
                    <div class="img-wrapper-cart">
                        <img src="<%= (item.getImagemUrl() != null && !item.getImagemUrl().isEmpty()) ? item.getImagemUrl() : "images/sem-foto.jpg" %>" alt="<%= item.getNome() %>">
                    </div>
                    <div class="item-info">
                        <div class="item-title"><%= item.getNome() %></div>
                        <div class="qty-controls">
                            <span>Qtd:</span>
                            <a href="carrinho?acao=diminuir&nome=<%= java.net.URLEncoder.encode(item.getNome(), "UTF-8") %>" class="qty-btn">-</a>
                            <strong><%= item.getQuantidade() %></strong>
                            <a href="carrinho?acao=aumentar&nome=<%= java.net.URLEncoder.encode(item.getNome(), "UTF-8") %>" class="qty-btn">+</a>
                        </div>
                    </div>
                    <div class="item-price">R$ <%= String.format("%.2f", item.getSubtotal()) %></div>
                    <a href="carrinho?acao=remover&nome=<%= java.net.URLEncoder.encode(item.getNome(), "UTF-8") %>" class="btn-trash" title="Remover item"><i class="fa-solid fa-trash-can"></i></a>
                </div>
            <% } %>

            <div class="summary">
                <div>Total a Pagar:</div>
                <div class="total-price">R$ <%= String.format("%.2f", totalGeral) %></div>

                <a href="index.jsp" class="btn-continue">Continuar Comprando</a>
                <a href="checkout.jsp" class="btn-checkout">Ir para o Pagamento &gt;</a>
            </div>
        <% } %>
    </div>

</body>
</html>