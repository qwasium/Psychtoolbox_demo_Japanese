%% demo for StimTracker TTL Trigger input
% @author: Simon Kuwahara
% MATLAB R2022a
% Ubuntu 22.04
% UTF-8
% Dell S2319HS 1920*1080 60Hz
% -------------------------------------------------------------------------
% v0.0 Aug.17,2022 wrote it SK
% 
% -------------------------------------------------------------------------
% comments are in Japanese. If broken, open in Japanese language environment.
% 
% **dependencies**
% MATLAB R2019b or later.
% Requires Psychtoolbox 3.
% 
% **references**
% Cedrus公式サポートページで公開されているmatlab_output_sample.mを参考に書かれている。
% https://www.cedrus.com/support/stimtracker/tn1920_other_resources.htm
% 詳細はCedrus公式サポートページのXIDコマンド一覧も参照。
% https://www.cedrus.com/support/xid/commands.htm
% 
% -------------------------------------------------------------------------
% 
%              知らない用語はめんどくさがらずにググりましょう！
% 
% -------------------------------------------------------------------------
%% 想定する知識レベル
% 
% MATLABとPsychtoolbox(PTB)の基礎を理解していること。
% PTBの基礎が不安な人はまずは./demo_ForBeginner.mを参照。
% 基本的なことはわかっている前提で不要なコメントは省略する。
% 
% bitとbyteの関係性、2進数と16進数とASCIIの関係性を理解すること。
% 以下のサイトがわかりやすかったので不安な人は参考に。
% https://jumbleat.com/2016/10/14/about_hex/
% 
% StimTrackerの基本的な仕組みや実験環境の構成についての理解も必要である。
% 残念ながら、同期システムのマニュアル化の試みは今のところ、ことごとく失敗している。
% 実験補助者はともかく、実験環境を構築する者は手順書に従うだけではダメで、自分で実験にあ
% わせて機器をパズルのように組み合わせて構築することが要求されることが原因である。
% 決して難しいわけではないが、単純な暗記や記憶に頼れないことが学習コストに繋がっている。
% 
% いまのところ、ラズベリーパイやアルドゥイノ等を用いて電子工作をするトレーニングが最短で
% 習得できる方法だと思われる。急がば廻れである。
% 学習コストは新しくプログラミング言語を習得する場合と同程度である。
% 速い者で1〜2週間程度、通常は1〜2ヶ月程度の時間を割けば習得可能である。
% 決して難しいわけではないことは強調するが、プログラミング同様に好き嫌いは分かれるので全
% 員ができる必要は無いと思う。
% 
% 結論として、
% ・学習コストを割けない人はわかる人に丸投げせよ
% ・自分で勉強したい人は1ヶ月間は勉強時間を捻出せよ
% というところに落ち着くのではないだろうか？
% 
% 
%% MATLABによるStimTracker制御の概要
% 
% まず基本として、Cedrus公式のサポートページをちゃんと読み込むこと。
% 何事にも言えることだが、他人に質問する前にまず公式のマニュアルやドキュメンテーションや
% レファレンス、サポートページなどをきちんと確認する癖をつけることが重要。
% 先生や先輩は悪気は無くても平気で嘘の情報を言うので1次情報を自分で確認しましょう。
% 
% このデモスクリプトではStimTrackerの2つの機能を扱う。
% ・ディスプレイの発光を検出してTTLトリガーを出力する機能
% ・USB経由でMATLABのコマンドからTTLトリガーを出力する機能
% これら2つの機能は独立していて別々に使用可能だが、デモコード内では混ざっているので読む
% 者はきちんと区別して理解すること。
% TTL出力は本体裏側のDINコネクタより全8チャンネル出力。
% 電圧： Lo:0V / Hi:+5V
% 
% High/Lowを指す用語には色々あるので文脈判断が必要。以下が例。
% ・hi/lo
% ・mark/space(markがhi、穿孔テープ/punched tape時代の名残)
% ・on/off
% ・1/0
% ・pull up/pull down
% 
% 【このデモコードでは扱わない機能】
% 外部入力パッドを用いた被験者のキー入力や他の機器からの信号中継などの機能は扱わない。
% この機能は基本的にはライトセンサーと同等に仕組みである。
% 適切に設定することによってStimTrackerはライトセンサーや音声センサー等による入力をUSB
% 経由でタイムスタンプ付きのASCII文字列の形で出力することもできる。
% 詳細は公式サポートページを参照。
% 
% 
%% ライトセンサーによるTTLトリガー
% 
% ライトセンサーによるStimTrackerの制御は完全にパッシブであり、ライトセンサーがディス
% プレイの発光を検出することでTTLトリガーを出力する。
% 刺激提示ディスプレイの辺縁部の実験に影響の少ない箇所にライトセンサーを設置する。
% 刺激提示ソフトウェアのディスプレイ制御により、センサー直下の部分が白く発光すれば接続し
% たチャンネルがHiとなり、暗くなればLoとなる。
% 
% 基本的には実験前に実機を用いたテストが必要。
% ソフトウェア側ではディスプレイの発光位置がセンサー位置と一致するように実験プログラムの
% パラメータ調整をする必要がある。
% ハードウェア側では、StimTracker本体のフロントパネルのボタンとダイヤルを操作してセン
% サーの感度を調整する必要がある。
% 実験者は以下の公式サポートページを読み込んで勉強しておくこと。
% https://www.cedrus.com/support/stimtracker/tn1906_using_st.htm
% https://www.cedrus.com/support/stimtracker/tn1908_onset_visual.htm
% 
% センサーをどのチャンネルに接続しているのかを必ず意識すること。
% チャンネルの対応表は以下の公式ページを参照。
% https://www.cedrus.com/support/stimtracker/tn1960_quad_ttl_output.htm
% 
% 
%% USB接続によるTTLトリガー
% 
% USBドライバーは、Linuxの場合はカーネルに組み込まれているため不要である。
% Windowsの場合は通常はWindows Updateで自動的にインストールされるが、トラブルが発生
% する場合は別途ドライバーのインストールが必要である。
% https://ftdichip.com/drivers/vcp-drivers/
% そもそもPTBをWindows上で使用すべきではない。
% 
% StimTrackerはUSBをシリアルポートとして通信することで制御できる。 
% シリアルポートは単純な文字列を送るだけの旧式の通信方式で産業用の機械の制御や設定に今も
% 広く用いられている（うちのラボで身近な例だとETG-4000）。
% 初めて聞く人はRS-232Cについて軽くググっておくこと。
% StimTrackerの場合はPCからStimTrackerにUSB経由でASCII文字列をリトルエンディアンで
% 送信することで制御する。
% MATLABの場合はserialport関数を用いて制御する。(serial関数は廃止予定なので使用禁止)
% help serialport
% https://www.mathworks.com/help/matlab/serial-port-devices.html
% 
% 送受信する文字列は機器ごとに予め定義されており、Cedrusでは独自にXID Version 2と呼称
% されるコマンド群が実装されている。
% 実験コードを書く人はCedrus公式サポートページにこれらのコマンドが全て詳しく書いてある
% ので、必ず自分の目で確認すること。
% https://www.cedrus.com/support/xid/commands.htm
% 
% 【重要】MATLABからシリアル通信でTTLを出力した場合の遅延は5-6msとなるため、時間的精度
% が要求される実験では必ずライトセンサーを使うこと。シリアル通信で高い精度が必要な場合は
% CedrusのC++のライブラリを使うと遅延が2-3msに抑えられるため、それをmex関数にして使う
% こと。
% 
% 
%% このデモコードの内容
% 
% このデモコードはディスプレイdell S2319HS(23インチ、1920×1080、60Hz)の左上部にライ
% トセンサー設置した構成で開発されている。
% 必要に応じてパラメータを調整せよ。
% 
% ライトセンサーは1番のジャックに接続している前提で書かれている。
% Cedrus公式サポートサイトのピン出力表より、ジャック1番のライトセンサーのTTLはチャンネ
% ル8に出力される。
% https://www.cedrus.com/support/stimtracker/tn1960_quad_ttl_output.htm
% 
% ヒューマンエラー防止の観点からライトセンサーに専有されるチャンネル（今回はch.8）はUSB
% の出力をするチャンネルと併用しないことを推奨する。
% 
% このデモコードでは以下の4チャンネルを用いる。
% USB bit0 :       channel 1
% USB bit1 :       channel 2
% USB bit2 :       channel 3
% Light Sensor 1 : channel 8
% 
% このデモコードでは以下のような処理を行う。
% 
% 【スタート】
% シリアルポートを検索してStimTrackerのポートを特定
% 
% TTLトリガーのパルス持続時間を１秒に設定
% 
% PTB関連の設定及びOpenWindow
% 
% TTLトリガー ch.1(USB0) 1s
% 
% for 3回繰り返し 
%   注視点 2s
% 
%   文字刺激 5s
%   TTLトリガー ch.8(ライトセンサー) 2s
%   TTLトリガー ch.2(USB1) 1s
% 
%   インターバル 0.5s
% end
% 
% TTLトリガー ch.3(USB2) 1s
% 【終了】
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clear device
commandwindow
homeDir = fileparts(mfilename('fullpath'));
sca
PsychDefaultSetup(2);
% Screen('Preference', 'SyncTestSettings', 0.002); %only when noisy


