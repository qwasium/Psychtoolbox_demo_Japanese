% -------------------------------------------------------------------------
% The basics of Psychtoolbox
% July. 9, 2022
% @author: Simon Kuwahara
% Developed on :
% MATLAB R2022a
% Ubuntu 22.04LTS
% UTF-8
% 1600*1200 60Hz HP L2035 display
% -------------------------------------------------------------------------
% 
% Demo code for first-time learners of PsychToolbox.
% Comments are in Japanese.
% Open in Japanese language enabled environment if broken.
% 
%
%
%-------------------------------------------------------------------------- 
%                     初学者は一度は最後まで通読せよ！！
%--------------------------------------------------------------------------
%                      時間をかけろ！！読み飛ばすな！！
%--------------------------------------------------------------------------
%             　知らない用語は面倒臭がらずに片っ端から全部ググれ！！
%--------------------------------------------------------------------------
% 
% 
% 
% ここではPTBのあくまでも技術的な側面についてのみ説明する。
% ここでは扱わないものの、実験計画法もきちんと考慮して実験を組むこと。
% PTBはインストール済み、動作確認済みという前提で進める。
% 
% 
%% 想定する知識レベル
% 
% 初めてPTBを触る人くらいを想定している。
% 以下については知らないと全く話が通じないので不安な人は各自ググっておくこと。
% ・MATLABの基本操作やプログラミングについての基礎知識 
% ・コンピュータ構成についての基礎知識
% ・ディスプレイについての基礎知識
% PTBを使ううえでコンピュータの規格の知識は非常に重要になる。
% この先も知らない用語はめんどくさがらずに全て時間をかけてググること。
% 
% 
%% なぜPTBを使うのか？ 
% 
% 先輩が使っていたからなんとなく私も…
% と、なぜPTBを使うのかをわかっていない・考えていない人が意外にも多くて驚く。
% PTBは総合力を要求するのでプログラミングの中では結構難しい部類である。
% では、なぜわざわざそんな難しいものを使わなければならないのか？
% 
% 心理実験はS-O-Rモデルに基づいている
% ＝"人に刺激を与えてその反応を測ることで人間の内部でのプロセスについて知ろうとする"
% というロジックが前提にある。
% 刺激を与えてからどれくらいの時間で反応があったか、という情報はこの論理において非常に重
% 要。
% 
% また同様に、実験を繰り返すにあたり、毎回同じ条件を維持しながら安定して刺激を提示するこ
% とが、研究で前提としている統計モデルとの整合性や実験の再現性の観点から非常に重要。
% （身近なところでは、E-Sportsで求められる要件と極めて近いのでゲーム業界から学べること
% は多い）
% 
% そこで刺激を指定した時間に正確に提示することを目的としたソフトウェアが開発された。
% その中でもPsychtoolboxはE-Primeと並び、最も時間制御が正確な刺激提示ツール。
% PTBは難しいが、それにも関わらずわざわざ使う理由は時間制御の精密さと先行研究における実
% 績にほかならない。
% 
% 使用目的をしっかりと意識したコーディングを心がけること！
% 
% 
%% PTBの環境構成の注意
% 
% PTBは低水準の制御に関与しているため、ソースコードはC++で書かれた高難度のプログラムで
% あり、ハードウェア要件も厳しい。
% PTBは上級者にとっては簡単に弄ることができる点では良いが、初心者にとっては間違ったこと
% をしていてもそのまま動いてしまうことも多く、十分に注意すべきである。 
% 
% 研究倫理の観点から実験の再現性を担保したコーディングが求められる。
% なので、コンピュータに精通しているエキスパート以外は公式の要件から逸脱するべきではない。
% 詳細は公式を参照していただくとして、ここでは特に注意すべき点を挙げる。
% http://psychtoolbox.org/requirements.html
% 
% ・基本的にはLinuxが公式に強く推奨されている
% 明確な目的がなければ絶対にLinuxにすべきである。
% 特にWindowsとMacOSは多くの問題を抱えており、エラーを吐かずに動いた＝正常に動いた
% と思わないほうがいい。
% その点、Linuxのほうが制御の自由度が高く、エラーチェック機能が充実していて安全である。
% どうしてもWindowsやMacOSを使う際は下に述べるように外部機器で時間計測をすること。
% 【重要】問題なく動作した場合でもPTBから出力されるメッセージは読む癖をつけること。
% 最も動作が安定しているのはLinux＋AMD製GPU＋オープンソースドライバーの組み合わせ。
% 
% ・インテル統合グラフィックスはLinuxのみ
% ラボ内にあるノートPCはインテルなので全てWindows非対応ということになる。
% 開発作業では使用してもよいが、実験の本番ではコンピュータに精通したエキスパート以外は触
% るべきではない。
% これからノートPCを買うのであれば、AMDを買う方が良い。
% 
% ・複数ディスプレイの出力はLinuxのみ
% 基本的にディスプレイは１枚のみの出力が推奨されるが、２枚以上使う際は注意点がある。
% ・Linux推奨。WindowsやMacOSは問題を起こしがち、非推奨。
% ・すべてのディスプレイを同一のGPUから出力すること。
% ・ディスプレイは同一の機種が望ましい。最低でも同一の解像度・リフレッシュレートに統一。
% ・ディスプレイ構成にあわせて正しくGPUを設定する知識が要求されるのでちゃんと勉強すること。
% ・接続しているが使用しないディスプレイは無効化するのも有効。（例：ノートPCの内蔵モニター）
% 
% ・ディスプレイについて
% 実験で使用するディスプレイについての基本的な情報を把握すること。ディスプレイが変われば
% 実験条件は大きく異なる。最低限以下は確認すること(これは論文にも記載する事項)。
% ・解像度：縦横のピクセルの数。横1920×縦1080(1080p/フルHD)が現在の主流。
% ・リフレッシュレート：1秒に何回画面の表示を書き換えるか。現在の主流は60Hz。
% ・画面のサイズ：画面の対角線の長さをインチで表現する。
% 特に120Hzディスプレイ、4Kディスプレイなどの高性能なディスプレイ、または逆にCRT（ブラ
% ウン管）等のレガシーデバイスを使う際は接続規格やハードウェアの適合、プログラムの内容を
% 十分に点検すること。
% わからない人は自分で判断せずにわかる人に聞くこと。
% 
% ・ディスプレイケーブルについて
% 最低限でも以下の4種類のディスプレイケーブルの種類を知っておくこと。
% 常識レベルの知識なので知らない人は今すぐググること。
% ・HDMI             ：デジタル、音声あり、初期の世代は適合に注意
% ・Display Port(DP) ：デジタル、音声あり、基本これが第一選択、迷ったらDPを使え
% ・DVI              ：デジタル及びアナログ、音声なし、4K非対応
% ・VGA              ：アナログ、音声なし、フルHD非対応、初心者は使用禁止
% 映像通信規格について勉強したくない人は以下のルールに従うこと。規格に精通している人は
% 各自好きに判断して使ってもらって構わない。
% 【重要】
% ・基本はDPを使うこと、DPが無い場合はHDMIを使うこと
% ・うまくホットプラグに対応しない場合があるので認識しない場合は再起動すること
% ・実験に関わるときは刺さればいいや、映ればいいやの発想は捨てること
% ・変換アダプタ・変換ケーブルは一切使用禁止 （規格に精通している人はアダプタは使用して
% も良いが、かなり細かい知識を要求するので判断できない人は決して手を出すべきではない）
% 
% ・ストレージについて
% ストレージのアクセス速度は実行速度に大きく影響する。
% 必ず内部ストレージ、それもHDDではなくSSDを使用すべきである。
% 外付けHDDやUSBからの実行は絶対に避けるべきである。
% Dropbox等のクラウドストレージを使用する場合はローカル保存の設定にすることを忘れずに。
% これらが難しい場合や大容量データはメモリへプリロードする処理をコードに書き加えること。
% 
% ・本番時はバックグラウンドプロセスなどに注意
% 実際に実験する際は、MATLABとPTBがコンピュータのリソースを最大限に使用できるように実験
% に直接関係ないソフトウェアは終了しておくこと。
% 特にRAM容量が少ないマシンは顕著に影響が出るので注意すること。
% 
% ・PTBが正確な時間制御ができない環境で実験をする時
% 上記の様々な制約を守れず、どうしてもPTBの時間制御が保証できない条件で実験をする際は、
% Cedrus StimTrackerなどの時間制御に特化した外部機器を併用すること。
% ただし、これは必ずしもすべての場面で使えるわけではなく、実験デザインを考慮して吟味が必
% 要である。
% 
% 
%% コメント
% 
% MATLABに限らず、プログラムを書く際は冒頭コメントに
% ・誰が
% ・いつ
% ・どんなプログラムを
% ・何のOSを
% ・どんな環境で（MATLABのバージョンなど）
% 書いたのかを誰でもわかるようにメモしておくこと。
% 
% 加えて、PTBはディスプレイによって挙動が変わるので
% ・高リフレッシュレートディスプレイ
% ・高解像度ディスプレイ
% ・CRT等のレガシーデバイスや特殊なディスプレイ
% を使用した際は必ず冒頭コメントにわかりやすくメモしておくこと。
% 使用する機材に関係なく実験プログラムのコメント欄にはディスプレイの解像度とリフレッシュ
% レートを普段から書いておく習慣をつけておくと良い。
% 
% また、ラボ単位でコーディング規約は設けていないが、
% ・パラメーターのハードコードの禁止
% ・適切なコメントアウト（多ければいいというものではない）
% ・変数の命名規則
% くらいは各自の判断でやってほしい。
% 
% 初歩的なことなのだが、恥ずかしいことにこのラボではこれができていない人があまりにも多す
% ぎる。
% 可読性の低いコードは基本的に嫌がられるうえ、コード設計があっという間に劣化して誰も引き
% 継げないパンドラの箱と化す。
% これを読んでくれている方は誰が見てもわかる保守性・可読性の高いコードを書くことを心がけ
% てほしい。
% 特に自信のない人は、先輩のコードレビューを受ける習慣をつけること。
% 
% 
%% 困ったら
% 
% 原則として、上記を理解できない人は自分で勝手に判断しないこと！
% 繰り返しとなるが、実験条件がメチャクチャでもなんとなく動いてしまうのがPTB。
% わからない用語はめんどくさがらずに片っ端から全部ググること。
% 
% 繰り返すが、使用するディスプレイの解像度とリフレッシュレートを必ず意識すること。
% 60Hzのディスプレイは静止画を１秒に60回表示し直しているということを忘れずに。
% 1/60s = 16.7msよりも短い時間の処理は60Hzモニターでは不可能！
% PTBを用いた開発では常に１フレームごとに考えるクセをつけること。
% 画面や画像の座標系は大抵左上原点のX,Y座標、単位はピクセルということも忘れないずに。
% 
% 可能な限り公式ドキュメントのリンクを記載したので不明点がある場合は自分で確認するように。
% 関数のヘルプはMATLABの他の関数同様、以下の通り。
% "help 関数名"
% また、Screen関数のヘルプは
% "Screen 第1引数"
% "F9"キーで選択箇所のみを実行可能。
% 
% PTBのエラーメッセージはかなりちゃんとしてるので最初から最後まできちんと読みましょう。
% なんだかんだで詰まったときは難しいので困ったら他人にヘルプを求めること。
% 
% 上級者は困ったらソースコードを自分で確認すること。
% ソースコードは通常のインストールでは省略されているが、GitHubでは公開されている。
% https://github.com/Psychtoolbox-3/Psychtoolbox-3
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



