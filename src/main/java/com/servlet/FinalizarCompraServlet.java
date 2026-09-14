package com.sportfitness.servlet;

import com.sportfitness.model.ItemCarrinho;
import com.sportfitness.util.ConexaoDB;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

@WebServlet("/FinalizarCompraServlet")
public class FinalizarCompraServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("checkout.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Garante a leitura correta de caracteres especiais (acentos)
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Integer usuarioId = (Integer) session.getAttribute("usuarioId");
        List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");

        if (usuarioId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (carrinho == null || carrinho.isEmpty()) {
            response.sendRedirect("carrinho.jsp");
            return;
        }

        // 1. Captura os dados da tela de checkout (Endereço, Cidade, CEP e Pagamento)
        String enderecoCompleto = request.getParameter("enderecoCompleto");
        String cidade = request.getParameter("cidade");
        String cep = request.getParameter("cep");
        String formaPagamento = request.getParameter("formaPagamento");

        // 2. Calcula o valor total do carrinho
        double total = 0;
        for (ItemCarrinho item : carrinho) {
            total += item.getSubtotal();
        }

        Connection conn = null;
        try {
            conn = ConexaoDB.getConexao();
            conn.setAutoCommit(false);

            // 3. Insere o pedido com os campos novos na tabela 'pedidos'
            // Nota: Usamos 'valor_total' para bater com a tabela que recriamos antes
            String sqlPedido = "INSERT INTO pedidos (usuario_id, endereco_completo, cidade, cep, forma_pagamento, valor_total) VALUES (?, ?, ?, ?, ?, ?)";
            int pedidoId = -1;

            try (PreparedStatement stmtPedido = conn.prepareStatement(sqlPedido, Statement.RETURN_GENERATED_KEYS)) {
                stmtPedido.setInt(1, usuarioId);
                stmtPedido.setString(2, enderecoCompleto);
                stmtPedido.setString(3, cidade);
                stmtPedido.setString(4, cep);
                stmtPedido.setString(5, formaPagamento);
                stmtPedido.setDouble(6, total);
                stmtPedido.executeUpdate();

                try (ResultSet rs = stmtPedido.getGeneratedKeys()) {
                    if (rs.next()) {
                        pedidoId = rs.getInt(1);
                    }
                }
            }

            // 4. Insere os itens usando o produto_id (exatamente como no seu código original)
            String sqlItem = "INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmtItem = conn.prepareStatement(sqlItem)) {
                for (ItemCarrinho item : carrinho) {
                    stmtItem.setInt(1, pedidoId);
                    stmtItem.setInt(2, item.getProdutoId());
                    stmtItem.setInt(3, item.getQuantidade());
                    stmtItem.setDouble(4, item.getPreco());
                    stmtItem.addBatch();
                }
                stmtItem.executeBatch();
            }

            conn.commit();
            session.removeAttribute("carrinho");
            response.sendRedirect("pedido_sucesso.jsp?id=" + pedidoId);

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Desfaz alterações no banco caso ocorra algum erro
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            response.sendRedirect("carrinho.jsp?erro=db");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}