# Inventaris Barang

Aplikasi konsol manajemen inventaris barang (nama, jumlah stok, kategori).

Bagian dari proyek `ifs18005-java-oop` — Praktikum Java Exception & Generic (Clean Architecture, Java Generics, Java Exceptions).

## Entity

Item (`id`, `name`, `quantity`, `category`), enum `SortOption`

## Menu

- 1. Tambah
- 2. Ubah Stok
- 3. Cari (berdasarkan nama)
- 4. Urutkan
- 5. Hapus
- x. Keluar

### Pilihan Pengurutan

- 1. Nama A-Z
- 2. Nama Z-A
- 3. Jumlah terkecil
- 4. Jumlah terbesar

## Aturan Validasi

- Jumlah stok harus angka bulat > 0 (`[!] Jumlah stok tidak valid!`)
- Nama dan kategori tidak boleh kosong

## Arsitektur

Dependency mengarah ke dalam: `domain ← usecase ← adapter / framework`.

| Layer | Isi | Tanggung jawab |
|-------|-----|----------------|
| `domain/entity` | Entity dan enum domain | Model data + aturan pengurutan (comparator di dalam enum) |
| `domain/exception` | `DomainException`, `EntityNotFoundException`, `ValidationException` | Hierarki checked exception domain |
| `domain/repository` | `IRepository<T, ID>`, `IItemRepository` | Port penyimpanan (generic + spesifik) |
| `usecase` | `ItemUseCase` | Logika bisnis & validasi, tanpa I/O |
| `adapter/repository` | `InMemoryRepository<T, ID>`, `ItemRepository` | Implementasi penyimpanan in-memory, pembuat ID unik |
| `adapter/presenter` | `ItemPresenter` | Seluruh format output ke layar |
| `framework/view` | `ItemView` | Menu, input pengguna, try-catch exception |
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
cd .. && ./run-tests.sh inventaris-barang
```