clear all %#ok<CLALL> 
% メモリに残っている変数が悪さをしないようにお守りのclear。
% clear allでallをつけているのはコンパイルしたmexファイルもメモリから開放するため。

commandwindow
% GUIでコマンドウィンドウの選択。
% 特にキー入力を伴う処理を扱う場合は入れておくと良い。

GetSecs(0);
% このmex関数は冒頭で一度呼んでコンパイルしておく癖をつけておくこと。
% 詳細は後述。419行目〜の"flip"の説明を参照。

homeDir = fileparts(mfilename('fullpath'));
% 今回は使わないが、別フォルダーに保存されている刺激の素材の読み込みや別フォルダーに結果
% を出力する際などになにかと便利なのでビギナーは実験スクリプトのディレクトリを変数に格納
% する癖をつけておくと良い。
% もちろん、ビギナーを脱した人は必要に応じて適切に判断してもらって良い。
% 
%% 【重要】相対パスを使え！！静的な絶対パス禁止！！
% 絶対パスをハードコードすると環境が変わると動作しないので明確な目的が無い限りは禁止！
% 
% cd ..            % 一つうえのフォルダーに移動
% parentDir = pwd; % カレントディレクトリを変数に格納
% cd(homeDir)      % 場所に関係なくこのスクリプトのディレクトリに戻る
% 
%% 【重要】パス区切り文字はOSに関係なく"/"を使うこと。"\"は使用禁止。
% 
% cd ./results
% % cd .\results  <--【バックスラッシュ禁止】UNIX系では動かない


