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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        try (Connection conn = ConexaoDB.getConexao()) {
            String sql = "SELECT id, nome FROM usuarios WHERE email = ? AND senha = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, email);
                stmt.setString(2, senha);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        HttpSession session = request.getSession();
                        session.setAttribute("usuarioId", rs.getInt("id"));
                        session.setAttribute("usuarioNome", rs.getString("nome"));
                        response.sendRedirect("index.jsp");
                    } else {
                        response.sendRedirect("login.jsp?erro=1");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?erro=db");
        }
    }
}