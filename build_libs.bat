clang -c -g -gcodeview -o libcsv.lib -target x86_64-pc-windows -fuse-ld=llvm-lib -Wall libcsv\libcsv.c

mkdir libs
move libcsv.lib libs
