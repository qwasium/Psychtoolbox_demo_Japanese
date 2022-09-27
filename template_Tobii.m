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
% 変数dummyMode = trueでテスト、falseでアイトラッカー作動。
% 
% 読んでもなにもわからない人はまずPTB_Beginner.mを見よ。
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
sca
PsychDefaultSetup(2);

dummyMode = false;
% dummyMode = true;

if ~dummyMode
    prompt   = {'ID (year-month-day-number)', 'condition'};
    dlgtitle = 'initial input';
    dims     = [1 35];
    definput = {'202209999999', 'A'};
    answer   = inputdlg(prompt,dlgtitle,dims,definput);
    ID        = cell2mat(answer(1));
    condition = cell2mat(answer(2));
end

%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% eye tracker
eyeTrackerModel = 'Tobii Pro Spectrum';
% eyeTrackerModel = 'Tobii Pro Fusion';


% screen
scr = max(Screen('Screens'));
% Screen('Preference', 'SyncTestSettings', 0.002); 

% color
bkClr  = BlackIndex(scr);
whClr  = WhiteIndex(scr);
bgClr  = (bkClr + whClr)/2; % bg:background
fixClr = bkClr;

% time
picT = 10;
fixT = 2;
ISI  = 1;
endT = 5;

% fixation cross
fixSz  = 30;
fixMat = [0,1,0; 1,1,1; 0,1,0]*fixClr + [1,0,1; 0,0,0; 1,0,1]*bgClr;

% txt
trgtText = double('TEST');
Screen('Preference', 'DefaultFontName', 'Noto');
Screen('Preference', 'DefaultFontSize', 60);


% directories
homeDir = fileparts(mfilename('fullpath'));

try    

    %% Eye tracker parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % get defaul settings structure
    settings = Titta.getDefaults(eyeTrackerModel);
    
    % toggle debug message
    settings.debugMode = true;
    
    % use draw function during calibration
    calViz                    = AnimatedCalibrationDisplay();
    settings.cal.drawFunction = @calViz.doDraw;
    
    % set sampling rate to 1200Hz if using Spectrum then initialize
    EThndl = Titta(settings);
    if strcmp(eyeTrackerModel, 'Tobii Pro Spectrum')
        settings      = EThndl.getOptions();
        settings.freq = 1200;
        EThndl.setOptions(settings);
    end
    % for testing
    if dummyMode
        EThndl    = EThndl.setDummyMode();    
    end
    EThndl.init();

    
    %% open PTB window %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [wptr, wRect] = PsychImaging('OpenWindow', scr, bgClr);
    hz = Screen('NominalFrameRate', wptr);
    Priority(1);
    Screen('BlendFunction', wptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [xCntr, yCntr] = RectCenter(wRect);

    % fixation cross
    fixPos = [xCntr-fixSz, yCntr-fixSz, xCntr+fixSz, yCntr+fixSz];
    fixTex = Screen('MakeTexture', wptr, fixMat);

    %% calibration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ListenChar(-1);
    EThndl.calibrate(wptr);
    ListenChar(1);

    % start eyetracking %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    EThndl.buffer.start('gaze');
    WaitSecs(.8);   % some lag for startup
    
    %% Start Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    HideCursor;
    Screen('FillRect', wptr, bgClr);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% ここに実験の処理を書く %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 例↓
    % 
    % % wait keypress
    % while true
    %     [keyIsDown, secs, keyCode] = KbCheck;
    %     if keyIsDown
    %         flipT = Screen('Flip', wptr);
    %         break;
    %     end
    % end
    % 
    % % fixation
    % Screen('gluDisk',wptr,0,wRect(3)/2,wRect(4)/2,round(wRect(3)/100)); 
    % flipT = Screen('Flip', wptr, flipT+1-0.5/hz);
    % EThndl.sendMessage('FIX ON',flipT); % fix on time
    % 
    % % stim onset
    % DrawFormattedText(wptr, trgtText, 'center', 'center', stmClr);
    % EThndl.sendMessage(sprintf('STIM ON: %s',stimFName{p}),flipT); % stim on time
    % 
    % % stim off
    % EThndl.sendMessage(sprintf('STIM OFF: %s',stimFName{p}),flipT); % stim off time
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    sca
    ListenChar(0);
    
    % stop eyetracking
    EThndl.buffer.stop('gaze');
    
    % export data
    if ~dummyMode
        cd(homeDir);
        dat = EThndl.collectSessionData();
        dat.expt.wRect     = wRect;
        dat.participant.ID = ID;
        dat.participant.condition = condition;
        save(EThndl.getFileName(fullfile(dataDir, 't'), true),'-struct','dat');
        % EThndl.saveData('./t'); % save file alternative
    end

    % shutdown
    EThndl.deInit();

catch me
    sca
    EThndl.deInit();
    ListenChar(0);
    rethrow(me)
end
sca
    



