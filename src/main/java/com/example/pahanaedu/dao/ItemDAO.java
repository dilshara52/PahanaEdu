package com.example.pahanaedu.dao;


import com.example.pahanaedu.DB.DBConnection;
import com.example.pahanaedu.model.Item;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    public boolean insert(Item item) {
        String sql = "INSERT INTO items (item_code, item_name, item_type, item_price) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, item.getItemCode());
            ps.setString(2, item.getItemName());
            ps.setString(3, item.getItemType());
            ps.setDouble(4, item.getItemPrice());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public Item findByCode(String code) {
        String sql = "SELECT * FROM items WHERE item_code = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Item> findAll() {
        List<Item> list = new ArrayList<>();
        String sql = "SELECT * FROM items ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean update(Item item) {
        String sql = "UPDATE items SET item_name=?, item_type=?, item_price=? WHERE item_code=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, item.getItemName());
            ps.setString(2, item.getItemType());
            ps.setDouble(3, item.getItemPrice());
            ps.setString(4, item.getItemCode());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean delete(String code) {
        String sql = "DELETE FROM items WHERE item_code=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, code);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Item mapRow(ResultSet rs) throws SQLException {
        return new Item(
                rs.getString("item_code"),
                rs.getString("item_name"),
                rs.getString("item_type"),
                rs.getDouble("item_price")
        );
    }
}

