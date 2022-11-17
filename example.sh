#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(realpath ${0%/*})
cd $SCRIPT_DIR

if [[ ! -d kotlinc ]]; then
  curl -LO https://github.com/JetBrains/kotlin/releases/download/v1.7.21/kotlin-compiler-1.7.21.zip
  unzip ./*.zip
  rm ./*.zip
fi

cat > hello.kt <<EOF
fun main() {
  println("hello, world!")
}
EOF

kotlinc/bin/kotlinc hello.kt -include-runtime -d hello.jar
java -jar hello.jar
rm hello.kt hello.jar