sca
% Screen('CloseAll');と同義。
% PTBで開いたウィンドウをすべて閉じる。clear同様、冒頭のお守り。
% help sca
% http://psychtoolbox.org/docs/sca

PsychDefaultSetup(2);
% 初期設定のセットアップ
% 0:AssertOpenGL実行。Screen関数が動くことをチェックする。
% 1:上記0に加えてKbName('UnifyKeyNames')を実行。キーボード配列をUSに統一。
% 2:上記1に加えて色を0-255ではなく0-1の高ビット深度に設定、詳細は公式ドキュメンテーション参照。
% help PsychDefaultSetup
% http://psychtoolbox.org/docs/PsychDefaultSetup

%% ご法度！
% 
% 以下のコードは使用厳禁！時間制御を解除するので絶対にこれに書いてはいけない。
% 【禁止】Screen('Preference','SkipSyncTests', 1);    <--【これ書いたら殴るよ】
% 【厳禁】Screen('Preference','SkipSyncTests', 2);    <--【これ書いたら即クビ】
% これを本番コードで堂々と使っている人がなんと多いことか。
% なぜこれがマズいのかわからない人はPTBをなぜ使っているのか考え直してほしい。
% 
% ※PTB開発者の実際の発言：
%       "私は世界一アホな研究者です！と世に叫ぶ行為に等しい。"
% 
% 開発者ですら辛辣な発言をしているので、SkipSyncTestsの影響の重大さを理解すること。
% SyncErrorが出たらまずは環境を見直すこと。
% 
% どうしてもシステムのノイズが大きくて安定動作しない場合は以下の1行を追加すること。
oldSync = Screen('Preference', 'SyncTestSettings', 0.002);
% この1行を入れなくても動作する場合は必ず消すこと。
% この1行を入れる場合は以下のSyncTroubleの公式ドキュメントをきちんと読んで制約を理解し
% た上で使うこと。（ここで説明すると長くなるので各自ちゃんと読むこと）
% 経験上、NvidiaGPU+プロプライエタリドライバーの環境では上の1行を入れたほうが動作が安
% 定する。
% 設定を変更する際は変更前の値を変数に格納しておいて最後に戻す習慣をつけると良い(後述)。
% 
% help SyncTrouble
% http://psychtoolbox.org/docs/SyncTrouble


