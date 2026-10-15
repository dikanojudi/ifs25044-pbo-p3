#!/usr/bin/env bash
# Menjalankan seluruh test case (test-cases/TC-*.tc) pada setiap studi kasus.
# Setiap baris pada TC-XX.expected harus muncul pada output program, sesuai urutan.
#
# Pemakaian:
#   ./run-tests.sh                   # semua studi kasus
#   ./run-tests.sh buku-tamu         # satu studi kasus saja

set -u

ROOT="$(cd "$(dirname "$0")" && pwd)"
PROJECTS=(catatan-keuangan buku-tamu inventaris-barang jadwal-kegiatan kontak-teman)
if [ $# -gt 0 ]; then
    PROJECTS=("$@")
fi

passed=0
failed=0

# Mengembalikan 0 jika semua baris expected ($1) ditemukan berurutan pada output ($2).
# Baris expected pertama yang tidak ditemukan dicetak ke stdout.
check_expected() {
    awk '
        BEGIN { idx = 1 }
        NR == FNR { sub(/\r$/, ""); if ($0 != "") expected[++total] = $0; next }
        { if (idx <= total && index($0, expected[idx]) > 0) idx++ }
        END { if (idx > total) exit 0; print expected[idx]; exit 1 }
    ' "$1" "$2"
}

for project in "${PROJECTS[@]}"; do
    dir="$ROOT/$project"
    out="$(mktemp -d)"
    echo "== $project"

    if ! javac -d "$out" -sourcepath "$dir/src" "$dir/src/App.java"; then
        echo "   [GAGAL] compile error"
        failed=$((failed + 1))
        rm -rf "$out"
        continue
    fi

    for input in "$dir"/test-cases/TC-*.tc; do
        name="$(basename "$input" .tc)"
        actual="$(mktemp)"
        java -cp "$out" App < "$input" > "$actual"

        if missing="$(check_expected "$dir/test-cases/$name.expected" "$actual")"; then
            echo "   [LULUS] $name"
            passed=$((passed + 1))
        else
            echo "   [GAGAL] $name -> baris tidak ditemukan: $missing"
            failed=$((failed + 1))
        fi
        rm -f "$actual"
    done
    rm -rf "$out"
done

echo
echo "Ringkasan: $passed lulus, $failed gagal"
[ "$failed" -eq 0 ]
