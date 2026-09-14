package com.sportfitness.servlet;

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

@WebServlet("/cadastro")
public class CadastroServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        if (nome == null || nome.isBlank() || email == null || email.isBlank() || senha == null || senha.isBlank()) {
            response.sendRedirect("cadastro.jsp?erro=1");
            return;
        }

        try (Connection conn = ConexaoDB.getConexao()) {
            String sql = "INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, nome);
                stmt.setString(2, email);
                stmt.setString(3, senha);

                int rows = stmt.executeUpdate();

                if (rows > 0) {
                    try (ResultSet rs = stmt.getGeneratedKeys()) {
                        if (rs.next()) {
                            int newId = rs.getInt(1);
                            HttpSession session = request.getSession();
                            session.setAttribute("usuarioId", newId);
                            session.setAttribute("usuarioNome", nome);
                        }
                    }
                    // Após criar a conta, loga o usuário e vai direto pro index
                    response.sendRedirect("index.jsp");
                } else {
                    response.sendRedirect("cadastro.jsp?erro=db");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("cadastro.jsp?erro=db");
        }
    }
}