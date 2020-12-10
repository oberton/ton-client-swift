commandExist() {
  which $1 > /dev/null && echo '1' && return;
  echo '0';
}

if [ $(commandExist 'cargo') == "1" ]; then
  echo "RUST ALREADY INSTALLED TO YOUR OS";
else
  echo "CARGO NOT FOUND";
  echo "INSTALL RUST TO YOUR OS ?";
  echo "y / n ?";
  read answer
  if [ $answer == "y" ]; then
    if [ $(commandExist 'curl') != "1" ]; then
      echo "Please install curl";
      exit 0;
    fi
    echo "INSTALL RUST...";
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    bash
  else
    echo "RUST NOT INSTALLED. EXIT.";
    exit 0;
  fi
fi;

if [ -d "./TON-SDK" ]; then
  echo "TON-SDK FOLDER ALREADY EXISTS"
else
  git clone https://github.com/tonlabs/TON-SDK.git
fi

mkdir -p ./dependencies/ton-sdk/include
mkdir -p ./dependencies/ton-sdk/lib
cd ./TON-SDK
cargo update
cargo build --release

HEADER="$(pwd)/ton_client/tonclient.h"

echo ""
if [ -f "$HEADER" ]; then
  echo "CHECK: $HEADER - EXIST"
else
  echo ""
  echo "ERROR: $HEADER - FILE NOT FOUND"
  exit 1;
fi

echo ""
echo "Create symbolic link tonclient.h"
ln -s $HEADER "$(pwd)/../dependencies/ton-sdk/include/tonclient.h" || echo "OK: symbolic link tonclient.h already exist"

if [ `uname -s` = Linux ]; then
  DYLIB="$(pwd)/target/release/libton_client.so"
  echo ""
  echo "Create symbolic link libton_client.so"
  ln -s $DYLIB "$(pwd)/../dependencies/ton-sdk/lib/libton_client.so" || echo "OK: symbolic link libton_client.so already exist"
elif [ `uname -s` = Darwin ]; then
  DYLIB="$(pwd)/target/release/libton_client.dylib"
  echo ""
  echo "Create symbolic link libton_client.dylib"
  ln -s $DYLIB "$(pwd)/../dependencies/ton-sdk/lib/libton_client.dylib" || echo "OK: symbolic link libton_client.dylib already exist"
fi

echo $'\nINSTALLATION TON-SDK COMPLETE'
















