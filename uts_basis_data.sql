-- UTS MANAJEMEN BASIS DATA
-- Database: uts_basis_data
-- PostgreSQL 15

-- 1. Membuat schema
CREATE SCHEMA IF NOT EXISTS "SALAM";

-- 2. Membuat tabel mahasiswa
CREATE TABLE IF NOT EXISTS "SALAM".mahasiswas (
    id SERIAL PRIMARY KEY,
    nim VARCHAR(20) NOT NULL UNIQUE,
    nama VARCHAR(100) NOT NULL,
    umur INT NOT NULL CHECK (umur BETWEEN 16 AND 100),
    email VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Memberikan akses CRUD kepada backend_dev
GRANT USAGE ON SCHEMA "SALAM" TO backend_dev;
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA "SALAM" TO backend_dev;
GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA "SALAM" TO backend_dev;

-- 4. Memberikan akses baca kepada bi_dev
GRANT USAGE ON SCHEMA "SALAM" TO bi_dev;
GRANT SELECT
ON ALL TABLES IN SCHEMA "SALAM" TO bi_dev;

-- 5. Memberikan akses CRUD dan CREATE kepada data_engineer
GRANT USAGE, CREATE ON SCHEMA "SALAM" TO data_engineer;
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA "SALAM" TO data_engineer;
GRANT USAGE, SELECT, UPDATE
ON ALL SEQUENCES IN SCHEMA "SALAM" TO data_engineer;

-- Catatan:
-- Password role dan konfigurasi rahasia tidak disimpan di file ini.
-- Kepemilikan schema dan tabel diatur melalui perintah ALTER OWNER
-- yang dijalankan secara terpisah saat konfigurasi.