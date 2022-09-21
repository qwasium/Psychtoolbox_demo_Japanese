% -------------------------------------------------------------------------
% "タイトル"
% "日付"
% "開発者の氏名"
% "MATLABのバージョン"
% "OSの種類"
% "ディスプレイの解像度"
% "ディスプレイのリフレッシュレート"
% "アイトラッカーの機種"
% -------------------------------------------------------------------------
% バージョン情報
% v0.0 Aug.4,2022 SK テンプレート作成
% v1.0 日付、開発者、変更内容
% -------------------------------------------------------------------------
% requires Psychtoolbox and Titta.
% 
% 初めて見る人がわかるように基本情報を記述。
% ・研究テーマは？
% ・プロジェクトメンバーは？
% ・実験プロトコルはどこに保存されている？
% ・その他必要なことを書く
% 
% 
% Tobiiのスクリーンベースアイトラッカーを用いた実験スクリプトのテンプレート。
% TittaのREADMEをもとにしている。
% https://github.com/dcnieho/Titta.git
% TittaでのSpectrumのデフォルト設定はサンプリングレートは600Hzとなっているのでこのテ
% ンプレートでは檀ラボでの運用にあわせて1200Hzに設定を変更している。
% 
% 読んでもなにもわからない人はまずPTB_Beginner.mを見よ。
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
homeDir = pwd;
sca
PsychDefaultSetup(2);

%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eyeTrackerModel = 'Tobii Pro Spectrum';
% eyeTrackerModel = 'Tobii Pro Fusion';
scr       = max(Screen('Screens')); % 環境依存
bkClr = BlackIndex(scr);
whClr = WhiteIndex(scr);

% task parameters
bgClr    = (bkClr + whClr)/2; % bg:background
fixClr   = bkClr;
picT     = 5;
fixT     = .5;
% trgtText = 'AAA';


try    

    %% eye tracker parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % デフォルト設定の構造体
    settings = Titta.getDefaults(eyeTrackerModel);
    
    % デバッグメッセージの出力をオン
    settings.debugMode      = true;
    
    % キャリブレーションでdrawFunctionを使用
    calViz                      = AnimatedCalibrationDisplay();
    settings.cal.drawFunction   = @calViz.doDraw;
    
    % Spectrumの場合はサンプリングレートを1200Hzに固定して初期化
    EThndl          = Titta(settings);
    if strcmp(eyeTrackerModel, 'Tobii Pro Spectrum')
        settings        = EThndl.getOptions();
        settings.freq   = 1200;
        EThndl.setOptions(settings);
    end
%     EThndl          = EThndl.setDummyMode();    % テスト用
    EThndl.init();

    
    %% open PTB screen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [wptr, wRect] = Screen('OpenWindow', scr, bgClr);
    hz = Screen('NominalFrameRate', wptr);
    Priority(1);
    Screen('BlendFunction', wptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [xCntr, yCntr] = RectCenter(wRect);
            
    
    %% calibration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ListenChar(-1);
    EThndl.calibrate(wptr);
    ListenChar(0);

    % 計測開始
    EThndl.buffer.start('gaze');
    WaitSecs(.8);   % 起動にかかる時間の余裕
    
    HideCursor;
    
    %% Start Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    flipT = Screen('Flip',wptr);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% ここに実験の処理を書く %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 例↓
    % 
    % 注視点
    % Screen('gluDisk',wptr,0,wRect(3)/2,wRect(4)/2,round(wRect(3)/100)); 
    % flipT = Screen('Flip', wptr, flipT+1-0.5/hz);
    % EThndl.sendMessage('FIX ON',flipT); % タスク開始時刻を記録
    % 
    % 文字刺激を提示
    % DrawFormattedText(wptr, trgtText, 'center', 'center', stmClr);
    % EThndl.sendMessage(sprintf('STIM ON: %s',stimFName{p}),flipT); % 刺激提示開始時刻を記録
    % 
    % 刺激提示を終了
    % EThndl.sendMessage(sprintf('STIM OFF: %s',stimFName{p}),flipT); % 刺激提示終了時刻を記録
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 計測停止
    sca
    EThndl.buffer.stop('gaze');
    
    % 計測データをmatファイルに出力
    dat = EThndl.collectSessionData();
    dat.expt.wRect = wRect;
    save(EThndl.getFileName(fullfile(homeDir,'t'), true),'-struct','dat');
    % EThndl.saveData('filename'); % ファイル名を直接指定して保存する場合

    % シャットダウン
    EThndl.deInit();

catch me
    sca
    ListenChar(0);
    rethrow(me)
end
sca

