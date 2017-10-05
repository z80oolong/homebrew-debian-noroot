# z80oolong/debian-noroot -- Debian noroot 環境向けの Formula 群

## 概要

[Linuxbrew][BREW] とは、Linux の各ディストリビューションにおけるソースコードの取得及びビルドに基づいたパッケージ管理システムです。 [Linuxbrew][BREW] の使用により、ソースコードからのビルドに基づいたソフトウェアの導入を単純かつ容易に行うことが出来ます。

この [Linuxbrew][BREW] 向け Tap リポジトリは、 [pelya 氏][PELY]によって開発された [Android OS][ANDR] 上において root 権限を取ること無く、 [Debian 環境][DEBI]を構築するためのアプリケーションである [Debian noroot][DBNR] の環境に対応するアプリケーションをインストールする為の Formula 群を含む Tap リポジトリです。

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

なお、本リポジトリに含まれる Formula の一覧及びその詳細については、本リポジトリに同梱する ```FormulaList.md``` を参照して下さい。

## その他詳細について

その他、本リポジトリ及び [Linuxbrew][BREW] の使用についての詳細は ```brew help``` コマンド及び  ```man brew``` コマンドの内容、若しくは [Linuxbrew の公式ページ][BREW]を御覧下さい。

## 謝辞

まず最初に、 [Android OS][ANDR] 端末上で非常に軽快な [Debian 環境][DEBI]を実現することを可能にした [Debian noroot 環境][DBNR]の開発者である [pelya 氏][PELY]に心より感謝致します。

そして、[Linuxbrew][BREW] の導入に関しては、 [Linuxbrew の公式ページ][BREW] の他、 [thermes 氏][THER]による "[Linuxbrew のススメ][THBR]" 及び [Linuxbrew][BREW] 関連の各種資料を参考にしました。 [Linuxbrew の開発コミュニティ][BREW]及び[thermes 氏][THER]を始めとする各氏に心より感謝致します。

そして最後に、 [Debian noroot 環境][DBNR]と [Linuxbrew][BREW] の全ての事に関わる全ての皆様に心より感謝致します。

## 使用条件

本リポジトリは、 [Linuxbrew][BREW] の Tap リポジトリの一つとして、 [Linuxbrew の開発コミュニティ][BREW]及び [Z.OOL. (mailto:zool@zool.jpn.org)][ZOOL] が著作権を有し、[Linuxbrew][BREW] のライセンスと同様である [BSD 2-Clause License][BSD2] に基づいて配布されるものとします。詳細については、本リポジトリに同梱する ```LICENSE``` を参照して下さい。

<!-- 外部リンク一覧 -->

[BREW]:http://linuxbrew.sh/
[PELY]:https://github.com/pelya
[DBNR]:https://play.google.com/store/apps/details?id=com.cuntubuntu&hl=ja
[ANDR]:https://www.android.com/intl/ja_jp/
[DEBI]:https://www.debian.org/index.ja.html
[THER]:https://qiita.com/thermes
[THBR]:https://qiita.com/thermes/items/926b478ff6e3758ecfea
[BSD2]:https://opensource.org/licenses/BSD-2-Clause
[ZOOL]:http://zool.jpn.org/
