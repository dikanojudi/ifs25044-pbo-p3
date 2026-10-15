# Jadwal Kegiatan

Aplikasi konsol penjadwalan kegiatan harian (judul, hari, waktu) dengan update parsial.

Bagian dari proyek `ifs18005-java-oop` — Praktikum Java Exception & Generic (Clean Architecture, Java Generics, Java Exceptions).

## Entity

Activity (`id`, `title`, `day`, `time`), enum `Day` (Senin–Minggu), enum `SortOption`

## Menu

- 1. Tambah
- 2. Ubah (judul/hari/waktu parsial)
- 3. Cari (berdasarkan judul)
- 4. Urutkan
- 5. Hapus
- x. Keluar

### Pilihan Pengurutan

- 1. Hari (Senin → Minggu, lalu waktu)
- 2. Waktu (awal → akhir)
- 3. Judul A-Z
- 4. Judul Z-A

## Aturan Validasi

- Judul, hari, dan waktu tidak boleh kosong
- Pengurutan hari mengikuti urutan Senin–Minggu (hari tidak dikenal diurutkan terakhir); waktu `HH:mm` diurutkan secara leksikografis
- Input kosong saat ubah = field tidak diubah; update bersifat atomik (semua divalidasi sebelum data diubah)

## Arsitektur

Dependency mengarah ke dalam: `domain ← usecase ← adapter / framework`.

| Layer | Isi | Tanggung jawab |
|-------|-----|----------------|
| `domain/entity` | Entity dan enum domain | Model data + aturan pengurutan (comparator di dalam enum) |
| `domain/exception` | `DomainException`, `EntityNotFoundException`, `ValidationException` | Hierarki checked exception domain |
| `domain/repository` | `IRepository<T, ID>`, `IActivityRepository` | Port penyimpanan (generic + spesifik) |
| `usecase` | `ActivityUseCase` | Logika bisnis & validasi, tanpa I/O |
| `adapter/repository` | `InMemoryRepository<T, ID>`, `ActivityRepository` | Implementasi penyimpanan in-memory, pembuat ID unik |
| `adapter/presenter` | `ActivityPresenter` | Seluruh format output ke layar |
| `framework/view` | `ActivityView` | Menu, input pengguna, try-catch exception |
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
cd .. && ./run-tests.sh jadwal-kegiatan
```
