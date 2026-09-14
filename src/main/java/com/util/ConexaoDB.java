package com.sportfitness.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexaoDB {
    
    public static Connection getConexao() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver JDBC do MySQL não encontrado!", e);
        }

        // Lê do Azure (ou usa o padrão do Docker local se não estiver no Azure)
        String host = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "db";
        String port = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "3306";
        String dbName = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "sportfitness_db";
        String usuario = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root";
        String senha = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : "root";

        String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=true&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        
        return DriverManager.getConnection(url, usuario, senha);
    }
}