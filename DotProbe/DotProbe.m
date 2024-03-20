% ----------------------------------------------
% DotProbe task 
% June. 5, 2022
% @author: Simon Kuwahara
% Developed on MATLAB R2022a on Ubuntu 22.04LTS.
% ----------------------------------------------
% 
% Add Psychtoolbox to path before running.
% PTBのパス追加忘れないように
% 
% If not compatible with variable refresh rate, PsychImaging('OpenWindow')
% will fail. In that case,use Screen('OpenWindow') instead.
% Do NOT connect multiple displays. Connect display directly to GPU.
% Use DisplayPort or HDMI. Do NOT use adapters.

clear all
sca
PsychDefaultSetup(2);


%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scr = max(Screen('Screens'));
blkClr = BlackIndex(scr);
whClr = WhiteIndex(scr);

% task parameters
bgClr    = blkClr; % back ground color
stmClr   = whClr;  % stimulus color
stmT     = 0.5;    % stimulus time
stmOfst  = 200;    % stimulus position offset
respT    = 2;      % response time
iti      = 1.25;   % inter trial interval
fixT     = 0.5;    % fixation time
fixSz    = 15;     % fixation cross size
fixMat   = [0,1,0; 1,1,1; 0,1,0]; % 3*3 image matrix, check if bgClr change
trgtText = ['left', 'right'];

% text parameters
% Screen('Preference', 'TextEncodingLocale', 'Shift-JIS');
Screen('Preference', 'DefaultFontName', 'Courier New');
Screen('Preference', 'DefaultFontSize', 100);


%%% open window %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[wptr, wRect] = PsychImaging('OpenWindow', scr, bgClr);
% [wptr, wRect] = PsychImaging('OpenWindow', scr, bgClr, [], [], [], [], 4); % antialiasing
Priority(1);
hz = Screen('NominalFrameRate', wptr, 1);
Screen('BlendFunction', wptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[xCntr, yCntr] = RectCenter(wRect);

% fixation cross
fixTex = Screen('MakeTexture', wptr, fixMat);
fixPos = [xCntr-fixSz, yCntr-fixSz, xCntr+fixSz, yCntr+fixSz];


%%% Start Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HideCursor;
DrawFormattedText(wptr, '5', 'center', 'center', stmClr);
flipT = Screen('Flip', wptr);
DrawFormattedText(wptr, '4', 'center', 'center', stmClr);
flipT = Screen('Flip', wptr, flipT+1-0.5/hz);
DrawFormattedText(wptr, '3', 'center', 'center', stmClr);
flipT = Screen('Flip', wptr, flipT+1-0.5/hz);
DrawFormattedText(wptr, '2', 'center', 'center', stmClr);
flipT = Screen('Flip', wptr, flipT+1-0.5/hz);
DrawFormattedText(wptr, '1', 'center', 'center', stmClr);
flipT = Screen('Flip', wptr, flipT+1-0.5/hz);

Screen('DrawTexture', wptr, fixTex, [], fixPos, [],0);
flipT = Screen('Flip', wptr, flipT+1-0.5/hz);

DrawFormattedText(wptr, trgtText(1:4), 'right', 'center', stmClr, [],[],[],[],[], [wRect(1:2), xCntr-stmOfst, wRect(4)]);
DrawFormattedText(wptr, trgtText(5:9), xCntr+stmOfst, 'center', stmClr);
flipT = Screen('Flip', wptr, flipT+fixT-0.5/hz);

Screen('gluDisk', wptr, stmClr, xCntr+stmOfst, yCntr, 50);
flipT = Screen('Flip', wptr, flipT+stmT-0.5/hz);


WaitSecs(2);
ShowCursor;
sca