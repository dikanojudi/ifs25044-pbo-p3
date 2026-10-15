# Catatan Keuangan

Aplikasi konsol pencatat transaksi keuangan pribadi (pemasukan & pengeluaran) beserta perhitungan saldo.

Bagian dari proyek `ifs18005-java-oop` — Praktikum Java Exception & Generic (Clean Architecture, Java Generics, Java Exceptions).

## Entity

Transaction (`id`, `description`, `amount`, `type`), enum `TransactionType` (INCOME/EXPENSE), enum `SortOption`

## Menu

- 1. Tambah Pemasukan
- 2. Tambah Pengeluaran
- 3. Cari (berdasarkan keterangan; prompt `Keterangan`)
- 4. Urutkan
- 5. Lihat Saldo
- 6. Hapus
- x. Keluar

### Pilihan Pengurutan

- 1. Jumlah terbesar → terkecil
- 2. Jumlah terkecil → terbesar
- 3. Pemasukan dulu
- 4. Pengeluaran dulu

> Urutan menu pengurutan mengikuti test case TC-02 (pilihan `2` menghasilkan jumlah terkecil lebih dulu).

## Aturan Validasi

- Keterangan tidak boleh kosong
- Jumlah harus angka bulat > 0 (`[!] Jumlah tidak valid!`)
- Saldo = total pemasukan − total pengeluaran

## Arsitektur

Dependency mengarah ke dalam: `domain ← usecase ← adapter / framework`.

| Layer | Isi | Tanggung jawab |
|-------|-----|----------------|
| `domain/entity` | Entity dan enum domain | Model data + aturan pengurutan (comparator di dalam enum) |
| `domain/exception` | `DomainException`, `EntityNotFoundException`, `ValidationException` | Hierarki checked exception domain |
| `domain/repository` | `IRepository<T, ID>`, `IFinanceRepository` | Port penyimpanan (generic + spesifik) |
| `usecase` | `FinanceUseCase` | Logika bisnis & validasi, tanpa I/O |
| `adapter/repository` | `InMemoryRepository<T, ID>`, `FinanceRepository` | Implementasi penyimpanan in-memory, pembuat ID unik |
| `adapter/presenter` | `FinancePresenter` | Seluruh format output ke layar |
| `framework/view` | `FinanceView` | Menu, input pengguna, try-catch exception |
| `framework/util` | `InputUtil` | Membaca & mengonversi input keyboard |
| `App.java` | Composition Root | Satu-satunya tempat yang mengenal implementasi konkret |

## Cara Menjalankan

Prasyarat: JDK 17 atau lebih baru.

```bash
# compile
javac -d output -sourcepath src src/App.java

# jalankan
java -cp output App
```

## Pengujian

Test case tersedia di `test-cases/` (`TC-0X.tc` = input, `TC-0X.expected` = cuplikan output yang harus muncul).

```bash
# satu test case secara manual
java -cp output App < test-cases/TC-01.tc

# seluruh test case studi kasus ini (dijalankan dari folder induk)
cd .. && ./run-tests.sh catatan-keuangan
```
