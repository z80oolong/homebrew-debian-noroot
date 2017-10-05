# z80oolong/debian-noroot に含まれる Formula 一覧

## はじめに

本文書では、 [Linuxbrew][BREW] 向け Tap リポジトリ z80oolong/debian-noroot に含まれる Formula 一覧を示します。各 Formula の詳細等については ```brew info <formula>``` コマンドも参照して下さい。

なお、特段の断りのない限り、環境変数 ```HOMEBREW_PREFIX``` の値は [Linuxbrew][BREW] 本体のリポジトリのインストール先のパスであり、```brew --prefix``` コマンドが出力するパス名です。

## z80oolong/debian-noroot/dropbear

[Debian noroot 環境][DBNR]において正常に動作するよう修正された軽量 SSH サーバである [Dropbear][DROP] をインストールする為の Formula です。



なお、 [Dropbear][DROP] の起動には、 ```$HOMEBREW_PREFIX/etc/dropbear.d``` スクリプトを使用して下さい。

## z80oolong/debian-noroot/libandroid-pty

[Debian noroot 環境][DBNR]において[擬似端末が正常に動作しない問題][PTYP]を解決するための動的ライブラリ [libandroid-pty.so][PTYS] をインストールする為の Formula です。

なお、動的ライブラリ [libandroid-pty.so][PTYS] は、環境変数 ```LD_PREOAD``` にパスを設定することによって使用する動的ライブラリであるため、 [libandroid-pty.so][PTYS] を導入する際は、通常のアプリケーションの実体のインストール先では無く、ディレクトリ ```$HOMEBREW_PREFIX/preload``` の物を使用して下さい。詳細については、本リポジトリに同梱する ```README.md``` における "注意点" の項目を参照して下さい。

## z80oolong/debian-noroot/libandroid-shmem

[Termux の開発コミュニティ][TMUX]によって [Debian noroot 環境][DBNR]より Termux に移植された、共有メモリ関連の標準 C ライブラリ関数を /dev/ashmem によってエミュレートする[動的ライブラリ][SHMT]を再度 [Debian noroot 環境][DBNR] に移植したものをインストールするための Formula です。

詳細については、 "[Termux に移植された libandroid-shmem.so を Debian noroot 環境に再移植するための差分ファイル][SHMG]" の記事を参照して下さい。

なお、動的ライブラリ [libandroid-shmem.so][SHMT] は、環境変数 ```LD_PREOAD``` にパスを設定することによって使用する動的ライブラリであるため、 [libandroid-shmem.so][SHMT] を導入する際は、通常のアプリケーションの実体のインストール先では無く、ディレクトリ ```$HOMEBREW_PREFIX/preload``` の物を使用して下さい。詳細については、本リポジトリに同梱する ```README.md``` における "注意点" の項目を参照して下さい。

## z80oolong/debian-noroot/proot

[Termux の開発コミュニティ][TMUX]による [link2symlink 機能に対応した proot][TMPR] をインストールするための Formula です。

詳細については、 "[Debian noroot 環境において link2symlink 機能を実装した proot を導入する][TMPQ]" の記事を参照して下さい。

なお、 link2symlink 機能に対応した [proot][TMPR] は、 [Debian noroot 環境][DBNR]の初期化ファイルである ```/proot.sh``` に設定を行うアプリケーションであるため、 [proot][TMPR] を導入する際は、通常のアプリケーションの実体のインストール先では無く、ディレクトリ ```$HOMEBREW_PREFIX/preload``` の物を使用して下さい。詳細については、本リポジトリに同梱する ```README.md``` における "注意点" の項目を参照して下さい。

## z80oolong/debian-noroot/talloc

メモリ管理ライブラリである [talloc 2.1.10][TLOC] をインストールするための Formula です。オリジナルの [talloc][TLOC] の Formula と異なり、動的ライブラリの他に静的ライブラリもインストールします。

前述の Formula である ```z80oolong/debian-noroot/proot``` に依存する Formula です。

<!-- 外部リンク一覧 -->

[BREW]:http://linuxbrew.sh/
[DBNR]:https://play.google.com/store/apps/details?id=com.cuntubuntu&hl=ja
[DROP]:https://matt.ucc.asn.au/dropbear/dropbear.html
[PTYP]:https://qiita.com/z80oolong/items/d3585cd5542d3d60ce12
[PTYS]:https://github.com/z80oolong/libandroid-pty
[TMUX]:https://termux.com/
[SHMT]:https://github.com/termux/libandroid-shmem
[SHMG]:https://gist.github.com/z80oolong/247dbbb0a7d83a1dea98de2939327432
[TMPR]:https://github.com/termux/proot
[TMPQ]:https://qiita.com/z80oolong/items/20a1cc75722b98bd3a2c
[TLOC]:https://talloc.samba.org/talloc/doc/html/index.html