%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
oldVerbosity = Screen('Preference', 'Verbosity', 4);
% デバッグメッセージの出力設定
% 第3引数は通常は2でOK、デバッグ時は4が良い
% 設定を変更する際は変更前の値を変数に格納しておいて最後に戻す習慣をつけると良い(後述)。
% https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/FAQ:-Control-Verbosity-and-Debugging

scr = max(Screen('Screens'));
% スクリーン番号の最大値をscrに格納（例：ディスプレイを１枚だけ接続していたらscr=0）
% Screen Screens?
% http://psychtoolbox.org/docs/Screen-Screens

bkClr = BlackIndex(scr);
whClr = WhiteIndex(scr);
% 黒と白の色を示す数値それぞれ変数に格納
% help BlackIndex
% http://psychtoolbox.org/docs/BlackIndex
% help WhiteIndex
% http://psychtoolbox.org/docs/WhiteIndex

% task parameters
bgClr    = (bkClr+whClr)/2; % 背景色
stmClr   = bkClr; % 刺激色
swchT    = 0.5;   % デフォルト提示時間
fixT     = 2.0;   % 注視点提示時間
%% 【重要】明確な目的がない限りはパラメーターはハードコードせずに変数を用いて定義すること。
% 実際の研究現場では実際の実験で使うハードウェアでテストしながら表示を微調整することがよ
% くある。
% 後から弄って変更することを考慮して書くこと（保守性の配慮）。
% 
% また、変数の名前はプロジェクトの変数命名規則に従うこと。
% 命名規則の指定が予め無い場合は厳格な命名規則を設ける必要は無いが、他人が見ても分かりや
% すいように自分なりに工夫すること。
% 例えば、このスクリプトでは緩く以下のようにしている。
% 色に関するもの(Color)  : xxxClr
% 時間に関する変数(time) : xxxT
% 他にもポインター(ptr)、ウィンドウ(w)、センター(cntr)、注視点(fix)など
% 明確な目的が無ければ変数命名はcamelCaseまたはsnake_caseのどちらかに統一することを推奨する。
% "bgClr"と"bg_clr"みたいな紛らわしい変数名の乱立をさけるためにもコーディング規約が存在しない
% 場合も自分なりのルールを決めること。

