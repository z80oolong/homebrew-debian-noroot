# z80oolong/debian-noroot -- Debian noroot 環境向けの Formula 群

## 概要

[Linuxbrew][BREW] とは、Linux の各ディストリビューションにおけるソースコードの取得及びビルドに基づいたパッケージ管理システムです。 [Linuxbrew][BREW] の使用により、ソースコードからのビルドに基づいたソフトウェアの導入を単純かつ容易に行うことが出来ます。

この [Linuxbrew][BREW] 向け Tap リポジトリは、 [pelya 氏][PELY]によって開発された [Android OS][ANDR] 上において root 権限を取ること無く、 [Debian 環境][DEBI]を構築するためのアプリケーションである [Debian noroot][DBNR] に対応するアプリケーションをインストールする為の Formula 群です。

## 使用法

まず最初に、 [Linuxbrew の公式ページ][BREW]及び [thermes 氏][THER]による "[Linuxbrew のススメ][THBR]" の記事に基づいて、 [Debian noroot 環境][DBNR] に [Linuxbrew][BREW] を構築し、以下のように  ```brew tap``` コマンドを用いて本リポジトリを導入します。

そして、本リポジトリに含まれる Formula を以下のようにインストールします。

```
 $ brew tap z80oolong/debian-noroot
 $ brew install <formula>
```

なお、一時的な手法ですが、以下のようにして URL を直接指定してインストールすることも出来ます。

```
 $ brew install https://raw.githubusercontent.com/z80oolong/homebrew-debian-noroot/master/Formula/<formula>.rb
```

なお、本リポジトリに含まれる Formula の一覧については、本リポジトリに同梱する ```FormulaList.md``` を参照して下さい。

## 注意点

ここで、本リポジトリに含まれる Formula のうち、環境変数 ```LD_PREOAD``` にパスを設定することによって使用する動的ライブラリ及び [Debian noroot 環境][DBNR]を実現する為の ```proot``` をインストールするための Formula である ```z80oolong/debian-noroot/libandroid-pty``` 及び ```z80oolong/debian-noroot/proot``` 等の注意点について述べます。

これらの Formula は、動的ライブラリ及び ```proot``` コマンドを通常のアプリケーションの実体のインストール先である ```brew --cellar``` コマンドが出力するパスと同時に、ディレクトリ ```$HOMEBREW_PREFIX/preload``` にもインストールします。ここに、環境変数 ```HOMEBREW_PREFIX``` は [Linuxbrew][BREW] 本体のリポジトリのインストール先であり、 ```brew --prefix``` コマンドが出力するパス名です。

これらの動的ライブラリ及び ```proot``` を導入する際は、通常のアプリケーションの実体のインストール先では無く、ディレクトリ ```$HOMEBREW_PREFIX/preload``` の物を使用して下さい。例えば、本リポジトリに含まれる動的ライブラリ ```libandroid-pty.so``` を [Debian noroot 環境][DBNR]に導入するには、 ```brew install <formula>``` コマンドの実行後、 [Debian noroot 環境][DBNR]の初期化ファイル ```/proot.sh``` に以下のように記述します。

なお、設定についての詳細は、 ```brew install <formula>``` コマンドの完了時及び ```brew info <formula>``` の実行時に出力される Caveats メッセージも併せて参考にして下さい。

```
export HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew    # (ここに、環境変数 HOMEBREW_PREFIX の値は Linuxbrew 本体のリポジトリのパスを指定すること。)
export "LD_PRELOAD=/libdisableselinux.so /libandroid-shmem.so ${HOMEBREW_PREFIX}/preload/libandroid-pty-xxxxxxxx.so"    # (ここに、 xxxxxxxx は、インストール時刻によって決まる 8 桁の 16 進数)
```

これは、 [Linuxbrew][BREW] を用いてこれらの動的ライブラリ等を導入する際に、 ```brew install``` コマンドが既存に導入した動的ライブラリ等を削除若しくは上書きすることを防ぎ、```brew install``` コマンドの完了まで既存の動的ライブラリ等を残すことで、 [Debian noroot 環境][DBNR]全体が不具合を起こすのを防ぐ為です。

## その他詳細について

その他、本リポジトリ及び [Linuxbrew][BREW] の使用についての詳細は ```brew help``` コマンド及び  ```man brew``` コマンドの内容、若しくは [Linuxbrew の公式ページ][BREW]を御覧下さい。

## 謝辞

まず最初に、 [Android OS][ANDR] 端末上で非常に軽快な [Debian 環境][DEBI]を実現することを可能にした [Debian noroot 環境][DBNR]の開発者である [pelya 氏][PELY]に心より感謝致します。

そして、[Linuxbrew][BREW] の導入に関しては、 [thermes 氏][THER]による "[Linuxbrew のススメ][THBR]" 及び [Linuxbrew][BREW] 関連の各種資料を参考にしました。 [thermes 氏][THER]を始めとする各氏に心より感謝致します。

そして最後に、 [Debian noroot 環境][DBNR]と [Linuxbrew][BREW] の全ての事に関わる全ての皆様に心より感謝致します。

## 使用条件

本リポジトリは、 [Linuxbrew][BREW] のライセンスと同様である [BSD 2-Clause License][BSD2] に基づいて配布されるものとします。詳細については、本リポジトリに同梱する ```LICENSE``` を参照して下さい。

<!-- 外部リンク一覧 -->

[BREW]:http://linuxbrew.sh/
[PELY]:https://github.com/pelya
[DBNR]:https://play.google.com/store/apps/details?id=com.cuntubuntu&hl=ja
[ANDR]:https://www.android.com/intl/ja_jp/
[DEBI]:https://www.debian.org/index.ja.html
[THER]:https://qiita.com/thermes
[THBR]:https://qiita.com/thermes/items/926b478ff6e3758ecfea
[BSD2]:https://opensource.org/licenses/BSD-2-Clause
