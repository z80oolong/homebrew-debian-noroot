# z80oolong/debian-noroot に含まれる Formula 一覧

## 概要

本文書では、 [Linuxbrew][BREW] 向け Tap リポジトリ z80oolong/debian-noroot に含まれる Formula 一覧を示します。各 Formula の詳細等については ```brew info <formula>``` コマンドも参照して下さい。

なお、特段の断りのない限り、環境変数 ```HOMEBREW_PREFIX``` の値は [Linuxbrew][BREW] 本体のリポジトリのインストール先のパスであり、```brew --prefix``` コマンドが出力するパス名です。

## Formula 一覧

### z80oolong/debian-noroot/dropbear

[Debian noroot 環境][DBNR]において正常に動作するよう修正された軽量 SSH サーバである [Dropbear][DROP] をインストールする為の Formula です。詳細については、 "[Debian noroot 環境において dropbear に基づく SSH サーバを導入する][DRPQ]" の記事をご覧下さい。

なお、 [Dropbear][DROP] の起動には、 ```$HOMEBREW_PREFIX/etc/dropbear.d``` スクリプトを使用して下さい。

### z80oolong/debian-noroot/libandroid-pty

[Debian noroot 環境][DBNR]において[擬似端末が正常に動作しない問題][PTYP]を解決するための動的ライブラリ [libandroid-pty.so][PTYS] をインストールする為の Formula です。

なお、動的ライブラリ [libandroid-pty.so][PTYS] は、環境変数 ```LD_PREOAD``` にパスを設定することによって使用する動的ライブラリであるため、 [libandroid-pty.so][PTYS] を導入する際は、通常のアプリケーションの実体のインストール先では無く、ディレクトリ ```$HOMEBREW_PREFIX/preload``` の物を使用して下さい。詳細については、後述する "一部 Formula に関する注意点" の項目を参照して下さい。

### z80oolong/debian-noroot/libandroid-shmem

[Termux の開発コミュニティ][TMUX]によって [Debian noroot 環境][DBNR]より Termux に移植された、共有メモリ関連の標準 C ライブラリ関数を /dev/ashmem によってエミュレートする[動的ライブラリ][SHMT]を再度 [Debian noroot 環境][DBNR] に移植したものをインストールするための Formula です。詳細については、 "[Termux に移植された libandroid-shmem.so を Debian noroot 環境に再移植するための差分ファイル][SHMG]" の記事を参照して下さい。

なお、動的ライブラリ [libandroid-shmem.so][SHMT] は、環境変数 ```LD_PREOAD``` にパスを設定することによって使用する動的ライブラリであるため、 [libandroid-shmem.so][SHMT] を導入する際は、通常のアプリケーションの実体のインストール先では無く、ディレクトリ ```$HOMEBREW_PREFIX/preload``` の物を使用して下さい。詳細については、後述する "一部 Formula に関する注意点" の項目を参照して下さい。

### z80oolong/debian-noroot/proot

[Termux の開発コミュニティ][TMUX]による [link2symlink 機能に対応した proot][TMPR] をインストールするための Formula です。詳細については、 "[Debian noroot 環境において link2symlink 機能を実装した proot を導入する][TMPQ]" の記事を参照して下さい。

なお、 link2symlink 機能に対応した [proot][TMPR] は、 [Debian noroot 環境][DBNR]の初期化ファイルである ```/proot.sh``` に設定を行うアプリケーションであるため、 [proot][TMPR] を導入する際は、通常のアプリケーションの実体のインストール先では無く、ディレクトリ ```$HOMEBREW_PREFIX/preload``` の物を使用して下さい。詳細については、後述する "一部 Formula に関する注意点" の項目を参照して下さい。

### z80oolong/debian-noroot/talloc

メモリ管理ライブラリである [talloc 2.1.10][TLOC] をインストールするための Formula です。オリジナルの [talloc][TLOC] の Formula と異なり、動的ライブラリの他に静的ライブラリもインストールします。

前述の Formula である ```z80oolong/debian-noroot/proot``` に依存する Formula です。

## 一部 Formula に関する注意点

ここで、本リポジトリに含まれる Formula のうち、環境変数 ```LD_PREOAD``` にパスを設定することによって使用する動的ライブラリ及び [Debian noroot 環境][DBNR]を実現する為の ```proot``` をインストールするための Formula である ```z80oolong/debian-noroot/libandroid-pty``` 及び ```z80oolong/debian-noroot/proot``` 等の注意点について述べます。

これらの Formula は、動的ライブラリ及び ```proot``` コマンドを通常のアプリケーションの実体のインストール先である ```brew --cellar``` コマンドが出力するパスと同時に、ディレクトリ ```$HOMEBREW_PREFIX/preload``` にもインストールします。ここに、環境変数 ```HOMEBREW_PREFIX``` は [Linuxbrew][BREW] 本体のリポジトリのインストール先であり、 ```brew --prefix``` コマンドが出力するパス名です。

これらの動的ライブラリ及び ```proot``` を導入する際は、通常のアプリケーションの実体のインストール先では無く、ディレクトリ ```$HOMEBREW_PREFIX/preload``` の物を使用して下さい。例えば、本リポジトリに含まれる動的ライブラリ ```libandroid-pty.so``` を [Debian noroot 環境][DBNR]に導入するには、 ```brew install <formula>``` コマンドの実行後、 [Debian noroot 環境][DBNR]の初期化ファイル ```/proot.sh``` に以下のように記述します。

なお、設定についての詳細は、 ```brew install <formula>``` コマンドの完了時及び ```brew info <formula>``` の実行時に出力される Caveats メッセージも併せて参考にして下さい。

```
export HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew    # (ここに、環境変数 HOMEBREW_PREFIX の値は Linuxbrew 本体のリポジトリのパスを指定すること。)
export "LD_PRELOAD=/libdisableselinux.so /libandroid-shmem.so ${HOMEBREW_PREFIX}/preload/libandroid-pty-xxxxxxxx.so"    # (ここに、 xxxxxxxx は、インストール時刻によって決まる 8 桁の 16 進数)
```

これは、 [Linuxbrew][BREW] を用いてこれらの動的ライブラリ等を導入する際に、 ```brew install``` コマンドが既存に導入した動的ライブラリ等を削除若しくは上書きすることを防ぎ、```brew install``` コマンドの完了まで既存の動的ライブラリ等を残すことで、 [Debian noroot 環境][DBNR]全体が不具合を起こすのを防ぐ為です。

<!-- 外部リンク一覧 -->

[BREW]:http://linuxbrew.sh/
[DBNR]:https://play.google.com/store/apps/details?id=com.cuntubuntu&hl=ja
[DROP]:https://matt.ucc.asn.au/dropbear/dropbear.html
[DRPQ]:https://qiita.com/z80oolong/items/7bdfc322fa586f5d4a30
[PTYP]:https://qiita.com/z80oolong/items/d3585cd5542d3d60ce12
[PTYS]:https://github.com/z80oolong/libandroid-pty
[TMUX]:https://termux.com/
[SHMT]:https://github.com/termux/libandroid-shmem
[SHMG]:https://gist.github.com/z80oolong/247dbbb0a7d83a1dea98de2939327432
[TMPR]:https://github.com/termux/proot
[TMPQ]:https://qiita.com/z80oolong/items/20a1cc75722b98bd3a2c
[TLOC]:https://talloc.samba.org/talloc/doc/html/index.html
