# z80oolong/debian-noroot に含まれる Formula 一覧

## はじめに

本文書では、 [Linuxbrew][BREW] 向け Tap リポジトリ z80oolong/debian-noroot に含まれる Formula 一覧を示します。各 Formula の詳細等については ```brew info <formula>``` コマンドも参照して下さい。

なお、特段の断りのない限り、環境変数 ```HOMEBREW_PREFIX``` の値は [Linuxbrew][BREW] 本体のリポジトリのインストール先のパスであり、```brew --prefix``` コマンドが出力するパス名です。

## z80oolong/debian-noroot/dropbear

[Debian noroot 環境][DBNR]において正常に動作するよう修正された軽量 SSH サーバである [Dropbear][DROP] をインストールする為の Formula です。なお、 [Dropbear][DROP] の起動には、 ```$HOMEBREW_PREFIX/etc/dropbear.d``` スクリプトを使用して下さい。

## z80oolong/debian-noroot/libandroid-pty

[Debian noroot 環境][DBNR]において[擬似端末が正常に動作しない問題][PTYP]を解決するための動的ライブラリ [libandroid-pty.so][PTYS] をインストールする為の Formula です。

なお、動的ライブラリ [libandroid-pty.so][PTYS] は、環境変数 ```LD_PREOAD``` にパスを設定することによって使用する動的ライブラリであるため、 [libandroid-pty.so][PTYS] を導入する際は、通常のアプリケーションの実体のインストール先では無く、ディレクトリ ```$HOMEBREW_PREFIX/preload``` の物を使用して下さい。詳細については、本リポジトリに同梱する ```README.md``` における "注意点" の項目を参照して下さい。

## z80oolong/debian-noroot/libandroid-shmem
## z80oolong/debian-noroot/proot
## z80oolong/debian-noroot/talloc

<!-- 外部リンク一覧 -->

[BREW]:http://linuxbrew.sh/
[DBNR]:https://play.google.com/store/apps/details?id=com.cuntubuntu&hl=ja
[DROP]:https://matt.ucc.asn.au/dropbear/dropbear.html