try
%% PTBウィンドウを開く 
% 
% PTBでウィンドウを開くときにエラーが起きるとsuperキー（Windowsキー）からMATLABを強
% 制終了しないといけない場面が多々ある。そこでPTBのウィンドウに関連する処理を
% try~catch文の中に入れることによってエラーが発生したらそのままフリーズせずに自動的に
% 処理を強制終了するようにできる。
% 基本的な考え方として、PTBでウィンドウを開かなくても実行可能な処理（パラメータ設定など）
% は開く前に全て済ませておいた方がトラブル対処が楽である。


    %% open window %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [wptr, wRect] = PsychImaging('OpenWindow', scr, bgClr);
    %% ウィンドウを開く
    % 
    % 表示したいディスプレイをスクリーン番号scrで指定。
    % 背景色を上で定義したbgClrで指定。
    % 開いたウィンドウはウィンドウポインターwptrに格納される。
    % ポインターとはC++で使われる変数の一種で、メモリ上でのアドレスを指す変数。
    % ウィンドウの四隅の座標は配列wRectに格納される。
    % 
    % PsychImaging関数でウィンドウを開くとGPUのパイプラインが使えるので基本的には
    % PsychImagingを使うほうが良い。
    % しかし、PsychImagingはディスプレイの可変リフレッシュレート(VRR)が必須となるの
    % で、目的があってVRR非対応の古いディスプレイを使う際はScreen('OpenWindow')を用
    % いる。
    % 
    % 【参考】ジャギー対策でアンチエイリアシングを使う場合は以下のコマンドでウィンドウを開く。
    % [wptr, wRect] = PsychImaging('OpenWindow', scr, bgClr, [], [], [], [], 4);
    % 
    % その他、構成によって引数を頻繁に変えるので公式ドキュメント参照。
    % Screen OpenWindow?
    % http://psychtoolbox.org/docs/Screen-OpenWindow
    % help PsychImaging
    % http://psychtoolbox.org/docs/PsychImaging

    %% 以下、ウィンドウの初期設定
    
    Priority(1);
    % OS上でのPTBの処理の優先度を指定。
    % OSの種類に関係なく、明確な理由がない限りは１から変更しないこと。
    % help Priority
    % http://psychtoolbox.org/docs/Priority

    hz = Screen('NominalFrameRate', wptr, 1);
    % ディスプレイのリフレッシュレートを取得
    % Screen NominalFrameRate?
    % http://psychtoolbox.org/docs/Screen-NominalFrameRate

    Screen('BlendFunction', wptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    % アルファブレンドの設定。
    % ピクセルに色を重ねたときに色をどう合成するかの設定。
    % 理由がなければ上記のデフォルト値のままでOK。
    % Screen BlendFunction?
    % http://psychtoolbox.org/docs/Screen-BlendFunction

    [xCntr, yCntr] = RectCenter(wRect);
    % ウィンドウの四隅の座標配列wRectよりウィンドウ中心の座標を取得。
    % help RectCenter
    % http://psychtoolbox.org/docs/RectCenter
    
    HideCursor;
    % カーソルの表示を消す
    % help HideCursor
    % http://psychtoolbox.org/docs/HideCursor

    
    %% Start Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% PTBでの描画方法
    % 
    % PTBではまず、フレームバッファに必要なもの(テクスチャ)を事前に全て描画（レンダリン
    % グ）して裏で準備しておく。
    % フレームバッファとは画面に表示するラスターデータを一時的に保存するメモリ領域。
    % Screen('Flip')関数を実行すると準備しておいたフレームバッファに切り替えてディス
    % プレイに表示する。
    % Screen Flip?
    % http://psychtoolbox.org/docs/Screen-Flip

    Screen('FillRect', wptr, whClr);
    % ウィンドウwptrの次のフレームバッファを白で埋める。
    % Screen FillRect?
    % http://psychtoolbox.org/docs/Screen-FillRect
    
    flipT = Screen('Flip', wptr);
    % 準備した白のフレームバッファに切り替える。
    % Flipを実行した時刻（＝刺激を提示した瞬間の時刻）をflipTに格納する。
    % flipTに格納されている時刻はシステム時刻

    Screen('FillRect', wptr, bkClr); % フレームバッファを黒に
    flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz); % Flipで画面が黒に
    
    %% Screen('Flip')の注意点
    % 
    % Screen('Flip')は刺激提示の瞬間を決める非常に重要な１行だ。
    % この関数の実行の時間制御は慎重に行う必要がある。
    % 
    % 刺激をswchT秒見せてから次のFlipを実行したいという場面はよくある。
    % 経験者であればWaitSecs()で処理を止めるかもしれないが、これは注意すべき。
    % 
    % 【避けたほうがいい例】
    % Screen('FillRect', wptr, bkClr);
    % WaitSecs(swchT);
    % Screen('Flip', wptr);
    % 
    % これが不適切な理由は、mex関数を最初に呼び出す際にコンパイルにかなりのタイムラグが
    % 発生するから。
    % 逆に、関数がすでにコンパイル済みであれば使っても問題はないので、実験スクリプトの
    % 冒頭付近で以下のように1行入れて予めコンパイルしておくと良い。
    % WaitSecs(0);
    % しかし、無駄な心配をするくらいなら最初から以下のように書くほうが良いと思う。
    % 
    % 【推奨される書き方】
    % (flipTには前回のFlip実行時刻が格納されている)
    % Screen('FillRect', wptr, bkClr);
    % flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz);
    % 
    % ただし、上記のScreen('Flip')関数の中身は次のようになっている。
    % 
    %         flipT          = Screen('Flip', wptr, flipT+swchT-0.5/Hz)
    % 実際にFlipが実行された時刻 = Screen('Flip', wptr, Flipを実行する時刻)
    % 
    % ここで述べる時刻とは全てコンピュータのシステム時刻を指す。
    % "Flipを実行する時刻"は初回のFlipでは省略する。
    % 2回目以降のFlipではこちらで任意に指定し、その中身は次のように表記する。
    % 
    %      flipT    +    (任意の秒数)    - 0.5/Hz
    % 前回のFlip時刻 + 直前の画面の提示時間 - 0.5/リフレッシュレート
    % 
    % "-0.5/リフレッシュレート" = "1フレームの長さ(1/Hz)の半分"であり、これは次の
    % Flipの実行が指定時刻に間に合うようにするための余裕分として入っている。
    % 
    % 常にリフレッシュレートを念頭に1フレーム単位で処理を考えること。
    % 当たり前だが、提示時間がディスプレイの1フレーム分の長さを下回ったら表示できない。
    % 高リフレッシュレートディスプレイを想定した実験プログラムは冒頭コメントにその旨を
    % 必ず記載をすること。
    % 
    % PTBを使う上で最も重要なポイントなので理解できない場合は質問すること。 
    % help WaitSecs
    % http://psychtoolbox.org/docs/WaitSecs
    % 詳細はAccurateTimingDemo.mを参照

    Screen('FillRect', wptr, whClr); % フレームバッファを白に
    flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz); % Flipで画面が白に
    
    Screen('FillRect', wptr, bkClr); % フレームバッファを黒に
    flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz); % Flipで画面が黒に

    Screen('FillRect', wptr, whClr); % フレームバッファを白に
    flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz); % Flipで画面が白に
    
    Screen('FillRect', wptr, bkClr); % フレームバッファを黒に
    flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz); % Flipで画面が黒に    
    
    % 注視点(円)を表示する
    Screen('FillRect', wptr, bgClr);
    Screen('gluDisk', wptr, stmClr, xCntr, yCntr, round(wRect(3)/100));
    % 画面上の任意の位置に任意の直径の単色塗りつぶし円をレンダリング
    % Screen('gluDisk', ウィンドウポインター, 色, 位置x, 位置y [,直径]);
    % Screen gluDisk?
    % http://psychtoolbox.org/docs/Screen-gluDisk
    flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz);
    % 黒画面をswchT秒提示した後にFlip実行で注視点(円)を表示


    Screen('FillRect', wptr, bgClr); % フレームバッファを黒に
    flipT = Screen('Flip', wptr, flipT+fixT-0.5/hz);
    % 注視点をfixT秒提示した後にFlip実行で画面が黒に戻す
    

    % 注視点(クロス)を表示する
    Screen('FillRect', wptr, bgClr);
    % まず、注視点(クロス)の画像(＝行列)と大きさ、位置を定義する。
    fixMat = [0,1,0; 1,1,1; 0,1,0]*stmClr + [1,0,1; 0,0,0; 1,0,1]*bgClr; % 画像を行列で定義                              
    fixSz  = 15;                                                         % 描画する大きさ/2 (fixPos↓を見よ)
    fixPos = [xCntr-fixSz, yCntr-fixSz, xCntr+fixSz, yCntr+fixSz];       % 位置(四隅の座標)
    % これらのパラメーターはコード内のバラバラな場所に定義すると人間が読みにくいので普通
    % は冒頭の方に他のパラメーター一覧と一緒にまとめて定義することが多い。
    % 今回はわかりやすさのためにこの位置で定義した。 
    fixTex = Screen('MakeTexture', wptr, fixMat);
    % PTBでは画像のままではフレームバッファにレンダリングできないので、注視点の画像fixMat
    % からテクスチャポインターfixTexを生成する。
    % fixTexは再利用可能なので何度も使う場合はOpenWindowの直後あたりでテクスチャポイ
    % ンターを作っておくことが多い。
    % これも上記のパラメーター同様、わかりやすさのために今回はこの位置で定義した。
    % Screen MakeTexture?
    % http://psychtoolbox.org/docs/Screen-MakeTexture
    Screen('DrawTexture', wptr, fixTex, [], fixPos, [],0);
    % 生成したテクスチャポインターfixTexをウィンドウポインターwptr上の位置fixPosに貼
    % り付けてフレームバッファを準備。
    % fixPosはfixMatより大きいので画像は拡大されてフレームバッファにレンダリングされる。
    % 末尾の引数0は画像を拡大縮小した際の各ピクセルの描画のアルゴリズムを指定する。
    % 0=最近傍補間法;今回の目的では適切だが、通常の画像表示においては選ばないこと。
    % 詳細は公式ドキュメント参照。
    % 各フィルタリング手法についての情報はググるのも有効。
    % Screen DrawTexture?
    % http://psychtoolbox.org/docs/Screen-DrawTexture
    flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz);
    % 黒画面をswchT秒提示した後にFlip実行で注視点(クロス)を表示
    

    % テキストを表示する
    Screen('FillRect', wptr, bgClr);
    trgtText = 'AAA'; % char型でテキストを定義（string不可）
    % テキストはcharまたはunit8またはdouble型のみ可。
    % 日本語文字は特別な注意が必要、demo_JapaneseText.mを参照。
    % 上と同様、色んな所でバラバラに定義するとわけがわからなくなるので通常は冒頭の方に
    % 他のパラメーターと一緒に定義する。
    DrawFormattedText(wptr, trgtText, 'center', 'center', stmClr);
    % 画像と違ってテキストはフレームバッファに直接レンダリングできる。
    % 文字列trgtTextを色stmClrでウィンドウポインターwptrの中心に描画する。
    % help DrawFormattedText
    % http://psychtoolbox.org/docs/DrawFormattedText
    flipT = Screen('Flip', wptr, flipT+fixT-0.5/hz);
    % 注視点をfixT秒提示した後にFlip実行でテキストを表示
 

    Screen('FillRect', wptr, bkClr); % フレームバッファを黒に
    flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz);
    % テキストをswchT秒提示した後にFlip実行で画面が黒に戻す
    
    flipT = Screen('Flip', wptr, flipT+2-0.5/hz);
    % 終了前に処理を2秒止める。同じ黒画面にFlip。
    
    sca
    % ウィンドウを全て閉じてお片付け。


