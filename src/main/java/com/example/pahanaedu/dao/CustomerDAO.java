package com.example.pahanaedu.dao;


import com.example.pahanaedu.DB.DBConnection;
import com.example.pahanaedu.model.Customer;

import java.sql.*;

public class CustomerDAO {

    public boolean existsByAccountNo(String accountNo) {
        String sql = "SELECT 1 FROM customers WHERE account_no = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, accountNo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // fail safe: assume exists to avoid duplicates on error
        }
    }

    public boolean insert(Customer c) {
        String sql = "INSERT INTO customers (account_no, name, address, phone, units) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getAccountNo());
            ps.setString(2, c.getName());
            ps.setString(3, c.getAddress());
            ps.setString(4, c.getPhone());
            ps.setInt(5, c.getUnits());

            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

