% -------------------------------------------------------------------------
% Psychtoolbox demo for Japanese Text
% Feb. 19, 2023
% Simon Kuwahara
% R2022a Ubuntu 22.04
% Dell P2312Ht 1920*1080 60Hz
% UTF-8 LF
% -------------------------------------------------------------------------
% v0.0 Jul.20,2022 Simon Kuwahara template_Simple.m
% v1.0 Feb.19,2023 Simon Kuwahara demo_JapaneseText.m
% -------------------------------------------------------------------------
% 
% Comments are in Japanese.
% Open in Japanese language enabled environment if broken.
% 
% PTBの基礎知識を有している読者を前提に書かれている。
% なにもわからない人はまずdemo_ForBeginner.mを見よ。
%
% 
%% 日本語文字列表示の概要
%
% 日本語テキストを含めたUnicode文字を表示させる方法についてデモが用意されている。
% 日本国内の実験ではほぼ確実に使うので以下のデモスクリプトには必ず目を通しておくこと！
% 
% DrawHighQualityUnicodeTextDemo
% 
% このスクリプトの内容は基本的にこの↑公式デモに準拠している。
% 公式デモコードを自分で読んで理解できる人はこのデモコードを読む必要はない。
% 
% 日本語文字列の表示では2点注意すれば良い。
% 
% ・char → Unicode → double型に変換すること
% ・フォントをきちんと設定すること
% 
% フォントを設定をしなかった場合、もしデフォルトのフォントが日本語非対応だと表示でき
% なかったりするので注意すること。
% OS独自のフォントを使用しているなど環境に依存する場合はコメントに明記すること。
% 基本的にはこのスクリプトで記述してあるように設定することを推奨する。
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all %#ok<CLALL> 
commandwindow
homeDir = fileparts(mfilename('fullpath'));
sca
GetSecs(0);
PsychDefaultSetup(2);
% Screen('Preference', 'SyncTestSettings', 0.002); % SyncErrorが頻発する場合


%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scr   = max(Screen('Screens')); % 環境依存
bkClr = BlackIndex(scr);
whClr = WhiteIndex(scr);

% color
bgClr  = bkClr; % bg:background
fixClr = whClr;
stmClr = whClr;

% time
fixT  = 1.0;
swchT = 2.0;

% position
stmOfst = 200;

%% 日本語文字列のデータ型 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cntrTxt  = double(native2unicode('真ん中は中央揃え', 'SHIFT-JIS'));
leftTxt  = double(native2unicode('左は右揃え', 'SHIFT-JIS'));
rightTxt = double(native2unicode('右は左揃え', 'SHIFT-JIS'));
upTxt    = double(native2unicode('上は下揃え', 'SHIFT-JIS'));
dwnTxt   = double(native2unicode('下は上揃え', 'SHIFT-JIS'));
% PTBではテキストはcharまたはunit8またはdouble型のみが認められているが基本的にはdouble
% 配列に変換して扱うことが推奨される。
% 
% char   文字配列
% uint8  符号無し整数     8bit
% double 倍精度浮動小数点 64bit
% 
% 以下のステップを用いることで日本語文字列を正しく扱うことができる。
% 1. 日本語文字列をchar配列にして、(注意：string不可)
% 2. native2unicode関数を用いてエンコードをSHIFT-JIS指定でUnicodeに変換し、
% 3. 最後にdouble型に変換する
% 
% help native2unicode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% text
fontSz = 100;
Screen('Preference', 'DefaultFontSize', fontSz);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 1);
Screen('Preference', 'TextAlphaBlending', 0);
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);

% fixation cross
fixMat = [0,1,0; 1,1,1; 0,1,0]*fixClr + [1,0,1; 0,0,0; 1,0,1]*bgClr;                            
fixSz  = 15;

