package com.shopsphere.util;

import java.text.NumberFormat;
import java.util.Locale;
import java.util.ResourceBundle;

/**
 * RTU Syllabus Internationalization (I18N) Demonstration:
 * Demonstrates Locale, ResourceBundle, and localized currency formatting.
 */
public class I18nDemo {

    public static String getLocalizedMessage(String key, String lang) {
        try {
            Locale locale = "hi".equalsIgnoreCase(lang) ? new Locale("hi") : Locale.ENGLISH;
            ResourceBundle bundle = ResourceBundle.getBundle("messages", locale);
            return bundle.getString(key);
        } catch (Exception e) {
            return key;
        }
    }

    public static String formatCurrency(double amount, String lang) {
        Locale locale = "hi".equalsIgnoreCase(lang) ? new Locale("hi", "IN") : new Locale("en", "IN");
        NumberFormat nf = NumberFormat.getCurrencyInstance(locale);
        return nf.format(amount);
    }
}
