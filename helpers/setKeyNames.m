function keyNameStruct = setKeyNames(keyMap)
    %% Set psychtoolbox key names
    % 
    % Sep. 2023 by SK
    % Psychtoolobox 3.0.19
    % MATLAB R2023a
    % Ubuntu 22.04 Xorg
    % 
    % Parameters
    % ----------
    % keyMap : containors.Map or dictionary
    %      Optional
    #      Custom key names to be set for each keycode.
    %      If not provided, key name set by KbName('keyNames') will be
    %      used.
    %      key   : (cell array) standard key name set by KbName('keyNames')
    %      value : (cell array) custom key name
    % 
    % Returns
    % -------
    % keyNameStruc : structure
    %       Key codes for keys below.
    %       A single key can have multiple key codes.
    %       fields : each key, see code
    %       values : key code, can be vector of double.   
    %       example :
    %             escapeKey: 10
    %                oneKey: 11
    %                twoKey: 12
    %              threeKey: 13
    %               fourKey: 14
    %               fiveKey: 15
    %                sixKey: 16
    %              sevenKey: 17
    %              eightKey: 18
    %               nineKey: 19
    %               zeroKey: 20
    %              minusKey: 21
    %              equalKey: 22
    %               backKey: 23
    %                tabKey: 24
    %                  qKey: 25
    %                  wKey: 26
    %                  eKey: 27
    %                  rKey: 28
    %                  tKey: 29
    %                  yKey: 30
    %                  uKey: 31
    %                  iKey: 32
    %                  oKey: 33
    %                  pKey: 34
    %                 atKey: 35
    %        LeftBracketKey: 36
    %              enterKey: [37 105]
    %                  aKey: 39
    %                  sKey: 40
    %                  dKey: 41
    %                  fKey: 42...
    % 
    % reference:
    %   help KbName
    % 
    % check all key names with:
    %   KbName('KeyNames')
    % 
    % syntax of key code assignment: 
    %   keycode of the indicated key = KbName(string designating a key label)
    % 

    keyNameStruct = struct;

    % deprecated syntax is used for backwords compatibility
    if nargin < 1
        KbName('UnifyKeyNames');
        osxKeys = KbName('keyNames');
        keyMap  = containers.Map(osxKeys, osxKeys);
    end

    % number row keys
    keyNameStruct.escapeKey = KbName(keyMap('ESCAPE'));
    keyNameStruct.oneKey    = KbName(keyMap('1!'));
    keyNameStruct.twoKey    = KbName(keyMap('2@'));
    keyNameStruct.threeKey  = KbName(keyMap('3#'));
    keyNameStruct.fourKey   = KbName(keyMap('4$'));
    keyNameStruct.fiveKey   = KbName(keyMap('5%'));
    keyNameStruct.sixKey    = KbName(keyMap('6^'));
    keyNameStruct.sevenKey  = KbName(keyMap('7&'));
    keyNameStruct.eightKey  = KbName(keyMap('8*'));
    keyNameStruct.nineKey   = KbName(keyMap('9('));
    keyNameStruct.zeroKey   = KbName(keyMap('0)'));
    keyNameStruct.minusKey  = KbName(keyMap('-_'));
    keyNameStruct.equalKey  = KbName(keyMap('asciicircum'));
    keyNameStruct.backKey   = KbName(keyMap('BackSpace'));
    keyNameStruct.tabKey    = KbName(keyMap('tab'));
    
    
    % top row keys
    keyNameStruct.qKey            = KbName(keyMap('q'));
    keyNameStruct.wKey            = KbName(keyMap('w'));
    keyNameStruct.eKey            = KbName(keyMap('e'));
    keyNameStruct.rKey            = KbName(keyMap('r'));
    keyNameStruct.tKey            = KbName(keyMap('t'));
    keyNameStruct.yKey            = KbName(keyMap('y'));
    keyNameStruct.uKey            = KbName(keyMap('u'));
    keyNameStruct.iKey            = KbName(keyMap('i'));
    keyNameStruct.oKey            = KbName(keyMap('o'));
    keyNameStruct.pKey            = KbName(keyMap('p'));
    keyNameStruct.atKey           = KbName(keyMap('at'));
    keyNameStruct.rightBracketKey = KbName(keyMap(']}'));
    keyNameStruct.leftBracketKey  = KbName(keyMap('[{'));
    keyNameStruct.enterKey        = KbName(keyMap('Return'));
    
    % middle row keys
    keyNameStruct.aKey         = KbName(keyMap('a'));
    keyNameStruct.sKey         = KbName(keyMap('s'));
    keyNameStruct.dKey         = KbName(keyMap('d'));
    keyNameStruct.fKey         = KbName(keyMap('f'));
    keyNameStruct.gKey         = KbName(keyMap('g'));
    keyNameStruct.hKey         = KbName(keyMap('h'));
    keyNameStruct.jKey         = KbName(keyMap('j'));
    keyNameStruct.kKey         = KbName(keyMap('k'));
    keyNameStruct.lKey         = KbName(keyMap('l'));
    keyNameStruct.semiColonKey = KbName(keyMap(';:'));
    keyNameStruct.colonKey     = KbName(keyMap('colon'));
    keyNameStruct.zenkakuKey   = KbName(keyMap('Zenkaku_Hankaku'));
    
    % bottom row keys
    keyNameStruct.leftShiftKey  = KbName(keyMap('LeftShift'));
    keyNameStruct.zKey          = KbName(keyMap('z'));
    keyNameStruct.xKey          = KbName(keyMap('x'));
    keyNameStruct.cKey          = KbName(keyMap('c'));
    keyNameStruct.vKey          = KbName(keyMap('v'));
    keyNameStruct.bKey          = KbName(keyMap('b'));
    keyNameStruct.nKey          = KbName(keyMap('n'));
    keyNameStruct.mKey          = KbName(keyMap('m'));
    keyNameStruct.commaKey      = KbName(keyMap(',<'));
    keyNameStruct.periodKey     = KbName(keyMap('.>'));
    keyNameStruct.slashKey      = KbName(keyMap('/?'));
    keyNameStruct.RightShiftKey = KbName(keyMap('RightShift'));
    
    % non-character keys
    keyNameStruct.leftControlKey  = KbName(keyMap('LeftControl'));
    keyNameStruct.leftSuperKey    = KbName(keyMap('LeftGUI'));
    keyNameStruct.leftAltKey      = KbName(keyMap('LeftAlt'));
    keyNameStruct.spaceKey        = KbName(keyMap('space'));
    keyNameStruct.rightAltKey     = KbName(keyMap('RightAlt'));
    keyNameStruct.rightSuperKey   = KbName(keyMap('RightGUI'));
    keyNameStruct.rightControlKey = KbName(keyMap('RightControl'));
    keyNameStruct.asteriskKey     = KbName(keyMap('*'));
    keyNameStruct.backSlashKey    = KbName(keyMap('\|'));
    keyNameStruct.eisuKey         = KbName(keyMap('Eisu_toggle'));


    % function keys
    keyNameStruct.f1Key  = KbName(keyMap('F1'));
    keyNameStruct.f2Key  = KbName(keyMap('F2'));
    keyNameStruct.f3Key  = KbName(keyMap('F3'));
    keyNameStruct.f4Key  = KbName(keyMap('F4'));
    keyNameStruct.f5Key  = KbName(keyMap('F5'));
    keyNameStruct.f6Key  = KbName(keyMap('F6'));
    keyNameStruct.f7Key  = KbName(keyMap('F7'));
    keyNameStruct.f8Key  = KbName(keyMap('F8'));
    keyNameStruct.f9Key  = KbName(keyMap('F9'));
    keyNameStruct.f10Key = KbName(keyMap('F10'));
    keyNameStruct.f11Key = KbName(keyMap('F11'));
    keyNameStruct.f12Key = KbName(keyMap('F12'));

    % lock keys
    keyNameStruct.numLockKey    = KbName(keyMap('NumLock'));
    keyNameStruct.scrollLockKey = KbName(keyMap('ScrollLock'));

    % arrow keys
    keyNameStruct.leftArrowKey  = KbName(keyMap('LeftArrow'));
    keyNameStruct.upArrowKey    = KbName(keyMap('UpArrow'));
    keyNameStruct.rightArrowKey = KbName(keyMap('RightArrow'));
    keyNameStruct.downArrowKey  = KbName(keyMap('DownArrow'));

    % editing keys
    keyNameStruct.insertKey   = KbName(keyMap('Insert'));
    keyNameStruct.homeKey     = KbName(keyMap('Home'));
    keyNameStruct.pageUpKey   = KbName(keyMap('PageUp'));
    keyNameStruct.pageDownKey = KbName(keyMap('PageDown'));
    keyNameStruct.deleteKey   = KbName(keyMap('DELETE'));
    keyNameStruct.endKey      = KbName(keyMap('End'));

    % number pad keys
    keyNameStruct.numPad0Key     = KbName(keyMap('0'));
    keyNameStruct.numPad1Key     = KbName(keyMap('1'));
    keyNameStruct.numPad2Key     = KbName(keyMap('2'));
    keyNameStruct.numPad3Key     = KbName(keyMap('3'));
    keyNameStruct.numPad4Key     = KbName(keyMap('4'));
    keyNameStruct.numPad5Key     = KbName(keyMap('5'));
    keyNameStruct.numPad6Key     = KbName(keyMap('6'));
    keyNameStruct.numPad7Key     = KbName(keyMap('7'));
    keyNameStruct.numPad8Key     = KbName(keyMap('8'));
    keyNameStruct.numPad9Key     = KbName(keyMap('9'));
    keyNameStruct.numPadDotKey   = KbName(keyMap('.'));
    keyNameStruct.numPadMinusKey = KbName(keyMap('-'));
    keyNameStruct.numPadPlusKey  = KbName(keyMap('+'));
    keyNameStruct.numPadSlashKey = KbName(keyMap('/'));

    % I got bored...
    % Add keys here if this is not enough.


end % function

