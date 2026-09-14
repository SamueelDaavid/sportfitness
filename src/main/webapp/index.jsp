<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sportfitness.model.ItemCarrinho" %>
<%
    String usuarioNome = (String) session.getAttribute("usuarioNome");
    List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
    int totalItens = 0;
    if (carrinho != null) {
        for (ItemCarrinho item : carrinho) {
            totalItens += item.getQuantidade();
        }
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SportFitness | Artigos Esportivos e Performance</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --sf-purple: #8000ff;
            --sf-purple-dark: #5b00b8;
            --sf-pink: #d90077;
            --sf-green-tag: #ccff00;
            --sf-green-text: #00875a;
            --sf-text: #333333;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background-color: #fff; color: var(--sf-text); }

        /* HEADER E NAV */
        header { background-color: var(--sf-purple); color: white; }
        
        .top-nav-tabs {
            display: flex; gap: 5px; padding: 5px 8% 0 8%; background: var(--sf-purple-dark);
        }
        .tab-btn {
            background: rgba(255,255,255,0.2); color: white; padding: 4px 15px; border-radius: 4px 4px 0 0;
            font-size: 0.75rem; font-weight: bold; text-decoration: none;
        }
        .tab-btn.active { background: var(--sf-purple); }
        .top-right-links { margin-left: auto; font-size: 0.7rem; display: flex; gap: 15px; align-items: center; }

        .main-header {
            display: flex; align-items: center; justify-content: space-between; gap: 20px;
            padding: 10px 8%; background-color: var(--sf-purple);
        }
        .logo { font-size: 1.8rem; font-weight: 800; font-style: italic; color: white; text-decoration: none; }
        .logo span { color: var(--sf-green-tag); }

        .search-bar {
            flex: 1; max-width: 650px; position: relative; display: flex; align-items: center;
        }
        .search-bar input {
            width: 100%; padding: 8px 40px 8px 15px; border-radius: 20px; border: none; outline: none; font-size: 0.85rem;
        }
        .search-bar i { position: absolute; right: 15px; color: #666; cursor: pointer; }

        .header-user { display: flex; align-items: center; gap: 20px; font-size: 0.8rem; }
        .header-user div, .header-user a { cursor: pointer; display: flex; align-items: center; gap: 5px; color: white; text-decoration: none; }

        .sub-header {
            background: var(--sf-purple-dark); padding: 6px 8%; display: flex; align-items: center;
            justify-content: space-between; font-size: 0.75rem; color: white;
        }
        .nav-links { display: flex; gap: 18px; font-weight: 700; text-transform: uppercase; }

        .coupon-bar {
            background: linear-gradient(90deg, #9900ff, #e60073); color: white; text-align: center;
            padding: 6px; font-size: 0.85rem; font-weight: bold;
        }
        .coupon-badge { background: #fff; color: #000; padding: 2px 8px; border-radius: 12px; font-size: 0.75rem; margin: 0 5px; }

        /* HERO BANNER */
        .hero-banner {
            position: relative; height: 380px; color: white; display: flex; align-items: center; padding: 0 8%;
            background: linear-gradient(90deg, rgba(0,0,0,0.85) 0%, rgba(0,0,0,0.3) 60%, transparent 100%), 
                        url('https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=1600') center/cover no-repeat;
        }
        .hero-text { max-width: 500px; z-index: 2; }
        .hero-text h2 { font-size: 2.5rem; font-weight: 800; line-height: 1.1; margin-bottom: 15px; text-transform: uppercase; }
        .hero-text p { font-size: 1.1rem; margin-bottom: 20px; color: #e5e5e5; }
        .hero-btn {
            background: var(--sf-green-tag); color: black; padding: 12px 28px; font-weight: 800; border-radius: 4px;
            text-decoration: none; display: inline-block; text-transform: uppercase; font-size: 0.95rem; box-shadow: 0 4px 15px rgba(204,255,0,0.4);
            transition: transform 0.2s;
        }
        .hero-btn:hover { transform: scale(1.05); }

        /* SEÇÃO CONTAINERS */
        .section-container { padding: 30px 8%; }
        .deals-header {
            background: linear-gradient(90deg, #a000c8, #ff0055); color: white; padding: 12px 20px;
            display: flex; justify-content: space-between; align-items: center; border-radius: 4px 4px 0 0;
            font-weight: 800; font-size: 0.9rem; text-transform: uppercase;
        }
        .timer-box { background: #ff4700; padding: 4px 10px; border-radius: 4px; font-size: 0.85rem; letter-spacing: 1px; }

        .products-carousel { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-top: 15px; }
        .product-card {
            border: 1px solid #e5e5e5; border-radius: 6px; padding: 12px; position: relative;
            background: white; transition: box-shadow 0.2s; display: flex; flex-direction: column; justify-content: space-between;
        }
        .product-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .card-clock-icon { position: absolute; top: 10px; right: 10px; color: #ff5500; font-size: 1.1rem; z-index: 2; }
        .product-card .img-wrapper { width: 100%; height: 160px; border-radius: 4px; overflow: hidden; margin-bottom: 10px; cursor: pointer; }
        .product-card img { width: 100%; height: 100%; object-fit: cover; }
        .discount-tag { background-color: var(--sf-green-tag); color: #000; font-size: 0.7rem; font-weight: 800; padding: 2px 6px; display: inline-block; margin-bottom: 8px; align-self: flex-start; }
        .product-name { font-size: 0.78rem; font-weight: 600; color: #444; height: 36px; overflow: hidden; margin-bottom: 8px; }
        .old-price { font-size: 0.7rem; color: #888; text-decoration: line-through; }
        .main-price { font-size: 1.1rem; font-weight: 800; color: #111; }
        .installments { font-size: 0.68rem; color: #666; margin-bottom: 8px; }
        .btn-add-cart { width: 100%; background: var(--sf-purple); color: white; border: none; padding: 8px; border-radius: 4px; font-weight: bold; cursor: pointer; margin-top: 8px; transition: background 0.2s; }
        .btn-add-cart:hover { background: var(--sf-purple-dark); }

        /* RODAPÉ ESTILIZADO */
        footer { background: #f4f4f4; border-top: 1px solid #ddd; margin-top: 40px; font-size: 0.75rem; color: #555; }
        
        .footer-top-searches {
            background: #fff; padding: 20px 8%; border-bottom: 1px solid #eaeaea; text-align: center;
        }
        .footer-top-searches h4 { font-size: 0.8rem; text-transform: uppercase; color: #333; margin-bottom: 15px; font-weight: 700; letter-spacing: 0.5px; }
        .searches-grid {
            display: grid; grid-template-columns: repeat(5, 1fr); gap: 10px; text-align: left; font-size: 0.7rem;
        }
        .searches-col a { display: block; color: #666; text-decoration: none; margin-bottom: 6px; }
        .searches-col a:hover { color: var(--sf-purple); text-decoration: underline; }

        .benefits-bar { display: flex; justify-content: space-around; padding: 20px 8%; background: #f9f9f9; border-bottom: 1px solid #eee; text-align: center; }
        .benefit-item { display: flex; align-items: center; gap: 10px; }
        .benefit-item i { font-size: 1.8rem; color: #444; }
        .benefit-text strong { display: block; text-transform: uppercase; font-size: 0.8rem; color: #222; }

        .footer-main-links {
            display: grid; grid-template-columns: 1.2fr 1.2fr 1.2fr 1.2fr 1.5fr 1fr; gap: 20px; padding: 30px 8%; background: #f4f4f4;
        }
        .footer-col h5 { font-size: 0.8rem; text-transform: uppercase; color: #222; margin-bottom: 12px; font-weight: 700; }
        .footer-col ul { list-style: none; }
        .footer-col ul li { margin-bottom: 8px; }
        .footer-col ul li a { color: #666; text-decoration: none; }
        .footer-col ul li a:hover { color: var(--sf-purple); text-decoration: underline; }

        .footer-support-btn {
            background: transparent; border: 1px solid var(--sf-purple); color: var(--sf-purple);
            padding: 6px 12px; border-radius: 4px; font-weight: bold; cursor: pointer; text-transform: uppercase;
            font-size: 0.7rem; margin-bottom: 15px; display: inline-block; text-decoration: none; text-align: center;
        }
        .footer-support-btn:hover { background: var(--sf-purple); color: #fff; }

        .footer-socials { display: flex; gap: 10px; margin-bottom: 15px; }
        .footer-socials a {
            background: #333; color: #fff; width: 28px; height: 28px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center; text-decoration: none; font-size: 0.8rem;
        }
        .footer-socials a:hover { background: var(--sf-purple); }

        .app-badge-box { display: flex; align-items: center; gap: 10px; margin-top: 10px; }
        .app-badge-box i { font-size: 1.8rem; color: #333; }
        .app-badge-box span { font-size: 0.65rem; color: #666; display: block; }
        .app-badge-box strong { font-size: 0.75rem; color: #222; display: block; }

    </style>
</head>
<body>

    <header>
        <div class="top-nav-tabs">
            <a href="index.jsp" class="tab-btn active">SportFitness</a>
            <a href="#" class="tab-btn">S FIT<sup>PRO</sup></a>
            <div class="top-right-links">
                <span><i class="fa-solid fa-child-reaching"></i> Acessibilidade</span>
                <span><i class="fa-regular fa-circle-question"></i> Tire suas dúvidas</span>
            </div>
        </div>

        <div class="main-header">
            <a href="index.jsp" class="logo">SPORT<span>FITNESS</span></a>
            <div class="search-bar">
                <input type="text" placeholder="O que você está procurando hoje?">
                <i class="fa-solid fa-magnifying-glass"></i>
            </div>
            <div class="header-user">
                <div><i class="fa-regular fa-heart"></i> Favoritos</div>
                <div style="display: flex; align-items: center; gap: 8px;">
                    <i class="fa-regular fa-user" style="font-size: 1.1rem;"></i> 
                    <% if (usuarioNome != null) { %>
                        <span>Olá, <%= usuarioNome %></span>
                        <a href="logout" style="font-size: 0.75rem; color: #ffcccc; text-decoration: underline; margin-left: 4px;">(Sair)</a>
                    <% } else { %>
                        <a href='login.jsp'>Entrar / Cadastrar</a>
                    <% } %>
                </div>
                <a href="carrinho.jsp" style="position: relative;">
                    <i class="fa-solid fa-cart-shopping" style="font-size: 1.2rem;"></i> 
                    <span style="position: absolute; top:-8px; right:-8px; background:var(--sf-green-tag); color:#000; font-weight:bold; font-size:0.65rem; border-radius:50%; width:15px; height:15px; text-align:center;"><%= totalItens %></span>
                </a>
            </div>
        </div>

        <div class="sub-header">
            <div class="nav-links">
                <span><i class="fa-solid fa-bars"></i> Todas as categorias</span>
                <span>Corrida</span>
                <span>Futebol</span>
                <span>Sportstyle</span>
                <span>Saúde e Bem Estar</span>
            </div>
            <div><i class="fa-solid fa-location-dot"></i> Enviar para: <strong>20005-001, Rio de Janeiro</strong></div>
        </div>

        <div class="coupon-bar">
            +10% OFF na primeira compra, usando o cupom <span class="coupon-badge">PRIMEIRA10</span>
        </div>
    </header>

    <!-- BANNER PRINCIPAL -->
    <div class="hero-banner">
        <div class="hero-text">
            <h2>Sua Performance<br>Sem Limites</h2>
            <p>Conheça a nova linha de calçados de alta tecnologia da KINETIX.</p>
            <a href="#vitrine" class="hero-btn">COMPRE AGORA &gt;</a>
        </div>
    </div>

    <!-- OFERTAS DO DIA -->
    <div class="section-container" id="vitrine">
        <div class="deals-header">
            <span><i class="fa-regular fa-clock"></i> Ofertas do Dia</span>
            <div>Aproveite! Essa oferta acaba em: <span class="timer-box" id="timer">06 : 05 : 35</span></div>
        </div>

        <div class="products-carousel">
            <!-- Tênis 1 (Antigo) -->
            <div class="product-card">
                <form action="carrinho" method="POST">
                    <input type="hidden" name="id" value="1">
                    <input type="hidden" name="nome" value="Tênis KINETIX Red Velocity Masculino">
                    <input type="hidden" name="preco" value="209.94">
                    <input type="hidden" name="imagem_url" value="https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=400">

                    <i class="fa-regular fa-clock card-clock-icon"></i>
                    <div class="img-wrapper" onclick="this.closest('form').submit();">
                        <img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=400" alt="Tênis Vermelho">
                    </div>
                    <div class="discount-tag">-21% OFF</div>
                    <div class="product-name">Tênis KINETIX Red Velocity Masculino</div>
                    <div class="old-price">R$ 279,90</div>
                    <div class="main-price">R$ 209,94 <span style="font-size: 0.7rem;">no Pix</span></div>
                    <div class="installments">ou 3x de R$ 73,66</div>

                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Comprar</button>
                </form>
            </div>

            <!-- Novo Produto 1: Kit Halteres -->
            <div class="product-card">
                <form action="carrinho" method="POST">
                    <input type="hidden" name="id" value="5">
                    <input type="hidden" name="nome" value="Kit Halteres Ajustáveis Pro 20kg">
                    <input type="hidden" name="preco" value="349.90">
                    <input type="hidden" name="imagem_url" value="https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?q=80&w=400">

                    <i class="fa-regular fa-clock card-clock-icon"></i>
                    <div class="img-wrapper" onclick="this.closest('form').submit();">
                        <img src="https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?q=80&w=400" alt="Kit Halteres">
                    </div>
                    <div class="discount-tag">-30% OFF</div>
                    <div class="product-name">Kit Halteres Ajustáveis Pro 20kg</div>
                    <div class="old-price">R$ 499,90</div>
                    <div class="main-price">R$ 349,90 <span style="font-size: 0.7rem;">no Pix</span></div>
                    <div class="installments">ou 5x de R$ 73,80</div>

                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Comprar</button>
                </form>
            </div>

            <!-- Tênis 2 (Antigo) -->
            <div class="product-card">
                <form action="carrinho" method="POST">
                    <input type="hidden" name="id" value="2">
                    <input type="hidden" name="nome" value="Tênis VOLTIX Runner Dynamic Unisex">
                    <input type="hidden" name="preco" value="132.99">
                    <input type="hidden" name="imagem_url" value="https://images.unsplash.com/photo-1560769629-975ec94e6a86?q=80&w=400">

                    <i class="fa-regular fa-clock card-clock-icon"></i>
                    <div class="img-wrapper" onclick="this.closest('form').submit();">
                        <img src="https://images.unsplash.com/photo-1560769629-975ec94e6a86?q=80&w=400" alt="Tênis Neutro">
                    </div>
                    <div class="discount-tag">-50% OFF</div>
                    <div class="product-name">Tênis VOLTIX Runner Dynamic Unisex</div>
                    <div class="old-price">R$ 279,99</div>
                    <div class="main-price">R$ 132,99 <span style="font-size: 0.7rem;">no Pix</span></div>
                    <div class="installments">ou 2x de R$ 70,00</div>

                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Comprar</button>
                </form>
            </div>

            <!-- Tênis 3 (Antigo) -->
            <div class="product-card">
                <form action="carrinho" method="POST">
                    <input type="hidden" name="id" value="3">
                    <input type="hidden" name="nome" value="Tênis KINETIX Promina Blue Air">
                    <input type="hidden" name="preco" value="332.49">
                    <input type="hidden" name="imagem_url" value="https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=400">

                    <i class="fa-regular fa-clock card-clock-icon"></i>
                    <div class="img-wrapper" onclick="this.closest('form').submit();">
                        <img src="https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=400" alt="Tênis Azul">
                    </div>
                    <div class="discount-tag">-36% OFF</div>
                    <div class="product-name">Tênis KINETIX Promina Blue Air</div>
                    <div class="old-price">R$ 549,99</div>
                    <div class="main-price">R$ 332,49 <span style="font-size: 0.7rem;">no Pix</span></div>
                    <div class="installments">ou 5x de R$ 70,00</div>

                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Comprar</button>
                </form>
            </div>

            <!-- Tênis 4 (Antigo) -->
            <div class="product-card">
                <form action="carrinho" method="POST">
                    <input type="hidden" name="id" value="4">
                    <input type="hidden" name="nome" value="Tênis AEROMAX Casual White/Black">
                    <input type="hidden" name="preco" value="129.53">
                    <input type="hidden" name="imagem_url" value="https://images.unsplash.com/photo-1608231387042-66d1773070a5?q=80&w=400">

                    <i class="fa-regular fa-clock card-clock-icon"></i>
                    <div class="img-wrapper" onclick="this.closest('form').submit();">
                        <img src="https://images.unsplash.com/photo-1608231387042-66d1773070a5?q=80&w=400" alt="Tênis Branco">
                    </div>
                    <div class="discount-tag">-42% OFF</div>
                    <div class="product-name">Tênis AEROMAX Casual White/Black</div>
                    <div class="old-price">R$ 249,99</div>
                    <div class="main-price">R$ 129,53 <span style="font-size: 0.7rem;">à vista</span></div>
                    <div class="installments">ou 2x de R$ 71,96</div>

                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Comprar</button>
                </form>
            </div>

            <!-- Novo Produto 3: Colchonete para Yoga -->
            <div class="product-card">
                <form action="carrinho" method="POST">
                    <input type="hidden" name="id" value="7">
                    <input type="hidden" name="nome" value="Tapete Mat Yoga NBR 10mm Confort">
                    <input type="hidden" name="preco" value="79.90">
                    <input type="hidden" name="imagem_url" value="https://images.unsplash.com/photo-1592432678016-e910b452f9a2?q=80&w=400">

                    <i class="fa-regular fa-clock card-clock-icon"></i>
                    <div class="img-wrapper" onclick="this.closest('form').submit();">
                        <img src="https://images.unsplash.com/photo-1592432678016-e910b452f9a2?q=80&w=400" alt="Tapete Yoga">
                    </div>
                    <div class="discount-tag">-20% OFF</div>
                    <div class="product-name">Tapete Mat Yoga NBR 10mm Confort</div>
                    <div class="old-price">R$ 99,90</div>
                    <div class="main-price">R$ 79,90 <span style="font-size: 0.7rem;">no Pix</span></div>
                    <div class="installments">ou 2x de R$ 41,50</div>

                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Comprar</button>
                </form>
            </div>


            <!-- Novo Produto 7: Mochila Esportiva -->
            <div class="product-card">
                <form action="carrinho" method="POST">
                    <input type="hidden" name="id" value="11">
                    <input type="hidden" name="nome" value="Mochila Esportiva Impermeável Training">
                    <input type="hidden" name="preco" value="149.90">
                    <input type="hidden" name="imagem_url" value="https://images.unsplash.com/photo-1553062407-98eeb64c6a62?q=80&w=400">

                    <i class="fa-regular fa-clock card-clock-icon"></i>
                    <div class="img-wrapper" onclick="this.closest('form').submit();">
                        <img src="https://images.unsplash.com/photo-1553062407-98eeb64c6a62?q=80&w=400" alt="Mochila Esportiva">
                    </div>
                    <div class="discount-tag">-25% OFF</div>
                    <div class="product-name">Mochila Esportiva Impermeável Training</div>
                    <div class="old-price">R$ 199,90</div>
                    <div class="main-price">R$ 149,90 <span style="font-size: 0.7rem;">no Pix</span></div>
                    <div class="installments">ou 3x de R$ 52,50</div>

                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Comprar</button>
                </form>
            </div>


            <!-- Novo Produto 11: Creatina -->
            <div class="product-card">
                <form action="carrinho" method="POST">
                    <input type="hidden" name="id" value="15">
                    <input type="hidden" name="nome" value="Creatina Monohidratada 250g Pure Power">
                    <input type="hidden" name="preco" value="79.90">
                    <input type="hidden" name="imagem_url" value="https://images.unsplash.com/photo-1593095948071-474c5cc2989d?q=80&w=400">

                    <i class="fa-regular fa-clock card-clock-icon"></i>
                    <div class="img-wrapper" onclick="this.closest('form').submit();">
                        <img src="https://images.unsplash.com/photo-1593095948071-474c5cc2989d?q=80&w=400" alt="Creatina">
                    </div>
                    <div class="discount-tag">-20% OFF</div>
                    <div class="product-name">Creatina Monohidratada 250g Pure Power</div>
                    <div class="old-price">R$ 99,90</div>
                    <div class="main-price">R$ 79,90 <span style="font-size: 0.7rem;">no Pix</span></div>
                    <div class="installments">ou 2x de R$ 41,50</div>

                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Comprar</button>
                </form>
            </div>








            <!-- Novo Produto 3: Boné -->
            <div class="product-card">
                <form action="carrinho" method="POST">
                    <input type="hidden" name="id" value="19">
                    <input type="hidden" name="nome" value="Boné Esportivo Runner Ultra Leve UV Protection">
                    <input type="hidden" name="preco" value="39.90">
                    <input type="hidden" name="imagem_url" value="https://images.unsplash.com/photo-1588850561407-ed78c282e89b?q=80&w=400">

                    <i class="fa-regular fa-clock card-clock-icon"></i>
                    <div class="img-wrapper" onclick="this.closest('form').submit();">
                        <img src="https://images.unsplash.com/photo-1588850561407-ed78c282e89b?q=80&w=400" alt="Boné Esportivo">
                    </div>
                    <div class="discount-tag">-20% OFF</div>
                    <div class="product-name">Boné Esportivo Runner Ultra Leve UV Protection</div>
                    <div class="old-price">R$ 89,90</div>
                    <div class="main-price">R$ 71,90 <span style="font-size: 0.7rem;">no Pix</span></div>
                    <div class="installments">ou 2x de R$ 35,95</div>

                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Comprar</button>
                </form>
            </div>


            <!-- Novo Produto 6: Camisa -->
            <div class="product-card">
                <form action="carrinho" method="POST">
                    <input type="hidden" name="id" value="10">
                    <input type="hidden" name="nome" value="Camisa T-Shirt Dry Run Branca Elastano">
                    <input type="hidden" name="preco" value="59.90">
                    <input type="hidden" name="imagem_url" value="https://images.unsplash.com/photo-1581655353564-df123a1eb820?q=80&w=400">

                    <i class="fa-regular fa-clock card-clock-icon"></i>
                    <div class="img-wrapper" onclick="this.closest('form').submit();">
                        <img src="https://images.unsplash.com/photo-1581655353564-df123a1eb820?q=80&w=400" alt="Camisa Manga Curta">
                    </div>
                    <div class="discount-tag">-25% OFF</div>
                    <div class="product-name">Camisa T-Shirt Dry Run Branca Elastano</div>
                    <div class="old-price">R$ 79,90</div>
                    <div class="main-price">R$ 59,90 <span style="font-size: 0.7rem;">no Pix</span></div>
                    <div class="installments">ou 2x de R$ 31,00</div>

                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Comprar</button>
                </form>
            </div>


            <!-- Novo Produto 9: Tenis -->
            <div class="product-card">
                <form action="carrinho" method="POST">
                    <input type="hidden" name="id" value="13">
                    <input type="hidden" name="nome" value="Tênis New Bounce 9 CloudFoam Marrom">
                    <input type="hidden" name="preco" value="64.90">
                    <input type="hidden" name="imagem_url" value="https://images.unsplash.com/photo-1539185441755-769473a23570?q=80&w=400">

                    <i class="fa-regular fa-clock card-clock-icon"></i>
                    <div class="img-wrapper" onclick="this.closest('form').submit();">
                        <img src="https://images.unsplash.com/photo-1539185441755-769473a23570?q=80&w=400" alt="Bermuda Running">
                    </div>
                    <div class="discount-tag">-35% OFF</div>
                    <div class="product-name">Tênis New Bounce 9 CloudFoam Marrom</div>
                    <div class="old-price">R$ 486,50</div>
                    <div class="main-price">R$ 316,22 <span style="font-size: 0.7rem;">no Pix</span></div>
                    <div class="installments">ou 2x de R$ 158,11</div>

                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Comprar</button>
                </form>
            </div>



            <!-- Novo Produto 13: Calça -->
            <div class="product-card">
                <form action="carrinho" method="POST">
                    <input type="hidden" name="id" value="17">
                    <input type="hidden" name="nome" value="Calça SlimFit Jogger Elastano Preta">
                    <input type="hidden" name="preco" value="79.90">
                    <input type="hidden" name="imagem_url" value="https://images.unsplash.com/photo-1552902865-b72c031ac5ea?q=80&w=400">

                    <i class="fa-regular fa-clock card-clock-icon"></i>
                    <div class="img-wrapper" onclick="this.closest('form').submit();">
                        <img src="https://images.unsplash.com/photo-1552902865-b72c031ac5ea?q=80&w=400" alt="Bermuda Moletom">
                    </div>
                    <div class="discount-tag">-27% OFF</div>
                    <div class="product-name">Calça SlimFit Jogger Elastano Preta</div>
                    <div class="old-price">R$ 109,90</div>
                    <div class="main-price">R$ 79,90 <span style="font-size: 0.7rem;">no Pix</span></div>
                    <div class="installments">ou 2x de R$ 41,50</div>

                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Comprar</button>
                </form>
            </div>










        </div>
    </div>

        <div class="benefits-bar">
            <div class="benefit-item">
                <i class="fa-solid fa-truck-fast"></i>
                <div class="benefit-text"><strong>Frete Grátis</strong>Em produtos selecionados</div>
            </div>
            <div class="benefit-item">
                <i class="fa-solid fa-stopwatch"></i>
                <div class="benefit-text"><strong>Entrega Expressa</strong>A partir de 2 dias úteis</div>
            </div>
            <div class="benefit-item">
                <i class="fa-regular fa-credit-card"></i>
                <div class="benefit-text"><strong>Em até 10x sem juros</strong>no cartão de crédito</div>
            </div>
        </div>


    <!-- RODAPÉ -->
    <footer>
        <div class="footer-top-searches">
            <h4>Outras páginas acessadas</h4>
            <div class="searches-grid">
                <div class="searches-col">
                    <a href="#">Bola de Futebol</a>
                    <a href="#">Chuteira de Futsal</a>
                    <a href="#">Tênis de Corrida Masculino</a>
                    <a href="#">Copa 2026</a>
                    <a href="#">Conjunto do Brasil</a>
                    <a href="#">Camisas Adidas Seleções Home</a>
                    <a href="#">Bola Trionda Competition</a>
                </div>
                <div class="searches-col">
                    <a href="#">Bola de Futsal</a>
                    <a href="#">Chuteira Society</a>
                    <a href="#">Camisa Seleção Brasileira</a>
                    <a href="#">Álbum da Copa</a>
                    <a href="#">Camisa do Brasil Amarela</a>
                    <a href="#">Camisas Adidas Seleções Away</a>
                    <a href="#">Bola Trionda League</a>
                </div>
                <div class="searches-col">
                    <a href="#">Bola Society</a>
                    <a href="#">Chuteiras</a>
                    <a href="#">Camisa do Brasil</a>
                    <a href="#">Boné do Brasil</a>
                    <a href="#">Camisa do Brasil Azul</a>
                    <a href="#">Bola Trionda Campo</a>
                    <a href="#">Bola Trionda Training</a>
                </div>
                <div class="searches-col">
                    <a href="#">Camisa de Seleções</a>
                    <a href="#">Tênis de Corrida</a>
                    <a href="#">Bola da Copa</a>
                    <a href="#">Bandeira do Brasil</a>
                    <a href="#">Camisa do Brasil Feminina</a>
                    <a href="#">Bola Trionda Futsal</a>
                    <a href="#">Bola Trionda Club</a>
                </div>
                <div class="searches-col">
                    <a href="#">Chuteira de Campo</a>
                    <a href="#">Tênis de Corrida Feminino</a>
                    <a href="#">Mini Bola da Copa</a>
                    <a href="#">Moletom Seleção Brasileira</a>
                    <a href="#">Camisa do Brasil Infantil</a>
                    <a href="#">Bola Trionda Society</a>
                    <a href="#">Bola Trionda Beach Soccer</a>
                </div>
            </div>
        </div>


        <div class="footer-main-links">
            <div class="footer-col">
                <h5>Institucional</h5>
                <ul>
                    <li><a href="#">Sobre a SportFitness</a></li>
                    <li><a href="#">Política de Privacidade</a></li>
                    <li><a href="#">Programa de Afiliados</a></li>
                    <li><a href="#">Soluções Corporativas</a></li>
                    <li><a href="#">Regulamentos</a></li>
                    <li><a href="#">Relatórios</a></li>
                    <li><a href="#">Programa de Integridade</a></li>
                    <li><a href="#">Blog</a></li>
                    <li><a href="#">Black Friday Magalu</a></li>
                    <li><a href="#">Black Friday SportFitness</a></li>
                    <li><a href="#">Lojas Físicas</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h5>Especiais SportFitness</h5>
                <ul>
                    <li><a href="#">Suplementos</a></li>
                    <li><a href="#">Corrida</a></li>
                    <li><a href="#">Bicicletas</a></li>
                    <li><a href="#">Futebol</a></li>
                    <li><a href="#">Vôlei</a></li>
                    <li><a href="#">Basquete</a></li>
                    <li><a href="#">Motorsport</a></li>
                    <li><a href="#">Saúde Bem-Estar</a></li>
                    <li><a href="#">Aventura</a></li>
                    <li><a href="#">Mundo das Raquetes</a></li>
                </ul>
                <h5 style="margin-top: 15px;">Mapas do Site</h5>
                <ul>
                    <li><a href="#">Marcas</a></li>
                    <li><a href="#">Tipos de Produtos</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h5>Atendimento</h5>
                <ul>
                    <li><a href="#">Trocas e devoluções</a></li>
                    <li><a href="#">Entregas</a></li>
                    <li><a href="#">Minha Conta</a></li>
                    <li><a href="#">Meus Pedidos</a></li>
                    <li><a href="#">Pagamentos</a></li>
                    <li><a href="#">Cancelamentos</a></li>
                    <li><a href="#">Segurança & Privacidade</a></li>
                    <li><a href="#">Como Comprar</a></li>
                    <li><a href="#">Acessibilidade</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h5>SportFitness Empresas</h5>
                <ul>
                    <li><a href="#">Marketplace SportFitness</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h5>Central de Atendimento</h5>
                <a href="#" class="footer-support-btn">Tire suas dúvidas</a>
                <h5 style="margin-top: 10px;">Central de vendas</h5>
                <p style="color: #666; font-size: 0.7rem; line-height: 1.4;">(11) 4002-8922 ou 08000 777 7000</p>
            </div>
            <div class="footer-col">
                <h5>Redes Sociais</h5>
                <div class="footer-socials">
                    <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                    <a href="#"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#"><i class="fa-brands fa-twitter"></i></a>
                    <a href="#"><i class="fa-brands fa-youtube"></i></a>
                </div>
                <h5 style="margin-top: 15px;">Aplicativo</h5>
                <div class="app-badge-box">
                    <i class="fa-solid fa-mobile-screen-button"></i>
                    <div>
                        <strong>App SportFitness</strong>
                        <span>Conheça as vantagens</span>
                    </div>
                </div>
            </div>
        </div>


    </footer>

<script>
        let seconds = 21935;
        const timerEl = document.getElementById('timer');

        function atualizarTimer() {
            let h = Math.floor(seconds / 3600);
            let m = Math.floor((seconds % 3600) / 60);
            let s = seconds % 60;
            
            let strH = h < 10 ? '0' + h : h;
            let strM = m < 10 ? '0' + m : m;
            let strS = s < 10 ? '0' + s : s;
            
            timerEl.innerText = strH + " : " + strM + " : " + strS;
        }

        atualizarTimer();

        setInterval(() => {
            if (seconds > 0) {
                seconds--;
            }
            atualizarTimer();
        }, 1000);
    </script>

</body>
</html>