try

    %% open window %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    [wptr, wRect] = PsychImaging('OpenWindow', scr, bgClr); % 環境依存

    % initial settings
    Priority(1);
    hz = Screen('NominalFrameRate', wptr, 1);
    Screen('BlendFunction', wptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [xCntr, yCntr] = RectCenter(wRect);
   

%% 日本語に対応したフォントを選択する %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if Screen('Preference', 'TextRenderer') == 1
        
        % Screen('TextFont',...)で日本語に適したフォントを自動選択する。
        % これはTextRendererが無いと動作しないのでif文の中に書かれている。
        % 任意のフォントも選択できるが、実行環境にそのフォントがインストールされていない
        % 場合は実行はするものの、テキストだけ表示されないので注意。
        % フォントをハードコードした場合、環境依存となるので冒頭コメントに書くこと。
        oldFnt = Screen('TextFont', wptr, '-:lang=ja');
        
        % 自動選択された日本語フォントをjapFntという変数に格納すると後で確認できる。
        % 筆者の環境では'Noto Sans CJK JP'が選択された。
        japFnt = Screen('TextFont', wptr);

    end

% あまりドキュメンテーションも無いので将来的に加筆されたし。
% help DrawTextPlugin
% http://psychtoolbox.org/docs/DrawTextPlugin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    % fixation cross
    fixPos = [xCntr-fixSz, yCntr-fixSz, xCntr+fixSz, yCntr+fixSz];
    fixTex = Screen('MakeTexture', wptr, fixMat);
    
    HideCursor;
    
    %% Start Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    % 3
    Screen('FillRect', wptr, bgClr);
    DrawFormattedText(wptr, '3', 'center', 'center', stmClr);
    flipT = Screen('Flip', wptr);
    
    % 2
    Screen('FillRect', wptr, bgClr);
    DrawFormattedText(wptr, '2', 'center', 'center', stmClr);
    flipT = Screen('Flip', wptr, flipT+1-0.5/hz);
    
    % 1
    Screen('FillRect', wptr, bgClr);
    DrawFormattedText(wptr, '1', 'center', 'center', stmClr);
    flipT = Screen('Flip', wptr, flipT+1-0.5/hz);
    
    % fixation cross
    Screen('FillRect', wptr, bgClr);
    Screen('DrawTexture', wptr, fixTex, [], fixPos, [],0);
    flipT = Screen('Flip', wptr, flipT+1-0.5/hz);
    
    % 中央にテキストを表示
    Screen('FillRect', wptr, bgClr);
    DrawFormattedText(wptr, cntrTxt, 'center', 'center', stmClr);
    flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz);
    
%% 上下左右にテキストを表示 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DrawFormattedTextのドキュメント参照
% help DrawFormattedText
% http://psychtoolbox.org/docs/DrawFormattedText

    Screen('FillRect', wptr, bgClr);

    % 上にテキストを配置、Yの位置決めはテキスト下端がyCntr-stmOfstとなるようにテキスト位置を設定
    DrawFormattedText(wptr, upTxt, 'center', yCntr-stmOfst, stmClr);
    %     ウィンドウポインター 文字列  x基準:中心  y基準:座標で指定  文字色

    % 下にテキストを配置、Yの位置決めはテキスト下端がyCntr+stmOfst+fontSzとなるようにテキスト位置を設定
    DrawFormattedText(wptr, dwnTxt, 'center', yCntr+stmOfst+fontSz, stmClr);
    %     ウィンドウポインター 文字列  x基準:中心   y基準:座標で指定         文字色

    % 左にテキストを配置、Xの位置決めはテキスト右端がxCntr-stmOfstとなるように描画範囲を設定
    DrawFormattedText(wptr, leftTxt, 'right', 'center', stmClr, [],[],[],[],[], [wRect(1:2), xCntr-stmOfst, wRect(4)]);
    %     ウィンドウポインター  文字列  x基準:右端  y基準:中心  文字色              テキストを描画するウィンドウ範囲：0,0,x=右端位置を設定,y

    % 右にテキストを配置、Xの位置決めはテキスト左端がxCntr+stmOfstとなるようにテキスト位置を設定
    DrawFormattedText(wptr, rightTxt, xCntr+stmOfst, 'center', stmClr);
    %     ウィンドウポインター  文字列    x基準:座標で指定  y基準:中心  文字色
    
    flipT = Screen('Flip', wptr, flipT+fixT-0.5/hz);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Screen('FillRect', wptr, bgClr);
    flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz);
    sca
catch me    
    sca
    ListenChar(0);
    rethrow(me)
end
sca

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 【参考】OSの言語設定が日本語の場合 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 環境依存のコーディングは非推奨；あくまでも参考知識として扱うこと
% 
% 日本語表示をする際はOSの言語設定を日本語にしておくと、double型のまま日本語文字列を直
% 接突っ込んでも動作する。
% また、Windows日本語設定ではエンコードをShift-JIS指定にするとcharで突っ込むことも可。
% 
% Screen('Preference', 'TextEncodingLocale', 'Shift-JIS'); 
% 
% ただし、このようなコーディングは非推奨である。
% ・実行環境に依存するコードとなる
% ・OSの言語設定が原因で表示されない場合、初心者は原因に気付きにくい
% 
% 明確な理由がある場合を除いて、このデモスクリプトのように実行環境に依存しないコーディング
% が望ましい。