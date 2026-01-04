-- PrestaShop minimal database initialization
-- This creates the basic structure to skip installation

USE prestashop;

-- Basic configuration settings
INSERT IGNORE INTO ps_configuration (name, value, date_add, date_upd) VALUES
('PS_SHOP_DOMAIN', 'localhost', NOW(), NOW()),
('PS_SHOP_DOMAIN_SSL', 'localhost', NOW(), NOW()),
('PS_INSTALL_VERSION', '9.0.0', NOW(), NOW()),
('PS_VERSION_DB', '9.0.0', NOW(), NOW()),
('PS_SHOP_NAME', 'My PrestaShop', NOW(), NOW()),
('PS_SHOP_EMAIL', 'demo@prestashop.com', NOW(), NOW()),
('PS_COUNTRY_DEFAULT', '8', NOW(), NOW()),
('PS_LANG_DEFAULT', '1', NOW(), NOW()),
('PS_CURRENCY_DEFAULT', '1', NOW(), NOW());

-- Create default language
INSERT IGNORE INTO ps_lang (id_lang, name, active, iso_code, language_code, locale, date_format_lite, date_format_full, is_rtl) VALUES
(1, 'English (English)', 1, 'en', 'en-us', 'en-US', 'm/d/Y', 'm/d/Y H:i:s', 0);

-- Create default currency (Euro)
INSERT IGNORE INTO ps_currency (id_currency, name, iso_code, iso_code_num, sign, blank, format, decimals, conversion_rate, deleted, active, unofficial) VALUES
(1, 'Euro', 'EUR', '978', '€', 1, 1, 1, 1.000000, 0, 1, 0);

-- Create default country (France)
INSERT IGNORE INTO ps_country (id_country, id_zone, id_currency, iso_code, active, contains_states, need_identification_number, need_zip_code, zip_code_format, display_tax_label, name) VALUES
(8, 1, 1, 'FR', 1, 0, 0, 1, 'NNNNN', 1, 'France');

-- Create default shop
INSERT IGNORE INTO ps_shop (id_shop, id_shop_group, name, id_category, id_currency, deleted, active) VALUES
(1, 1, 'My Shop', 2, 1, 0, 1);

-- Create default shop group
INSERT IGNORE INTO ps_shop_group (id_shop_group, name, share_customer, share_order, share_stock, active) VALUES
(1, 'Default', 0, 0, 0, 1);

-- Create admin employee (password: admin123)
-- Password hash for 'admin123' (you should change this)
INSERT IGNORE INTO ps_employee (id_employee, id_profile, id_lang, lastname, firstname, email, passwd, last_passwd_gen, active, id_shop, id_shop_group, default_tab) VALUES
(1, 1, 1, 'Admin', 'PrestaShop', 'demo@prestashop.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NOW(), 1, 1, 1, 1);

-- Create default category
INSERT IGNORE INTO ps_category (id_category, id_parent, id_shop_default, level_depth, nleft, nright, active, date_add, date_upd, position, is_root_category) VALUES
(1, 0, 1, 0, 1, 2, 1, NOW(), NOW(), 0, 1),
(2, 1, 1, 1, 2, 3, 1, NOW(), NOW(), 1, 0);

-- Create category language data
INSERT IGNORE INTO ps_category_lang (id_category, id_shop, id_lang, name, description, link_rewrite, meta_title, meta_keywords, meta_description) VALUES
(1, 1, 1, 'Root', '', 'root', '', '', ''),
(2, 1, 1, 'Home', '', 'home', '', '', '');

-- Set installation as completed
INSERT IGNORE INTO ps_configuration (name, value, date_add, date_upd) VALUES
('PS_INSTALL_FINISHED', '1', NOW(), NOW());