%% detect StimTracker and open serial port %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% まず、シリアルポートを検索してStimTrackerを特定し、初期設定をする。

% parameters
device_found = 0;
ports = serialportlist("available");

% search serial ports
for p = 1:length(ports)

    device = serialport(ports(p),115200,"Timeout",1);
    % シリアルポートオブジェクトを作成。
    % Cedrusのボーレートのデフォルト値は115k。
    % ボーレートの異なる複数機器を組み合わせる場合はこのコードを見直すこと。
    
    device.flush()
    % 入出力バッファのクリア
    
    write(device,"_c1","char")
    query_return = read(device,5,"char");
    % 文字列"_c1"をchar型でシリアルポートのデバイスに送信すると、Cedrusのデバイスは
    % "_xid0"などの文字列で応答する。
    % この応答の文字列は
    % "_xid" + "モードを示す数字"
    % の形になっている。
    % StimTrackerはXIDモード以外のモードには対応していないので応答文字列は必ず"_xid0"
    % となるが、他のCedrus製品を使用する場合は適切に設定する必要があるので注意。 
    
    % Cedrus device detected
    if ~isempty(query_return) && query_return == "_xid0"
        device_found = 1;
        break
    end
end

% Cedrus devices undetected
if device_found == 0
    disp("No XID device found. Exiting.")
    return % exit script