catch me
    
    sca
    ListenChar(0);
    rethrow(me)
    % エラー発生時はscaでウィンドウを閉じて強制終了


end

sca
% 万が一ウィンドウが残ってしまった場合のために最後に念の為もう一度scaでお片付け

Screen('Preference', 'SyncTestSettings', oldSync);
Screen('Preference', 'Verbosity', oldVerbosity);
%% 変更した設定を元に戻しておく
% プログラミング全般で言えるが、グローバル変数を変更した場合はコードの末尾に元の値に戻
% しておく癖をつけておくと良い。
% 加えて、重要な設定はデフォルト値に依存するコーディングは避けたほうが良い。
% 前の人が設定を変えたまま戻してなければエラーに繋がるし、デフォルト値そのものがアップデ
% ート等で突然変更する可能性もあるので信用しないほうがいい。


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 次は？？ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% PTBは基本的にDemoスクリプトを参考に勉強するように作られている。
% この中から自分が使いたい機能を見つけて参考にすれば良い。
% help PsychDemos
% http://psychtoolbox.org/docs/PsychDemos
% 
% 例えば、動画を再生したければ、、、
% SimpleMovieDemo
% を実行して動作を見てみて、
% open SimpleMovieDemo
% を実行してデモコードの中身を確認。
% 新規スクリプトに中身をコピペしてちょっといじってみてそれが動けば成功。
% 
% キーボードの基本を見たければ
% KbDemo
% KbQueueDemo
% 
% テキスト表示をしたければ
% DrawFormattedTextDemo
% 
% など、色々あるのでPsychDemosに何があるかを把握しておくこと。
%  