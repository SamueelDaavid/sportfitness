package com.sportfitness.servlet;

import com.sportfitness.model.ItemCarrinho;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

// Mapeia para ambos os endpoints usados no frontend
@WebServlet({"/carrinho", "/carrinho-acao"})
public class CarrinhoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        // Aceita tanto 'produtoId' (usado no carrinho.jsp) quanto 'id' (usado na index.jsp)
        String rawId = request.getParameter("produtoId");
        if (rawId == null || rawId.trim().isEmpty()) {
            rawId = request.getParameter("id");
        }

        // Se mesmo assim não houver ID, redireciona para a página do carrinho sem quebrar
        if (rawId == null || rawId.trim().isEmpty()) {
            response.sendRedirect("carrinho.jsp");
            return;
        }

        int produtoId = Integer.parseInt(rawId);
        String acao = request.getParameter("acao");

        HttpSession session = request.getSession();
        List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");

        if (carrinho == null) {
            carrinho = new ArrayList<>();
            session.setAttribute("carrinho", carrinho);
        }

        // Trata ações de alterar quantidade ou remover
        if (acao != null && !acao.isEmpty()) {
            for (int i = 0; i < carrinho.size(); i++) {
                ItemCarrinho item = carrinho.get(i);
                if (item.getProdutoId() == produtoId) {
                    if ("aumentar".equals(acao)) {
                        item.setQuantidade(item.getQuantidade() + 1);
                    } else if ("diminuir".equals(acao)) {
                        if (item.getQuantidade() > 1) {
                            item.setQuantidade(item.getQuantidade() - 1);
                        } else {
                            carrinho.remove(i);
                        }
                    } else if ("remover".equals(acao)) {
                        carrinho.remove(i);
                    }
                    break;
                }
            }
        } 
        // Trata a adição de novos produtos ao carrinho
        else {
            String nome = request.getParameter("nome");
            String precoStr = request.getParameter("preco");
            String imagem = request.getParameter("imagem_url");

            double preco = (precoStr != null && !precoStr.isEmpty()) ? Double.parseDouble(precoStr) : 0.0;
            if (imagem == null) imagem = "";

            boolean existe = false;
            for (ItemCarrinho item : carrinho) {
                if (item.getProdutoId() == produtoId) {
                    item.setQuantidade(item.getQuantidade() + 1);
                    existe = true;
                    break;
                }
            }

            if (!existe) {
                carrinho.add(new ItemCarrinho(produtoId, nome, preco, 1, imagem));
            }
        }

        response.sendRedirect("carrinho.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String acao = request.getParameter("acao");
        String nomeItem = request.getParameter("nome");

        if (acao != null && nomeItem != null) {
            HttpSession session = request.getSession();
            List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");

            if (carrinho != null) {
                for (int i = 0; i < carrinho.size(); i++) {
                    ItemCarrinho item = carrinho.get(i);
                    if (item.getNome().equals(nomeItem)) {
                        if ("aumentar".equals(acao)) {
                            item.setQuantidade(item.getQuantidade() + 1);
                        } else if ("diminuir".equals(acao)) {
                            if (item.getQuantidade() > 1) {
                                item.setQuantidade(item.getQuantidade() - 1);
                            } else {
                                carrinho.remove(i);
                            }
                        } else if ("remover".equals(acao)) {
                            carrinho.remove(i);
                        }
                        break;
                    }
                }
                session.setAttribute("carrinho", carrinho);
            }
        }

        response.sendRedirect("carrinho.jsp");
    }
}