end

%% まずはじめに設定："mp"コマンドを使ってTTLパルスの持続時間を設定
% 
% 後述の"mh"コマンドを使って指定したチャンネルでTTLトリガーを出力するが、その際は以下の
% "mp"コマンドで設定する持続時間（今回の場合1000ms）が適用される。
% 
% "mp" + "持続時間"
% 
% ・持続時間：パルス持続時間（ミリ秒）、デフォルト値=0(持続時間無限)、4バイト、リトルエンディアン
% 
% TTLパルスのデフォルト持続時間を1秒に設定するコマンドは十六進数・ASCIIに変換すると以
% 下のようになる。※これらは数値としては全て同じである。
% 
% 【注意】バイトオーダーはリトルエンディアンなので逆順になる（わからなければ必ずググれ）
% 
%  m    p            1000
% 0x6D 0x70   0xE8 0x03 0x00 0x00   <- hex
% 109  112    232   3    0    0     <- ASCII
% 
% 例えば、16進数を用いる場合は以下の様にシリアルポートで送信する。
write(device, [0x6D, 0x70, 0xE8, 0x03, 0x00, 0x00], "uint8"); 
% また、別の書き方として、上と全く同じ信号を、16進数ではなくASCIIで送信したい場合は以下
% の通り。
% write(device,sprintf("mp%c%c%c%c", 232, 3, 0, 0), "char");
% 
% 【参考】さらに別の書き方として、末尾で定義した関数を使うと上のwriteと全く同じ処理を以
% 下のようにわかりやすく書くこともできる。
% setPulseDuration(device, 1000)
% 第2引数で持続時間を指定。


