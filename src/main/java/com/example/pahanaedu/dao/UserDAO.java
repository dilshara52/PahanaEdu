package com.example.pahanaedu.dao;


import com.example.pahanaedu.DB.DBConnection;
import com.example.pahanaedu.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;

public class UserDAO {

    public User authenticate(String username, String plainPassword) {
        String sql = "SELECT id, username, password_hash, full_name, role, is_active FROM users WHERE username = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                String hash = rs.getString("password_hash");
                boolean active = rs.getInt("is_active") == 1;

                if (!active) return null;
                if (!BCrypt.checkpw(plainPassword, hash)) return null;

                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setRole(rs.getString("role"));
                u.setActive(active);

                // update last_login
                try (PreparedStatement ups = con.prepareStatement("UPDATE users SET last_login = NOW() WHERE id = ?")) {
                    ups.setInt(1, u.getId());
                    ups.executeUpdate();
                }

                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace(); // for assignment; in production, use logging
            return null;
        }
    }

    /** Utility to generate a BCrypt hash once (use in a one-off main or test) */
    public static String hashPassword(String plain) {
        return BCrypt.hashpw(plain, BCrypt.gensalt(10));
    }
}

