# z80oolong/debian-noroot に含まれる Formula 一覧

## 概要

本文書では、 [Linuxbrew][BREW] 向け Tap リポジトリ z80oolong/debian-noroot に含まれる Formula 一覧を示します。各 Formula の詳細等については ```brew info <formula>``` コマンドも参照して下さい。

なお、特段の断りのない限り、環境変数 ```HOMEBREW_PREFIX``` の値は [Linuxbrew][BREW] 本体のリポジトリのインストール先のパスであり、```brew --prefix``` コマンドが出力するパス名です。

## Formula 一覧

### z80oolong/debian-noroot/dropbear

[Debian noroot 環境][DBNR]において正常に動作するよう修正された軽量 SSH サーバである [Dropbear][DROP] をインストールする為の Formula です。詳細については、 "[Debian noroot 環境において dropbear に基づく SSH サーバを導入する][DRPQ]" の記事をご覧下さい。

なお、 [Dropbear][DROP] の起動には、 ```$HOMEBREW_PREFIX/etc/dropbear/dropbear.d``` スクリプトを使用して下さい。

### z80oolong/debian-noroot/dropbear@2017.75

[Debian noroot 環境][DBNR]において正常に動作するよう修正された軽量 SSH サーバである [Dropbear][DROP] の旧安定版である dropbear-2017.75 をインストールする為の Formula です。

なお、 [Dropbear][DROP] の起動には、 ```$HOMEBREW_PREFIX/etc/dropbear@2017.75/dropbear.d``` スクリプトを使用して下さい。

**この Formula は、 versioned formula であるため、この Formula によって導入される [Dropbear][DROP] は、 keg only で導入されることに留意して下さい。**

### z80oolong/debian-noroot/dropbear@2018.76

[Debian noroot 環境][DBNR]において正常に動作するよう修正された軽量 SSH サーバである [Dropbear][DROP] の現行の安定版である dropbear-2018.76 をインストールする為の Formula です。

なお、 [Dropbear][DROP] の起動には、 ```$HOMEBREW_PREFIX/etc/dropbear@2018.76/dropbear.d``` スクリプトを使用して下さい。

**この Formula は、 versioned formula であるため、この Formula によって導入される [Dropbear][DROP] は、 keg only で導入されることに留意して下さい。**

### z80oolong/debian-noroot/openssh

[Debian noroot 環境][DBNR]において正常に動作するよう修正された標準的な SSH サーバである [OpenSSH][OSSH] をインストールする為の Formula です。

なお、 [OpenSSH][OSSH] の起動には、 ```$HOMEBREW_PREFIX/etc/ssh/openssh.d``` スクリプトを使用して下さい。

### z80oolong/debian-noroot/libandroid-pty

[Debian noroot 環境][DBNR]において[擬似端末が正常に動作しない問題][PTYP]を解決するための動的ライブラリ [libandroid-pty.so][PTYS] をインストールする為の Formula です。

なお、動的ライブラリ [libandroid-pty.so][PTYS] は、環境変数 ```LD_PRELOAD``` にパスを設定することによって使用する動的ライブラリであるため、 **[libandroid-pty.so][PTYS] の実体は、ディレクトリ ```$HOMEBREW_PREFIX/preload``` にインストールされることに留意して下さい。**

詳細については、後述する "一部 Formula に関する注意点" の項目を参照して下さい。

### z80oolong/debian-noroot/libandroid-shmem

[Termux の開発コミュニティ][TMUX]によって [Debian noroot 環境][DBNR]より Termux に移植された、共有メモリ関連の標準 C ライブラリ関数を /dev/ashmem によってエミュレートする[動的ライブラリ][SHMT]を再度 [Debian noroot 環境][DBNR] に移植したものをインストールするための Formula です。詳細については、 "[Termux に移植された libandroid-shmem.so を Debian noroot 環境に再移植するための差分ファイル][SHMG]" の記事を参照して下さい。

