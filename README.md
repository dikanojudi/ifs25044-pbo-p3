# ifs18005-java-oop

Kumpulan lima studi kasus **Praktikum Java Exception & Generic** yang dibangun dengan
**Clean Architecture**, **Java Generics**, dan **Java Exceptions**.

| Studi Kasus | Folder |
|-------------|--------|
| Catatan Keuangan | [`catatan-keuangan`](catatan-keuangan) |
| Buku Tamu | [`buku-tamu`](buku-tamu) |
| Inventaris Barang | [`inventaris-barang`](inventaris-barang) |
| Jadwal Kegiatan | [`jadwal-kegiatan`](jadwal-kegiatan) |
| Kontak Teman | [`kontak-teman`](kontak-teman) |

Setiap folder adalah proyek mandiri (punya `src/`, `test-cases/`, `README.md`, dan `structure.txt`).

## Struktur Layer (sama di setiap studi kasus)

```
src/
├── domain/
│   ├── entity/          # Entity + enum domain (comparator ada di enum SortOption)
│   ├── exception/       # DomainException, EntityNotFoundException, ValidationException
│   └── repository/      # IRepository<T, ID> + port repository spesifik
├── usecase/             # Logika bisnis (tanpa I/O, melempar checked domain exception)
├── adapter/
│   ├── repository/      # InMemoryRepository<T, ID> + implementasi repository spesifik
│   └── presenter/       # Format output ke layar
├── framework/
│   ├── view/            # UI konsol + penanganan exception (try-catch)
│   └── util/            # InputUtil
└── App.java             # Composition Root
```

## Cara Menjalankan

Prasyarat: JDK 17 atau lebih baru (diuji dengan JDK 21).

```bash
cd buku-tamu                      # contoh; ganti dengan studi kasus lain
javac -d output -sourcepath src src/App.java
java -cp output App
```

## Menjalankan Seluruh Test Case

```bash
./run-tests.sh                    # semua studi kasus (21 test case)
./run-tests.sh kontak-teman       # satu studi kasus saja
```

Skrip meng-compile tiap proyek, menjalankan setiap `TC-XX.tc` sebagai input, lalu memastikan
setiap baris di `TC-XX.expected` muncul pada output sesuai urutan.

## Penerapan Kriteria Penilaian

| Kriteria | Penerapan |
|----------|-----------|
| **Struktur project** | Layout folder identik di kelima studi kasus; package sesuai layer; penamaan konsisten (`XEntity`, `IXRepository`, `XRepository`, `XUseCase`, `XPresenter`, `XView`); `structure.txt` + README di tiap proyek |
| **Clean code** | Nama class/method/variabel deskriptif; method kecil satu tujuan; tanpa magic number (sort lewat enum, bukan angka); tanpa duplikasi logika repository (satu `InMemoryRepository` generik); Javadoc singkat pada tiap class dan method penting |
| **Best practice** | Validasi input di use case (field kosong, angka bulat > 0, ID, pilihan menu); custom checked exception (bukan return code boolean); tidak ada `catch` kosong; salinan defensif pada `findAll()`; entity immutable bila tidak perlu berubah; update parsial bersifat atomik; EOF input ditangani; ada test case otomatis |
| **Separation of concern** | Dependency rule ketat (`domain ← usecase ← adapter/framework`); use case tanpa `System.out/in`; presenter memegang semua format output (entity tanpa `toString()`); view hanya input + try-catch; port di domain, implementasi di adapter; wiring hanya di `App.java` |

## Catatan Desain

- **Format output**: label menu, prompt, dan pesan (termasuk `- X tidak ditemukan!` untuk pencarian kosong) mengikuti gaya contoh Latihan (Todo List) dan keluaran TC pada soal.
- **Pesan error**: `ValidationException` membawa pesan tanpa tanda baca akhir (mis. `Jumlah tidak valid`);
  `Presenter.showError()` yang menambahkan format `[!] ... !`. Format tampilan tetap menjadi urusan presenter.
- **Generics**: `IRepository<T, ID>` dan `InMemoryRepository<T, ID>` dipakai ulang oleh semua entity;
  `InputUtil.parseChoice(...)` adalah generic method untuk memilih opsi menu (dipakai pada menu pengurutan).
- **Menu pengurutan** dibangun otomatis dari `SortOption.values()` sehingga menambah opsi baru cukup
  dengan menambah konstanta enum dan labelnya di presenter.
