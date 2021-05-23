# プログラミングフォント 白源 (はくげん／HackGen)

HackGen is a composite font of Hack and GenJyuu-Gothic.

白源 (はくげん／HackGen) は、プログラミング向け英文フォント Hack と、源ノ角ゴシックの派生フォント源柔ゴシックを合成したプログラミングフォントです。

特徴などの詳しい説明は以下の記事を参照してください。  
**[Ricty を神フォントだと崇める僕が、フリーライセンスのプログラミングフォント「白源」を作った話](https://qiita.com/tawara_/items/374f3ca0a386fab8b305)**

|**白源 通常版**|**白源 半角3:全角5 版**|
|:------------------------:|:------------------------:|
|![hackgen](https://github.com/yuru7/HackGen/raw/image/sc_hackgen.png)|![hackgen35](https://github.com/yuru7/HackGen/raw/image/sc_hackgen35.png)|

## フォントファミリーの種類

**※いずれのフォントにも Powerline 記号が含まれています。**

|**フォント ファミリー**|**説明**|
|:------------:|:---|
|**HackGen**|文字幅比率「半角1:全角2」の通常版の白源。主にASCIIコードに載っている英数字記号のみに Hack ベースの字体を使い、その他の記号類やかな文字・漢字を源柔ゴシックベースにしている|
|**HackGen Console**|Hack ベースの字体を除外せずに全て適用したフォントファミリー。矢印記号などの多くの記号が半角で表示されるため、コンソールでの利用や記号類は可能な限り半角で表示したい人にオススメ|
|**HackGen35**|通常版の白源の文字幅比率を「半角3:全角5」にしたフォントファミリー。英数字が通常版の白源よりも大きく表示される。日本語が少ない文書の場合、こちらの方が見やすいと感じるかもしれない。|
|**HackGen35 Console**|HackGen Console  の文字幅比率を 半角3:全角5 にしたフォントファミリー|

|**HackGen 系統**|**HackGen35 系統**|
|:---:|:---:|
|`HackGen`<br/>![hackgen](https://github.com/yuru7/HackGen/raw/image/hikaku_hackgen.png)|`HackGen35`<br/>![hackgen35](https://github.com/yuru7/HackGen/raw/image/hikaku_hackgen35.png)|
|`HackGen Console`<br/>![hackgen console](https://github.com/yuru7/HackGen/raw/image/hikaku_hackgen-console.png)|`HackGen35 Console`<br/>![hackgen35 console](https://github.com/yuru7/HackGen/raw/image/hikaku_hackgen35-console.png)|

**※以下のフォントファミリーには、[Nerd Fonts](https://www.nerdfonts.com/) を追加で合成しており、Font Awesome を初めとした多くのアイコンフォントが表示できるようになります。**

|**フォント ファミリー**|**説明**|
|:------------:|:---|
|**HackGenNerd**|HackGen に Nerd Fonts を追加しているフォントファミリー|
|**HackGenNerd Console**|HackGen Console に Nerd Fonts を追加しているフォントファミリー|
|**HackGen35Nerd**|HackGen35 に Nerd Fonts を追加しているフォントファミリー|
|**HackGen35Nerd Console**|HackGen35 Console に Nerd Fonts を追加しているフォントファミリー|

## フォントのインストール

ビルド済みの ttf ファイルは GitHub のリリースページからダウンロードできます。  
ダウンロードした ttf ファイルは、各 OS に応じた手順でインストールしてください。

[Release - HackGen](https://github.com/yuru7/HackGen/releases)

* `HackGen_バージョン.zip` は従来の HackGen/HackGen35
* `HackGenNerd_バージョン.zip` は従来の HackGen/HackGen35 に更に [Nerd Fonts](https://www.nerdfonts.com/) を合成したもの

### Homebrew によるフォントのインストール

Mac の Homebrew ユーザーは以下のコマンドでもインストールすることができます。  
※Homebrew リポジトリに追加してくださったのはユーザーさんなので、使用方法などをリポジトリオーナーはサポートできません。悪しからずご了承ください。

```
$ brew tap homebrew/cask-fonts
$ brew install font-hackgen
$ brew install font-hackgen-nerd
```

### Chocolatey によるフォントのインストール

Windows の [Chocolatey](https://chocolatey.org/) ユーザーは以下のコマンドでもインストールすることができます。  
[font-hackgen](https://chocolatey.org/packages/font-hackgen) が Nerd Fonts を含まないフォント、[font-hackgen-nerd](https://chocolatey.org/packages/font-hackgen-nerd) が Nerd Fonts を含むフォントです。  
※インストールに失敗する場合は、[パッケージのリポジトリ](https://github.com/kai2nenobu/chocolatey-packages/)にissueを投稿してください。

```
> choco install font-hackgen
> choco install font-hackgen-nerd
```

## ビルド環境

HackGen は以下の環境でビルドしています。

* OS: Ubuntu 18.04
* Tools
  * ttfautohint: 1.8.1
  * fonttools: 3.44.0
  * fontforge: fontforge 11:21 UTC 24-Sep-2017

### ビルドツールのインストール方法と注意点

* ttfautohint: `sudo apt install ttfautohint`
* fonttools: Python 2 の pip で `pip install fonttools`
  * fonttools に含まれるサブツール `pyftmerge` と `ttx` をコマンドとして利用しているため、fonttools インストール後、該当コマンドがインストールされているディレクトリに PATH を通すこと (一般ユーザー権限でインストールした場合は `~/.local/bin/` 内に展開されている)
  * Python 3 の pip を使ったものは fonttools 4.13.0 がインストールされる (2020/08/01 時点)。 fonttools 4.13.0 では post テーブルの構造が変わってしまうため、macOS 10.15 にてインストール不可となる ([#12](https://github.com/yuru7/HackGen/issues/12))
* fontforge: Personal Package Archive (PPA) を追加した後に `sudo apt-get install fontforge` (詳細は [こちら](http://designwithfontforge.com/en-US/Installing_Fontforge.html))