なお、動的ライブラリ [libandroid-shmem.so][SHMT] は、環境変数 ```LD_PRELOAD``` にパスを設定することによって使用する動的ライブラリであるため、 **[libandroid-shmem.so][SHMT] のの実体は、ディレクトリ ```$HOMEBREW_PREFIX/preload``` にインストールされることに留意して下さい。**

詳細については、後述する "一部 Formula に関する注意点" の項目を参照して下さい。

### z80oolong/debian-noroot/proot

[Termux の開発コミュニティ][TMUX]による [link2symlink 機能に対応した proot][TMPR] をインストールするための Formula です。詳細については、 "[Debian noroot 環境において link2symlink 機能を実装した proot を導入する][TMPQ]" の記事を参照して下さい。

なお、 link2symlink 機能に対応した [proot][TMPR] は、 [Debian noroot 環境][DBNR]の初期化ファイルである ```/proot.sh``` に設定を行うアプリケーションであるため、 **[proot][TMPR] の実体は、ディレクトリ ```$HOMEBREW_PREFIX/preload``` にインストールされることに留意して下さい。**

詳細については、後述する "一部 Formula に関する注意点" の項目を参照して下さい。

### z80oolong/debian-noroot/proot@0.5.1

[Termux の開発コミュニティ][TMUX]による [link2symlink 機能に対応した proot][TMPR] の旧版である 0.5.1 をインストールするための Formula です。詳細については、 "[Debian noroot 環境において link2symlink 機能を実装した proot を導入する][TMPQ]" の記事を参照して下さい。

なお、 link2symlink 機能に対応した [proot][TMPR] は、 [Debian noroot 環境][DBNR]の初期化ファイルである ```/proot.sh``` に設定を行うアプリケーションであるため、 **[proot][TMPR] の実体は、ディレクトリ ```$HOMEBREW_PREFIX/preload``` にインストールされることに留意して下さい。**

詳細については、後述する "一部 Formula に関する注意点" の項目を参照して下さい。

### z80oolong/debian-noroot/proot@0.5

[Termux の開発コミュニティ][TMUX]による [link2symlink 機能に対応した proot][TMPR] の旧安定版である 0.5 をインストールするための Formula です。詳細については、 "[Debian noroot 環境において link2symlink 機能を実装した proot を導入する][TMPQ]" の記事を参照して下さい。

なお、 link2symlink 機能に対応した [proot][TMPR] は、 [Debian noroot 環境][DBNR]の初期化ファイルである ```/proot.sh``` に設定を行うアプリケーションであるため、 **[proot][TMPR] の実体は、ディレクトリ ```$HOMEBREW_PREFIX/preload``` にインストールされることに留意して下さい。**

詳細については、後述する "一部 Formula に関する注意点" の項目を参照して下さい。

### z80oolong/debian-noroot/proot@0.6

[Termux の開発コミュニティ][TMUX]による [link2symlink 機能に対応した proot][TMPR] の旧安定版である 0.6 をインストールするための Formula です。詳細については、 "[Debian noroot 環境において link2symlink 機能を実装した proot を導入する][TMPQ]" の記事を参照して下さい。

なお、 link2symlink 機能に対応した [proot][TMPR] は、 [Debian noroot 環境][DBNR]の初期化ファイルである ```/proot.sh``` に設定を行うアプリケーションであるため、 **[proot][TMPR] の実体は、ディレクトリ ```$HOMEBREW_PREFIX/preload``` にインストールされることに留意して下さい。**

詳細については、後述する "一部 Formula に関する注意点" の項目を参照して下さい。

### z80oolong/debian-noroot/proot@0.7

[Termux の開発コミュニティ][TMUX]による [link2symlink 機能に対応した proot][TMPR] の旧安定版である 0.7 をインストールするための Formula です。詳細については、 "[Debian noroot 環境において link2symlink 機能を実装した proot を導入する][TMPQ]" の記事を参照して下さい。

