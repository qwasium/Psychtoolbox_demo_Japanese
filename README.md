# Psychtoolbox_demo_Japanese

This is an unofficial Japanese tutorial for Psychtoolbox3. 
This project is written in Japanese.
Open in SHIFT-JIS environment if it looks broken.

---

このプロジェクトは大学研究室内の教育用資料として公開しているものです。  
学生個人による非公式な資料であり、正確な情報はMathWorks社およびPsychtoolboxの公式サイトおよびフォーラムを参照してください。  
執筆時点から仕様変更がされている可能性もあるため、迷ったら公式を参照して下さい。  
最新情報は公式フォーラムで見られます。
Gitレポジトリのwikiには公式ドキュメントに記載されていない情報も載っています。ライセンスについても、詳細はGitレポジトリを参照。  

- [PTB公式ホームページ](http://psychtoolbox.org/)  
- [PTB公式フォーラム](https://psychtoolbox.discourse.group/)  
- [Gitレポジトリ](https://github.com/Psychtoolbox-3/Psychtoolbox-3)  

※以降、PsychtoolboxをPTBと略称する。

## コンテンツ

- demo_ForBeginner.m：はじめてPTBに触れる人はこれを読むこと。コメントで細かく説明を入れていて、初学者は読むだけで基本を網羅できるようにしている。
- demo_JapaneseText.m：PTBで日本語文字列を表示する際のデモコード。
- demo_StimTracker.m：Cedrus社のStimTrackerを用いた同期を行うためのデモコード。
- template_Simple.m：簡単な実験プログラムを新規作成する際のひな形。
- template_Tobii.m：[Titta(Niehorster et al., 2020)](https://github.com/dcnieho/Titta)とTobiiアイトラッカーを用いた実験プログラムを新規作成する際のひな形。TittaのライセンスはTittaレポジトリを参照。

## PTBのインストール

Ubuntu 22.04 LTSにMATLAB R2022aをインストールしている環境を例に説明する。

基本的にはUbuntu等のDebian系Linuxを選ぶべきである。
Windows10以降のWindowsは正常に動作しているのか判断することが難しく、本当にコンピュータに精通している者以外はWindowsは避けるべきである。

ビギナーは避けるべき環境

- Windows及びMac
- 32bit及びARM系CPU
- ハイブリッドグラフィックスのノートPC

ビギナーに推奨する環境

- AMD製GPUを搭載したデスクトップPC + Ubuntu + オープンソースGPUドライバー（最初から自動的に入っているドライバー）
- 実はMATLABよりGNU/Octaveの方が簡単だったりする。Octaveの場合は手動インストールが不要なので初心者には特におすすめ。

まずはじめにPTB公式サイトのダウンロードページを熟読しましょう。  
[http://psychtoolbox.org/download.html](http://psychtoolbox.org/download.html)

### NeuroDebianレポジトリの追加

Ubuntu等のDebian系LinuxではNeuroDebianを利用すると、インストール時の依存関係や不具合を自動的に解消してくれるので便利。  
これがないと全て手動で修正する必要がある。

PTB3ダウンロードページからNeuroDebianページにいく。  
MATLABまたはOctaveから適切な方を選択。今回はMATLABの方(下)をクリック。

![](img/PTBdownload.png)

自分のLinuxディストリビューションとバージョン（今回はUbuntu 22.04 LTS）が対応リストの一覧に載っていることを確認し(Ubuntu22はスクショ範囲外に記載)、*Install this package*をクリック。

![](img/ndeb_pack.png)

自分の環境を選択して、現在地から地理的に近いサーバーを選択。*all software*を選択。( *only ...* の選択肢は自由ソフトウェア運動の精神に反するソフトウェアを排除)

![](img/ndeb_install.png)

選択するとコマンドが出てくるのでターミナルを開いてコピペして実行する。

![](img/add_repo.png)

以下のように、`sudo apt update`を実行した後にインストールを実行する。  
**重要：この先出てくる選択肢はすべて*YES*を選択すること。**

```bash
# ターミナルで
sudo apt update
sudo apt install matlab-psychtoolbox-3
```

※ちなみにOctaveの場合はここでそのままコマンドが実行終了してインストール完了。手動インストールも不要でOctaveを開けばすぐ使える。MATLABの場合は以下の作業を続ける。

PTBをインストールするMATLABのディレクトリを指定する（画像で入力されているディレクトリはMATLABデフォルトのインストール先とは違うので注意）。

![](img/matroot.png)

通常はユーザー欄は空欄でOK。

![](img/user.png)

これは必ず**YES**を選択すること。

![](img/GCC.png)

これでNeuroDebianは完了。

通常、以上の作業はMATLABのインストールが済んだ後に行うが、もし誤ってMATLABをインストールする前に以上の作業を行った場合はMATLABインストール後に、ターミナルで以下を必ず実行すること。  

```bash
# ターミナルで
sudo dpkg-reconfigure matlab-support
```

### PTB3のインストール

次に、Psychtoolbox公式ダウンロードページから[**Downloadpsychtoolbox.m**](https://raw.github.com/Psychtoolbox-3/Psychtoolbox-3/master/Psychtoolbox/DownloadPsychtoolbox.m.zip)をダウンロードして解凍する。

MATLABをrootで起動する。(シンボリックリンクがある場合はターミナルから以下のコマンドで起動可)

```bash
# ターミナルで
sudo matlab
```

2022年現在、`sudo matlab`で起動するとクラッシュするバグが報告されている。  [<https://jp.mathworks.com/matlabcentral/answers/1619660-matlab-2021b-crashed-when-running-with-sudo-root>
](https://jp.mathworks.com/matlabcentral/answers/1619660-matlab-2021b-crashed-when-running-with-sudo-root
)

MATLABクラッシュレポーターのウィンドウを触らなければ、MATLABコマンドウィンドウからPTBのインストールは可能である。

![](img/crash.png)

MATLABを起動したら**Downloadpsychtoolbox.m**のフォルダーに移動して以下を確認する。

- GPUの正しい端子にディスプレイを接続する
- ディスプレイを2枚以上接続しない
- ディスプレイケーブルの変換アダプタを使用しない

（ただし、映像通信規格に精通している者は各自判断でOK）

確認できたらMATLABのコマンドウィンドウで`DownloadPsychtoolbox('インストール先のディレクトリ')`を実行する。

```matlab
% MATLABコマンドウィンドウで

%　ダウンロードしたフォルダーに移動（適切なディレクトリを入れる）
cd /home/(ユーザー名)/Downloads

%　引数はMATLABのtoolboxフォルダーのパス（適切なディレクトリを入れる）
DownloadPsychtoolbox([matlabroot '/toolbox'])
```

インストールが始まったら、出てくる文章を注意深く読みながら、インストーラーの指示に従う。英語が苦手な人は助っ人を用意しておくと良い。

グループに追加するユーザーを入力する時はrootに加えて通常のユーザーの入力を忘れずに。

![](img/add_user.png)

無事にインストールが終了したら、MATLABを終了する。PTB公式ページの以下を読んだうえで、

[http://psychtoolbox.org/linux](http://psychtoolbox.org/linux)

ターミナルよりMATLABをJava仮想マシン無効モードで起動する。

```bash
# ターミナルで
matlab -nojvm 
```

MATLABのコマンドウィンドウで以下のコマンドを一度だけ実行する。

```matlab
% MATLABコマンドウィンドウで
PsychLinuxConfiguration
```

`DownloadPsychtoolbox`の時と同様に表示される文章を読みながら進めていき、グループにユーザーを追加する時だけ忘れなければOK。

本番環境では組み込み向けのlow latencyカーネルのインストールが推奨されている。

```bash
# ターミナルで
sudo apt-get install linux-lowlatency
```

### インストールに失敗したら

- エラーメッセージを真面目に読む
- エラーメッセージで指摘されている問題を解決する

エラーの原因を解決したら、sudo権限でMATLABを起動して、MATLABコマンドウィンドウで以下のようにPTBのディレクトリに移動して`SetupPsychtoolbox`を実行する。

```matlab
% MATLABコマンドウィンドウで
cd([matlabroot '/toolbox/Psychtoolbox'])
SetupPsychtoolbox
```

### インストール完了後

これでインストールは完了したのでPsychDemoを動かしてみよう。  
念のために一度PCを再起動して、MATLABを起動する。  
MATLABで以下のコマンドを実行してみて、動作したらインストール成功！

```matlab
% MATLABコマンドウィンドウで
% 以下、はじめて動かすと楽しいデモ
LinesDemo
DrawFormattedTextDemo
KbDemo
SadowskiDemo
```
