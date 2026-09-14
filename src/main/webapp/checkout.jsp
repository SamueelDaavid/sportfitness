<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sportfitness.model.ItemCarrinho" %>
<%
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    String usuarioNome = (String) session.getAttribute("usuarioNome");
    List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");

    if (usuarioId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (carrinho == null || carrinho.isEmpty()) {
        response.sendRedirect("carrinho.jsp");
        return;
    }

    double totalGeral = 0.0;
    for (ItemCarrinho item : carrinho) {
        totalGeral += item.getSubtotal();
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Finalizar Compra | SportFitness</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background: #f5f5f5; color: #333; }
        
        header { background: #8000ff; color: white; padding: 15px 8%; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.8rem; font-weight: 800; font-style: italic; color: white; text-decoration: none; }
        .logo span { color: #ccff00; }

        .container { max-width: 1000px; margin: 30px auto; display: flex; gap: 20px; }
        .checkout-section { flex: 2; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .summary-section { flex: 1; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); height: fit-content; }

        h2 { font-size: 1.3rem; margin-bottom: 20px; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: 600; margin-bottom: 5px; font-size: 0.9rem; }
        .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 0.95rem; }

        .cart-summary-item { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 0.9rem; }
        .total-price { font-size: 1.5rem; font-weight: 800; color: #8000ff; margin-top: 15px; border-top: 1px solid #eee; padding-top: 10px; }

        .btn-pay { background: #ccff00; color: #000; font-weight: 800; padding: 14px; border: none; border-radius: 4px; cursor: pointer; text-transform: uppercase; font-size: 1rem; width: 100%; margin-top: 15px; }
        .btn-pay:hover { background: #b3e600; }
    </style>
</head>
<body>

    <header>
        <a href="index.jsp" class="logo">SPORT<span>FITNESS</span></a>
        <div><i class="fa-regular fa-user"></i> Olá, <%= usuarioNome %></div>
    </header>

    <form action="checkout" method="POST">
        <div class="container">
            <!-- Formulário de Endereço e Pagamento -->
            <div class="checkout-section">
                <h2><i class="fa-solid fa-truck"></i> Endereço de Entrega</h2>
                <div class="form-group">
                    <label>Endereço Completo</label>
                    <input type="text" name="endereco" placeholder="Rua, Número e Bairro" required>
                </div>
                <div style="display: flex; gap: 10px;">
                    <div class="form-group" style="flex: 2;">
                        <label>Cidade</label>
                        <input type="text" name="cidade" required>
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label>CEP</label>
                        <input type="text" name="cep" placeholder="00000-000" required>
                    </div>
                </div>

                <h2><i class="fa-solid fa-credit-card"></i> Forma de Pagamento</h2>
                <div class="form-group">
                    <select name="formaPagamento" required>
                        <option value="pix">PIX (Aprovação Instantânea)</option>
                        <option value="cartao">Cartão de Crédito</option>
                        <option value="boleto">Boleto Bancário</option>
                    </select>
                </div>
            </div>

            <!-- Resumo do Pedido -->
            <div class="summary-section">
                <h2><i class="fa-solid fa-receipt"></i> Resumo</h2>
                <% for (ItemCarrinho item : carrinho) { %>
                    <div class="cart-summary-item">
                        <span><%= item.getQuantidade() %>x <%= item.getNome() %></span>
                        <strong>R$ <%= String.format("%.2f", item.getSubtotal()) %></strong>
                    </div>
                <% } %>
                <div class="total-price">
                    Total: R$ <%= String.format("%.2f", totalGeral) %>
                </div>
                <button type="submit" class="btn-pay">Confirmar e Pagar</button>
            </div>
        </div>
    </form>

</body>
</html>