なお、 link2symlink 機能に対応した [proot][TMPR] は、 [Debian noroot 環境][DBNR]の初期化ファイルである ```/proot.sh``` に設定を行うアプリケーションであるため、 **[proot][TMPR] の実体は、ディレクトリ ```$HOMEBREW_PREFIX/preload``` にインストールされることに留意して下さい。**

詳細については、後述する "一部 Formula に関する注意点" の項目を参照して下さい。

### z80oolong/debian-noroot/proot@0.8

[Termux の開発コミュニティ][TMUX]による [link2symlink 機能に対応した proot][TMPR] の旧安定版である 0.8 をインストールするための Formula です。詳細については、 "[Debian noroot 環境において link2symlink 機能を実装した proot を導入する][TMPQ]" の記事を参照して下さい。

なお、 link2symlink 機能に対応した [proot][TMPR] は、 [Debian noroot 環境][DBNR]の初期化ファイルである ```/proot.sh``` に設定を行うアプリケーションであるため、 **[proot][TMPR] の実体は、ディレクトリ ```$HOMEBREW_PREFIX/preload``` にインストールされることに留意して下さい。**

詳細については、後述する "一部 Formula に関する注意点" の項目を参照して下さい。

### z80oolong/debian-noroot/proot@5.1.0.109

[Termux の開発コミュニティ][TMUX]による [link2symlink 機能に対応した proot][TMPR] の現行版である 5.1.0.109 をインストールするための Formula です。詳細については、 "[Debian noroot 環境において link2symlink 機能を実装した proot を導入する][TMPQ]" の記事を参照して下さい。

なお、 link2symlink 機能に対応した [proot][TMPR] は、 [Debian noroot 環境][DBNR]の初期化ファイルである ```/proot.sh``` に設定を行うアプリケーションであるため、 **[proot][TMPR] の実体は、ディレクトリ ```$HOMEBREW_PREFIX/preload``` にインストールされることに留意して下さい。**

詳細については、後述する "一部 Formula に関する注意点" の項目を参照して下さい。

### z80oolong/debian-noroot/talloc@2.1.11

メモリ管理ライブラリである [talloc 2.1.11][TLOC] をインストールするための Formula です。オリジナルの [talloc][TLOC] の Formula と異なり、動的ライブラリの他に静的ライブラリもインストールします。

前述の Formula である ```z80oolong/debian-noroot/proot@{0.5,0.5.1,0.6}``` に依存する Formula です。

**なお、この Formula は、 versioned formula であるため、この Formula によって導入される [talloc][TLOC] は、 keg only で導入されることに留意して下さい。**

### z80oolong/debian-noroot/talloc@2.1.14

メモリ管理ライブラリである [talloc 2.1.14][TLOC] をインストールするための Formula です。オリジナルの [talloc][TLOC] の Formula と異なり、動的ライブラリの他に静的ライブラリもインストールします。

前述の Formula である ```z80oolong/debian-noroot/proot, z80oolong/debian-noroot/proot@{0.7,0.8,5.1.0.109}``` に依存する Formula です。

**なお、この Formula は、 versioned formula であるため、この Formula によって導入される [talloc][TLOC] は、 keg only で導入されることに留意して下さい。**

### z80oolong/debian-noroot/krb5@1.16

Kerberos 認証の実装系ライブラリである [krb5 1.16][KRB5] をインストールするための Formula です。オリジナルの [KRB5][KRB5] の Formula と異なり、 [LibreSSL][LIBS] に対応する修正が適用されています。

前述の Formula である ```z80oolong/debian-noroot/openssh``` に依存する Formula です。

**なお、この Formula は、 versioned formula であるため、この Formula によって導入される [KRB5][KRB5] は、 keg only で導入されることに留意して下さい。**

## 一部 Formula に関する注意点

