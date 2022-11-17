#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(realpath ${0%/*})
cd $SCRIPT_DIR

if [[ ! -d kotlinc ]]; then
  mkdir kotlinc
  curl -L https://github.com/JetBrains/kotlin/releases/download/v1.7.21/kotlin-native-linux-x86_64-1.7.21.tar.gz | \
  tar -xz --strip-components=1 -C kotlinc
fi

cat > hello.kt <<EOF
import foo.*
fun main() {
  println(foo())
}
EOF

cat > foo.h <<EOF
int foo(void);
EOF

cat > foo.c <<EOF
int foo(void) {
  return 42;
}
EOF

cat > foo.def <<EOF
headers = $PWD/foo.h
headerFilter = $PWD/foo.h
package = foo
EOF

gcc --shared foo.c -o libfoo.so

kotlinc/bin/cinterop -mode sourcecode -def foo.def -o foo

kotlinc/bin/kotlinc hello.kt -library foo -linker-options "-L$PWD -lfoo -Wl,-rpath=$PWD" -o hello

./hello.kexe
