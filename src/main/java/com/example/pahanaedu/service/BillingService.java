package com.example.pahanaedu.service;


import java.util.ArrayList;
import java.util.List;

public class BillingService {

    // Change your tariff here (LKR)
    // SLAB_V1: 0-100 at 20, 101-200 at 25, >200 at 30; 8% tax (example)
    public static final String RATE_MODEL = "SLAB_V1";
    private static final double TAX_RATE = 0.08;

    public static class Line {
        public String label;
        public int units;
        public double rate;
        public double amount;
        public Line(String label, int units, double rate) {
            this.label = label;
            this.units = units;
            this.rate = rate;
            this.amount = units * rate;
        }
    }

    public static class Result {
        public List<Line> lines = new ArrayList<>();
        public int totalUnits;
        public double subtotal;
        public double taxAmount;
        public double totalAmount;
        public String rateModel = RATE_MODEL;
    }

    public Result calculate(int units) {
        if (units < 0) units = 0;
        Result r = new Result();
        r.totalUnits = units;

        int u1 = Math.min(units, 100);
        int u2 = Math.min(Math.max(units - 100, 0), 100);
        int u3 = Math.max(units - 200, 0);

        if (u1 > 0) r.lines.add(new Line("First 100 units", u1, 20.0));
        if (u2 > 0) r.lines.add(new Line("Next 100 units", u2, 25.0));
        if (u3 > 0) r.lines.add(new Line("Above 200 units", u3, 30.0));

        r.subtotal = r.lines.stream().mapToDouble(l -> l.amount).sum();
        r.taxAmount = round2(r.subtotal * TAX_RATE);
        r.totalAmount = round2(r.subtotal + r.taxAmount);
        r.subtotal = round2(r.subtotal);
        return r;
    }

    private static double round2(double v) {
        return Math.round(v * 100.0) / 100.0;
    }
}

