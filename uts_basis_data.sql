
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

-- 3. Role backend_dev: CRUD tabel
GRANT USAGE ON SCHEMA "SALAM" TO backend_dev;
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA "SALAM" TO backend_dev;
GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA "SALAM" TO backend_dev;

-- 4. Role bi_dev: baca tabel
GRANT USAGE ON SCHEMA "SALAM" TO bi_dev;
GRANT SELECT
ON ALL TABLES IN SCHEMA "SALAM" TO bi_dev;

-- 5. Role data_engineer
GRANT USAGE, CREATE ON SCHEMA "SALAM" TO data_engineer;
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA "SALAM" TO data_engineer;
GRANT USAGE, SELECT, UPDATE
ON ALL SEQUENCES IN SCHEMA "SALAM" TO data_engineer;

-- 6. Tabel Audit Log
CREATE TABLE IF NOT EXISTS "SALAM".audit_log (
    id SERIAL PRIMARY KEY,
    tabel VARCHAR(50) NOT NULL,
    aksi VARCHAR(10) NOT NULL,
    nim_mahasiswa VARCHAR(20),
    waktu_aksi TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dilakukan_oleh VARCHAR(100) NOT NULL DEFAULT CURRENT_USER
);

-- 7. Function untuk mencatat perubahan data mahasiswa
CREATE OR REPLACE FUNCTION "SALAM".catat_audit_mahasiswa()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO "SALAM".audit_log
            (tabel, aksi, nim_mahasiswa, dilakukan_oleh)
        VALUES
            (TG_TABLE_NAME, TG_OP, OLD.nim, CURRENT_USER);

        RETURN OLD;
    ELSE
        INSERT INTO "SALAM".audit_log
            (tabel, aksi, nim_mahasiswa, dilakukan_oleh)
        VALUES
            (TG_TABLE_NAME, TG_OP, NEW.nim, CURRENT_USER);

        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 8. Trigger audit otomatis
DROP TRIGGER IF EXISTS trg_audit_mahasiswas
ON "SALAM".mahasiswas;

CREATE TRIGGER trg_audit_mahasiswas
AFTER INSERT OR UPDATE OR DELETE
ON "SALAM".mahasiswas
FOR EACH ROW
EXECUTE FUNCTION "SALAM".catat_audit_mahasiswa();

-- 9. Hak akses tabel audit_log
GRANT SELECT, INSERT ON "SALAM".audit_log TO backend_dev;
GRANT USAGE, SELECT ON SEQUENCE "SALAM".audit_log_id_seq
TO backend_dev;

GRANT SELECT ON "SALAM".audit_log TO bi_dev;

GRANT SELECT, INSERT, UPDATE, DELETE
ON "SALAM".audit_log TO data_engineer;
GRANT USAGE, SELECT, UPDATE
ON SEQUENCE "SALAM".audit_log_id_seq TO data_engineer;

-- Catatan:
-- Password dan konfigurasi rahasia tidak disimpan di file ini.
-- Role harus sudah dibuat sebelumnya.
-- Hak akses dan kepemilikan objek perlu dikonfigurasi
-- sesuai kebutuhan menggunakan akun administrator PostgreSQL.