%% "mh"コマンドをつかってUSB経由で指定チャンネルでTTLトリガーを送信する 
% 今回のUSBによるTTLトリガーの送信は全て"mh"コマンドを使用するのでここで説明しておく。
% 
% "mh" + "チャンネル"
% 
% ・チャンネル：長さ2バイト、8チャンネルの各ビットにつき1=Hi/0=Lo、StimTrackerの場合
% は8チャンネルのみなので全16桁のうち上8桁は無視、リトルエンディアン
% 
% 上の"mp"コマンドで指定した持続時間のTTLパルスを送信できる。
% 例えば、チャンネル1,2,3(USB0,1,2)のみ送信する場合は以下のようになる。
%
% 【注意】チャンネルのビット順は逆になるのでch8,ch7,...,ch2,ch1の順番で2進数で表記する。
% 
%  m    h     0b00000111
% 0x6D 0x68   0x07 0x00     <- hex
% 109  104     7    0       <- ASCII
% 
% write(device, [0x6D, 0x68, 0xE0, 0x00], "uint8"); %input by hex
%  または
% write(device,sprintf("mh%c%c", 7, 0), "char"); %input by ASCII
% 
% 末尾のコメントにチャンネルのビット指定の例をいくつか載せているので参考に。
% 
% 初期設定時に全てのチャンネルをLoに落としておくと癖をつけておくと良い
write(device, [0x6D, 0x68, 0x00, 0x00], "uint8"); % lower all lines


%% PTB Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scr   = max(Screen('Screens')); % 環境依存
bkClr = BlackIndex(scr);
whClr = WhiteIndex(scr);

% light sensor parameters 環境依存　モニターにあわせてパラメーターを調整する
litSenX = 15;  %発光位置X
litSenY = 15;  %発光位置Y
litDiam = 10;  %発光範囲直径
litT    = 2.0; %発光時間秒

% task parameters
bgClr   = (bkClr+whClr)/2; % bg:background
fixClr  = bkClr;
stimClr = bkClr;
swchT   = 0.5;
fixT    = 2.0;
stimT   = 5.0;
stimTxt = 'STIM ON';

% fixation cross
fixMat = [0,1,0; 1,1,1; 0,1,0]*fixClr + [1,0,1; 0,0,0; 1,0,1]*bgClr;                           
fixSz  = 30;

try

    %% open window %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    [wptr, wRect] = PsychImaging('OpenWindow', scr, bgClr); % 環境依存

    % initial settings
    Priority(1);
    hz = Screen('NominalFrameRate', wptr, 1);
    Screen('BlendFunction', wptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [xCntr, yCntr] = RectCenter(wRect);
    
    % fixation cross
    fixPos = [xCntr-fixSz, yCntr-fixSz, xCntr+fixSz, yCntr+fixSz];
    fixTex = Screen('MakeTexture', wptr, fixMat);
    
    HideCursor;


    %% Start Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

    Screen('gluDisk', wptr, bkClr, litSenX, litSenY, litDiam); %light sensor(ch8) Lo
    % ライトセンサー直下は全てのフレームで黒または白を描画すること。冒頭で定義したパラメーターでgluDiskを使用すると調整も簡単。
    flipT = Screen('Flip', wptr);
    write(device,sprintf("mh%c%c", 1, 0), "char"); %USB0(ch1)
    
    for i = 1:3
    
        % 注視点表示
        Screen('gluDisk', wptr, bkClr, litSenX, litSenY, litDiam); %light sensor(ch8) Lo
        Screen('DrawTexture', wptr, fixTex, [], fixPos, [],0); %fixation cross
        flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz);
        
        % 視覚刺激提示開始
        Screen('gluDisk', wptr, whClr, litSenX, litSenY, litDiam); %light sensor(ch8) Hi
        DrawFormattedText(wptr, stimTxt, 'center', 'center', stimClr); %visual stimulus
        flipT = Screen('Flip', wptr, flipT+fixT-0.5/hz);
        write(device,sprintf("mh%c%c", 2, 0), "char"); %USB1(ch2)

        % litT < stimT の場合は、litT秒後にライトセンサーの出力だけを落として、それ以外は全く同じ刺激を提示する
        Screen('gluDisk', wptr, bkClr, litSenX, litSenY, litDiam); %light sensor(ch8) Lo
        DrawFormattedText(wptr, stimTxt, 'center', 'center', stimClr); %全く同じ視覚刺激をレンダリング
        Screen('Flip', wptr, flipT+litT-0.5/hz); %刺激提示時間がstimTとなるようにflipTにflip時刻を記録しない

        % 視覚刺激提示終了
        Screen('gluDisk', wptr, bkClr, litSenX, litSenY, litDiam); %light sensor(ch8) Lo
        flipT = Screen('Flip', wptr, flipT+stimT-0.5/hz);
    
    end
    write(device,sprintf("mh%c%c", 4, 0), "char"); %USB2(ch3)
    WaitSecs(2); % 初回呼び出しは時間精度低い
    sca

