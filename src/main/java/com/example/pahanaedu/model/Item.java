package com.example.pahanaedu.model;


public class Item {
    private String itemCode;
    private String itemName;
    private String itemType;
    private double itemPrice;

    public Item() {}

    public Item(String itemCode, String itemName, String itemType, double itemPrice) {
        this.itemCode = itemCode;
        this.itemName = itemName;
        this.itemType = itemType;
        this.itemPrice = itemPrice;
    }

    public String getItemCode() { return itemCode; }
    public void setItemCode(String itemCode) { this.itemCode = itemCode; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public String getItemType() { return itemType; }
    public void setItemType(String itemType) { this.itemType = itemType; }

    public double getItemPrice() { return itemPrice; }
    public void setItemPrice(double itemPrice) { this.itemPrice = itemPrice; }
}