ここで、本リポジトリに含まれる Formula のうち、環境変数 ```LD_PRELOAD``` にパスを設定することによって使用する動的ライブラリ及び [Debian noroot 環境][DBNR]を実現する為の ```proot``` をインストールするための Formula である ```z80oolong/debian-noroot/libandroid-pty``` 及び ```z80oolong/debian-noroot/proot``` 等の注意点について述べます。

これらの Formula は、動的ライブラリ及び ```proot``` コマンドの実体を通常のアプリケーションの実体のインストール先である ```brew --cellar``` コマンドが出力するパスでは無く、ディレクトリ ```$HOMEBREW_PREFIX/preload``` にインストールします。

(なお、厳密にはこれらのアプリケーションの実体は、ディレクトリ ```$HOMEBREW_PREFIX/preload/{libandroid-pty, libandroid-shmem, proot.bin...}``` 以下に、 ```{libandroid-pty-xxxxxxxx.so, libandroid-shmem-xxxxxxxx.so, proot-xxxxxxxx.bin, ...} (ここに、 xxxxxxxx は、インストール時刻によって決まる 8 桁の 16 進数)``` としてインストールされ、これらの実体から ```$HOMEBREW_PREFIX/preload/{libandroid-pty.so, libandroid-shmem.so, proot}``` にシンボリックリンクが張られます。)

従って、これらの Formula によって導入された動的ライブラリ及び ```proot``` コマンドを使用するには、 ディレクトリ ```$HOMEBREW_PREFIX/preload``` 以下に置かれたものを使用する必要があります。

例えば、本リポジトリに含まれる動的ライブラリ ```libandroid-pty.so``` を [Debian noroot 環境][DBNR]に導入するには、 ```brew install <formula>``` コマンドの実行後、 [Debian noroot 環境][DBNR]の初期化ファイル ```/proot.sh``` に以下のように記述します。

なお、設定についての詳細は、 ```brew install <formula>``` コマンドの完了時及び ```brew info <formula>``` の実行時に出力される Caveats メッセージも併せて参考にして下さい。

```
export HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew    # (ここに、環境変数 HOMEBREW_PREFIX の値は Linuxbrew 本体のリポジトリのパスを指定すること。)
export "LD_PRELOAD=/libdisableselinux.so /libandroid-shmem.so ${HOMEBREW_PREFIX}/preload/libandroid-pty.so"
```

これは、 [Linuxbrew][BREW] を用いてこれらの動的ライブラリ等を導入する際に、 ```brew install``` コマンドが既存に導入した動的ライブラリ等を削除若しくは上書きすることを防ぎ、```brew install``` コマンドの完了まで既存の動的ライブラリ等を残すことで、 [Debian noroot 環境][DBNR]全体が不具合を起こすのを防ぐ為です。

<!-- 外部リンク一覧 -->

[BREW]:https://linuxbrew.sh/
[DBNR]:https://play.google.com/store/apps/details?id=com.cuntubuntu&hl=ja
[DROP]:https://matt.ucc.asn.au/dropbear/dropbear.html
[OSSH]:https://www.openssh.com/
[DRPQ]:https://qiita.com/z80oolong/items/7bdfc322fa586f5d4a30
[PTYP]:https://qiita.com/z80oolong/items/d3585cd5542d3d60ce12
[PTYS]:https://github.com/z80oolong/libandroid-pty
[TMUX]:https://termux.com/
[SHMT]:https://github.com/termux/libandroid-shmem
[SHMG]:https://gist.github.com/z80oolong/247dbbb0a7d83a1dea98de2939327432
[TMPR]:https://github.com/termux/proot
[TMPQ]:https://qiita.com/z80oolong/items/20a1cc75722b98bd3a2c
[TLOC]:https://talloc.samba.org/talloc/doc/html/index.html
[KRB5]:https://web.mit.edu/kerberos/
