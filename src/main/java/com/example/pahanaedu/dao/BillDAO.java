package com.example.pahanaedu.dao;


import com.example.pahanaedu.DB.DBConnection;
import com.example.pahanaedu.model.Bill;

import java.sql.*;

public class BillDAO {

    public long insert(Bill b) {
        String sql = "INSERT INTO bills (account_no, units, rate_model, subtotal, tax_amount, total_amount) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, b.getAccountNo());
            ps.setInt(2, b.getUnits());
            ps.setString(3, b.getRateModel());
            ps.setDouble(4, b.getSubtotal());
            ps.setDouble(5, b.getTaxAmount());
            ps.setDouble(6, b.getTotalAmount());
            int ok = ps.executeUpdate();
            if (ok == 1) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        long id = rs.getLong(1);
                        b.setId(id);
                        return id;
                    }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public Bill findById(long id) {
        String sql = "SELECT id, account_no, units, rate_model, subtotal, tax_amount, total_amount, generated_at " +
                "FROM bills WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Bill b = new Bill();
                    b.setId(rs.getLong("id"));
                    b.setAccountNo(rs.getString("account_no"));
                    b.setUnits(rs.getInt("units"));
                    b.setRateModel(rs.getString("rate_model"));
                    b.setSubtotal(rs.getDouble("subtotal"));
                    b.setTaxAmount(rs.getDouble("tax_amount"));
                    b.setTotalAmount(rs.getDouble("total_amount"));
                    Timestamp ts = rs.getTimestamp("generated_at");
                    if (ts != null) b.setGeneratedAt(ts.toLocalDateTime());
                    return b;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}

