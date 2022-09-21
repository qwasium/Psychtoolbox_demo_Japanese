% -------------------------------------------------------------------------
% "タイトル"
% "日付"
% "開発者の氏名"
% "MATLABのバージョン"
% "OSの種類"
% "ディスプレイの解像度"
% "ディスプレイのリフレッシュレート"
% "エンコード"
% -------------------------------------------------------------------------
% バージョン情報
% v0.0 Jul.20,2022 Simon Kuwahara テンプレート作成
% v1.0 日付、開発者、変更内容
% -------------------------------------------------------------------------
% 
% なにもわからない人はPTB_Beginner.mを見よ。
% 
% 初めて見る人がわかるように基本情報を記述。
% ・研究テーマは？
% ・プロジェクトメンバーは？
% ・実験プロトコルはどこに保存されている？
% ・その他必要なことを書く
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
homeDir = fileparts(mfilename('fullpath'));
sca
PsychDefaultSetup(2);
% Screen('Preference', 'SyncTestSettings', 0.002); %システムノイズが多くてSyncErrorが頻発する場合


%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scr = max(Screen('Screens')); % 環境依存
bkClr = BlackIndex(scr);
whClr = WhiteIndex(scr);

% color
bgClr    = bkClr; % bg:background
fixClr   = whClr;

% time
% swchT    = 0.5;
% fixT     = 2.0;

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
    
    % fixation cross
    fixPos = [xCntr-fixSz, yCntr-fixSz, xCntr+fixSz, yCntr+fixSz];
    fixTex = Screen('MakeTexture', wptr, fixMat);
    
    HideCursor;
    
    %% Start Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% ここに実験の処理を書く %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 例↓
    % flipT = Screen('Flip', wptr);
    % Screen('DrawTexture', wptr, fixTex, [], fixPos, [],0);
    % flipT = Screen('Flip', wptr, flipT+swchT-0.5/hz);
    % Screen('FillRect', wptr, bkClr);
    % flipT = Screen('Flip', wptr, flipT+fixT-0.5/hz);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    sca

catch me    
    sca
    ListenChar(0);
    rethrow(me)

end
sca