catch me    
    sca
    ListenChar(0);
    rethrow(me)

end
sca
clear device

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 上の"mp"コマンドの説明コメントで言及した関数(Cedrusのデモコードより)

function byte = getByte(val, index)
    byte = bitand(bitshift(val,-8*(index-1)), 255);
end

function setPulseDuration(device, duration)
%mp sets the pulse duration on the XID device. The duration is a four byte
%little-endian integer.
    write(device, sprintf("mp%c%c%c%c", getByte(duration,1),...
        getByte(duration,2), getByte(duration,3),...
        getByte(duration,4)), "char")
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 【参考】チャンネルの指定は2進数で考える
% 
% 上述の通り、チャンネルは2進数でch8,ch7,...,ch2,ch1の順番で指定する。
% 
% 【例】
% USB0 (ch.1)のみ
% 0b000000001
% 0x01 0x00    <- hex
%  1    0      <- ASCII
% 
% USB1 (ch.2)のみ
% 0b00000010
% 0x02 0x00    <- hex
%  2    0      <- ASCII
% 
% USB1 (ch.2) && USB2 (ch.3) 
% 0b00000110
% 0x06 0x00    <- hex
%  6    0      <- ASCII
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 【参考】"mx"コマンドでUSB経由で任意のTTL出力をする方法
% 
% USB経由で任意のチャンネルをHiまたはLoにするには上のようにシリアルポートのアドレスを特
% 定したうえでそのポートに以下のようにASCII文字列をリトルエンディアンで送信する。
% 
% "mx" + "持続時間" + "チャンネル" + "パルスの回数" + "パルス間隔"
% 
% ・持続時間：2バイトのパラメーター。"0"でLo、"0xFFFF"でHi、他は任意の数字を指定する
% ことでミリ秒単位でTTLのパルスの長さを指定する。
% 
% ・チャンネル：2バイトのパラメーター。"1"で指定したビットのチャンネルにコマンドが適用
% され、"0"で指定したビットのチャンネルは無視される。
% 
% ・パルスの回数：1バイトのパラメーター。TTL出力の際のパルスの回数を指定する。持続時間
% が"0"または"0xFFFF"の場合は無視される。
% 
% ・パルス間隔：2バイトのパラメーター。パルス間の間隔。パルスの回数が2未満の場合は無視さ
% れる。
% 
% 詳細は公式サポートページを参照。この他にもたくさんのコマンドが載っている。
% https://www.cedrus.com/support/xid/commands.htm
% 
% 例えば、USB 0,1,2で1秒間のパルスを一回だけ出力する場合は以下の文字列を送信する。
%  m    x    ,    1000   , 0b00000111  ,  1    ,     0
% 0x6D 0x78    0xE8 0x03    0x07 0x00    0x01    0x00 0x00  <-hex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%