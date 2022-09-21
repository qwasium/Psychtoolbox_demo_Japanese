clear all; % clears all workspace variables
close all; % closes all open figures

try
    participantID = input('Please enter your initials ','s');
    participantage = input('Please enter your age ');
    participantgender = input('Please enter your gender ','s');

    [w1,rect]=Screen('OpenWindow',0,0);
    [center(1), center(2)] = RectCenter(rect);
    Priority(MaxPriority(w1));
    HideCursor();
    
    nTrials = 10;
    numbergo = 5;
    
    buttonpressed = zeros(nTrials,1);
    targettime = zeros(nTrials,1);
    responsetime = zeros(nTrials,1);
    conditions = [ones(1,numbergo),repmat(2,1,nTrials-numbergo)];
    rng('shuffle');
    conditionsrand = conditions(randperm(length(conditions)));

    Screen('DrawText',w1, 'Press any key to begin', center(1)-100,center(2)-10,255);
    Screen('Flip', w1);
    pause;
    Screen('Flip', w1);
    WaitSecs(1);
    
    [circlecoordinates] = circleprep(100,center);

    for trialcount = 1:nTrials

        if conditionsrand(trialcount) == 1
            Screen('FillOval',w1, [0 255 0], circlecoordinates);
        else
            Screen('FillOval',w1, [255 0 0], circlecoordinates);
        end;

        Screen('Flip', w1);
        targettime(trialcount) = GetSecs;
        
        tic;
        while toc < 1.5
            [~, keysecs, keyCode] = KbCheck;
            if keyCode(KbName('space')) == 1
                responsetime(trialcount) = keysecs;
                buttonpressed(trialcount) = 1;
            end;
        end;
        Screen('Flip', w1);
        
        [~, ~, keyCode] = KbCheck;
        if keyCode(KbName('q')) == 1
            break
        end;
        
        jitterinterval = 1 + (3-1).*rand;
        WaitSecs(jitterinterval);

    end;
    
    save(sprintf('%s_data_%dGo',participantID,numbergo));

    Screen('Close', w1)
    Priority(0);
    ShowCursor();
    
catch
    Screen('Close', w1)
    Priority(0);
    ShowCursor();
    psychrethrow(psychlasterror);
end;