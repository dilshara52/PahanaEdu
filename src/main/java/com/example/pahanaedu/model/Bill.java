package com.example.pahanaedu.model;


import java.time.LocalDateTime;

public class Bill {
    private long id;
    private String accountNo;
    private int units;
    private String rateModel;
    private double subtotal;
    private double taxAmount;
    private double totalAmount;
    private LocalDateTime generatedAt;

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getAccountNo() { return accountNo; }
    public void setAccountNo(String accountNo) { this.accountNo = accountNo; }

    public int getUnits() { return units; }
    public void setUnits(int units) { this.units = units; }

    public String getRateModel() { return rateModel; }
    public void setRateModel(String rateModel) { this.rateModel = rateModel; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public double getTaxAmount() { return taxAmount; }
    public void setTaxAmount(double taxAmount) { this.taxAmount = taxAmount; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public LocalDateTime getGeneratedAt() { return generatedAt; }
    public void setGeneratedAt(LocalDateTime generatedAt) { this.generatedAt = generatedAt; }
}
