# プログラミングフォント 白源 (はくげん／HackGen)

HackGen is a composite font of Hack and GenJyuu-Gothic.

白源 (はくげん／HackGen) は、プログラミング向け英文フォント Hack と、源ノ角ゴシックの派生フォント源柔ゴシックを合成したプログラミングフォントです。

|**白源 通常版**|**白源 半角3:全角5 版**|
|:------------------------:|:------------------------:|
|![hackgen](https://github.com/yuru7/HackGen/raw/image/sc_hackgen.png)|![hackgen35](https://github.com/yuru7/HackGen/raw/image/sc_hackgen35.png)|

ビルド済みの ttf ファイルは GitHub のリリースページからダウンロードできます。

[Release - HackGen](https://github.com/yuru7/HackGen/releases)

Mac の Homebrew ユーザーは以下のコマンドでインストールすることができます。  
※Homebrew リポジトリに追加してくださったのはユーザーさんなので、使用方法などをリポジトリオーナーはサポートできません。悪しからずご了承ください。

```
$ brew tap homebrew/cask-fonts
$ brew cask install font-hackgen
$ brew cask install font-hackgen-nerd
```

特徴などの詳しい説明は以下の記事を参照してください。

[Ricty を神フォントだと崇める僕が、フリーライセンスのプログラミングフォント「白源」を作った話](https://qiita.com/tawara_/items/374f3ca0a386fab8b305)

# ビルド環境

HackGen は以下の環境でビルドしています。

* OS: Ubuntu 18.04
* Tools
  * ttfautohint: 1.8.1
  * fonttools: 3.44.0
  * fontforge: fontforge 11:21 UTC 24-Sep-2017

## インストール方法と注意点

* ttfautohint: `sudo apt install ttfautohint`
* fonttools: Python 2 の pip で `pip install fonttools`
  * fonttools に含まれるサブツール `pyftmerge` と `ttx` をコマンドとして利用しているため、fonttools インストール後、該当コマンドがインストールされているディレクトリに PATH を通すこと (一般ユーザー権限でインストールした場合は `~/.local/bin/` 内に展開されている)
  * Python 3 の pip を使ったものは fonttools 4.13.0 がインストールされる (2020/08/01 時点)。 fonttools 4.13.0 では post テーブルの構造が変わってしまうため、macOS 10.15 にてインストール不可となる ([#12](https://github.com/yuru7/HackGen/issues/12))
* fontforge: Personal Package Archive (PPA) を追加した後に `sudo apt-get install fontforge` (詳細は [こちら](http://designwithfontforge.com/en-US/Installing_Fontforge.html))
