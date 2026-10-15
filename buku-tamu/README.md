# Buku Tamu

Aplikasi konsol buku tamu digital untuk mencatat nama dan tujuan kunjungan.

Bagian dari proyek `ifs18005-java-oop` — Praktikum Java Exception & Generic (Clean Architecture, Java Generics, Java Exceptions).

## Entity

Guest (`id`, `name`, `purpose`)

## Menu

- 1. Daftarkan
- 2. Cari (berdasarkan nama, case-insensitive)
- 3. Hapus
- x. Keluar

## Aturan Validasi

- Nama dan tujuan kunjungan tidak boleh kosong
- Setiap prompt dapat dibatalkan dengan `x`
- Pencarian tanpa hasil menampilkan `- Tamu tidak ditemukan!`

## Arsitektur

Dependency mengarah ke dalam: `domain ← usecase ← adapter / framework`.

| Layer | Isi | Tanggung jawab |
|-------|-----|----------------|
| `domain/entity` | Entity dan enum domain | Model data + aturan pengurutan (comparator di dalam enum) |
| `domain/exception` | `DomainException`, `EntityNotFoundException`, `ValidationException` | Hierarki checked exception domain |
| `domain/repository` | `IRepository<T, ID>`, `IGuestRepository` | Port penyimpanan (generic + spesifik) |
| `usecase` | `GuestUseCase` | Logika bisnis & validasi, tanpa I/O |
| `adapter/repository` | `InMemoryRepository<T, ID>`, `GuestRepository` | Implementasi penyimpanan in-memory, pembuat ID unik |
| `adapter/presenter` | `GuestPresenter` | Seluruh format output ke layar |
| `framework/view` | `GuestView` | Menu, input pengguna, try-catch exception |
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
cd .. && ./run-tests.sh buku-tamu
```
