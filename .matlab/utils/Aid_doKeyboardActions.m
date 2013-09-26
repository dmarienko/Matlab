function outputpara = Aid_doKeyboardActions(doActions)
% One-line description here, please.
%
% INVOKING: outputpara = Aid_doMouseActions(inputpara)
%
% CATEGORY: Aid — D:\sds\tools\DA\MatlabM\Lastdatenanalyse\Aid
%
%% DESCRIPTION
%   
%
%% INPUT
%     inputpara ... 
%
%% OUTPUT
%    outputpara ... 
%
%% EXAMPLES
%{

%}  
%% VERSIONING
%             Author: Andreas J*****, ****-***, ** ** *** ** ** *** **-*
%      Creation date: 2013-03-22
%             Matlab: 8.0.0.783 (R2012b)
%  Required Products: -
%            Version: 1.0
%
%% REVISIONS
%
% V1.0 | 2013-03-28 |    Andreas J***** | Ersterstellung
%
%
% See also 
%% --------------------------------------------------------------------------------------------

import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;

%% --------------------------------------------------------------------------------------------

keyboard = Robot;
keyboard.delay(50); %ms


kbCtrl = KeyEvent.VK_CONTROL;
kbShft = KeyEvent.VK_SHIFT;
kbAlt  = KeyEvent.VK_ALT;
kb = {
%   '' ,[],    [],    [],    [],    [];   
    'a', KeyEvent.VK_A,[],[],[],[];
    'A', kbShft,KeyEvent.VK_A,[],[],[];
    '(', kbShft,KeyEvent.VK_8,[],[],[];
    ')', kbShft,KeyEvent.VK_9,[],[],[];
    '[', kbCtrl,kbAlt,KeyEvent.VK_8,[],[];
    ']', kbCtrl,kbAlt,KeyEvent.VK_9,[],[];
    '{', kbCtrl,kbAlt,KeyEvent.VK_7,[],[];
    '}', kbCtrl,kbAlt,KeyEvent.VK_0,[],[];
    'KEY_ENTER',KeyEvent.VK_ENTER ,[],[],[],[];
%     '''',kbShft,KeyEvent.VK_NUMBER_SIGN,[],[],[]; % endlos schleife
%     '"', kbShft,KeyEvent.VK_2,[],[],[];           % endlos schleife
    };


[s,e] = regexp(doActions,'(ARROW_LEFT|ARROW_RIGHT|ARROW_UP|ARROW_DOWN|KEY_ENTER)','start','end');
if ~isempty(s)
    for ii = 1:numel(s)
        do{ii} = doActions(s(ii):e(ii));
    end
else
    s = inf;
end

ii = 1;
iii = 1;
while ii <= numel(doActions)
    doIf = 1;
    if ii == s(iii)
        doActions_ = do{iii};
        ii = e(iii);
        iii = iii+1;
    else
        doActions_ = doActions(ii);
    end
    
    idx_kb = Aid_SearchCell(kb(:,1),doActions_,false);
    
    if doIf && ~all(idx_kb==0)
        doKeyboard = kb(idx_kb,:);
%         ------ PRESS ------
        for jj = 2:numel(doKeyboard)
            if ~isempty(doKeyboard{jj})
                keyboard.keyPress(doKeyboard{jj})
            else
                keyboard.keyRelease(kbShft);
                keyboard.keyRelease(kbCtrl);
                keyboard.keyRelease(kbAlt);
                break
            end
        end
        doIf = 0;
    end
    % Arrow Keys
    arrowKey = regexp(doActions_,'(?<=ARROW_)(LEFT|RIGHT|UP|DOWN)','match');
    if doIf && ~isempty(arrowKey)
        keyboard.keyPress(eval(['KeyEvent.VK_',arrowKey{:}]));
        keyboard.keyRelease(eval(['KeyEvent.VK_',arrowKey{:}]));
        doIf = 0;
    end
    % lower Alhpa
    if doIf && ~isempty(regexp(doActions_,'[a-z]', 'once'))
        keyboard.keyPress(eval(['KeyEvent.VK_',upper(doActions_)]));
        doIf = 0;
    end
    % upper Alhpa
    if doIf && ~isempty(regexp(doActions_,'[A-Z]', 'once'))
        keyboard.keyPress(kbShft);
        keyboard.keyPress(eval(['KeyEvent.VK_',upper(doActions_)]));
        keyboard.keyRelease(kbShft)
        doIf = 0;
    end
    % numeric
    if doIf && ~isempty(regexp(doActions_,'[0-9]', 'once'))
        keyboard.keyPress(eval(['KeyEvent.VK_',doActions_]));
        doIf = 0;
    end


    ii = ii+1;
end



%{
static char	CHAR_UNDEFINED 
          KEY_PRESSED and KEY_RELEASED events which do not map to a valid Unicode character use this for the keyChar value.
static int	KEY_FIRST 
          The first number in the range of ids used for key events.
static int	KEY_LAST 
          The last number in the range of ids used for key events.
static int	KEY_LOCATION_LEFT 
          A constant indicating that the key pressed or released is in the left key location (there is more than one possible location for this key).
static int	KEY_LOCATION_NUMPAD 
          A constant indicating that the key event originated on the numeric keypad or with a virtual key corresponding to the numeric keypad.
static int	KEY_LOCATION_RIGHT 
          A constant indicating that the key pressed or released is in the right key location (there is more than one possible location for this key).
static int	KEY_LOCATION_STANDARD 
          A constant indicating that the key pressed or released is not distinguished as the left or right version of a key, and did not originate on the numeric keypad (or did not originate with a virtual key corresponding to the numeric keypad).
static int	KEY_LOCATION_UNKNOWN 
          A constant indicating that the keyLocation is indeterminate or not relevant.
static int	KEY_PRESSED 
          The "key pressed" event.
static int	KEY_RELEASED 
          The "key released" event.
static int	KEY_TYPED 
          The "key typed" event.
static int	VK_0 
          VK_0 thru VK_9 are the same as ASCII '0' thru '9' (0x30 - 0x39)
static int	VK_1 
           
static int	VK_2 
           
static int	VK_3 
           
static int	VK_4 
           
static int	VK_5 
           
static int	VK_6 
           
static int	VK_7 
           
static int	VK_8 
           
static int	VK_9 
           
static int	VK_A 
          VK_A thru VK_Z are the same as ASCII 'A' thru 'Z' (0x41 - 0x5A)
static int	VK_ACCEPT 
          Constant for the Accept or Commit function key.
static int	VK_ADD 
           
static int	VK_AGAIN 
           
static int	VK_ALL_CANDIDATES 
          Constant for the All Candidates function key.
static int	VK_ALPHANUMERIC 
          Constant for the Alphanumeric function key.
static int	VK_ALT 
           
static int	VK_ALT_GRAPH 
          Constant for the AltGraph function key.
static int	VK_AMPERSAND 
           
static int	VK_ASTERISK 
           
static int	VK_AT 
          Constant for the "@" key.
static int	VK_B 
           
static int	VK_BACK_QUOTE 
           
static int	VK_BACK_SLASH 
           
static int	VK_BACK_SPACE 
           
static int	VK_BRACELEFT 
           
static int	VK_BRACERIGHT 
           
static int	VK_C 
           
static int	VK_CANCEL 
           
static int	VK_CAPS_LOCK 
           
static int	VK_CIRCUMFLEX 
          Constant for the "^" key.
static int	VK_CLEAR 
           
static int	VK_CLOSE_BRACKET 
           
static int	VK_CODE_INPUT 
          Constant for the Code Input function key.
static int	VK_COLON 
          Constant for the ":" key.
static int	VK_COMMA 
           
static int	VK_COMPOSE 
          Constant for the Compose function key.
static int	VK_CONTROL 
           
static int	VK_CONVERT 
          Constant for the Convert function key.
static int	VK_COPY 
           
static int	VK_CUT 
           
static int	VK_D 
           
static int	VK_DEAD_ABOVEDOT 
           
static int	VK_DEAD_ABOVERING 
           
static int	VK_DEAD_ACUTE 
           
static int	VK_DEAD_BREVE 
           
static int	VK_DEAD_CARON 
           
static int	VK_DEAD_CEDILLA 
           
static int	VK_DEAD_CIRCUMFLEX 
           
static int	VK_DEAD_DIAERESIS 
           
static int	VK_DEAD_DOUBLEACUTE 
           
static int	VK_DEAD_GRAVE 
           
static int	VK_DEAD_IOTA 
           
static int	VK_DEAD_MACRON 
           
static int	VK_DEAD_OGONEK 
           
static int	VK_DEAD_SEMIVOICED_SOUND 
           
static int	VK_DEAD_TILDE 
           
static int	VK_DEAD_VOICED_SOUND 
           
static int	VK_DECIMAL 
           
static int	VK_DELETE 
           
static int	VK_DIVIDE 
           
static int	VK_DOLLAR 
          Constant for the "$" key.
static int	VK_DOWN 
          Constant for the non-numpad down arrow key.
static int	VK_E 
           
static int	VK_END 
           
static int	VK_ENTER 
           
static int	VK_EQUALS 
           
static int	VK_ESCAPE 
           
static int	VK_EURO_SIGN 
          Constant for the Euro currency sign key.
static int	VK_EXCLAMATION_MARK 
          Constant for the "!" key.
static int	VK_F 
           
static int	VK_F1 
          Constant for the F1 function key.
static int	VK_F10 
          Constant for the F10 function key.
static int	VK_F11 
          Constant for the F11 function key.
static int	VK_F12 
          Constant for the F12 function key.
static int	VK_F13 
          Constant for the F13 function key.
static int	VK_F14 
          Constant for the F14 function key.
static int	VK_F15 
          Constant for the F15 function key.
static int	VK_F16 
          Constant for the F16 function key.
static int	VK_F17 
          Constant for the F17 function key.
static int	VK_F18 
          Constant for the F18 function key.
static int	VK_F19 
          Constant for the F19 function key.
static int	VK_F2 
          Constant for the F2 function key.
static int	VK_F20 
          Constant for the F20 function key.
static int	VK_F21 
          Constant for the F21 function key.
static int	VK_F22 
          Constant for the F22 function key.
static int	VK_F23 
          Constant for the F23 function key.
static int	VK_F24 
          Constant for the F24 function key.
static int	VK_F3 
          Constant for the F3 function key.
static int	VK_F4 
          Constant for the F4 function key.
static int	VK_F5 
          Constant for the F5 function key.
static int	VK_F6 
          Constant for the F6 function key.
static int	VK_F7 
          Constant for the F7 function key.
static int	VK_F8 
          Constant for the F8 function key.
static int	VK_F9 
          Constant for the F9 function key.
static int	VK_FINAL 
           
static int	VK_FIND 
           
static int	VK_FULL_WIDTH 
          Constant for the Full-Width Characters function key.
static int	VK_G 
           
static int	VK_GREATER 
           
static int	VK_H 
           
static int	VK_HALF_WIDTH 
          Constant for the Half-Width Characters function key.
static int	VK_HELP 
           
static int	VK_HIRAGANA 
          Constant for the Hiragana function key.
static int	VK_HOME 
           
static int	VK_I 
           
static int	VK_INPUT_METHOD_ON_OFF 
          Constant for the input method on/off key.
static int	VK_INSERT 
           
static int	VK_INVERTED_EXCLAMATION_MARK 
          Constant for the inverted exclamation mark key.
static int	VK_J 
           
static int	VK_JAPANESE_HIRAGANA 
          Constant for the Japanese-Hiragana function key.
static int	VK_JAPANESE_KATAKANA 
          Constant for the Japanese-Katakana function key.
static int	VK_JAPANESE_ROMAN 
          Constant for the Japanese-Roman function key.
static int	VK_K 
           
static int	VK_KANA 
           
static int	VK_KANA_LOCK 
          Constant for the locking Kana function key.
static int	VK_KANJI 
           
static int	VK_KATAKANA 
          Constant for the Katakana function key.
static int	VK_KP_DOWN 
          Constant for the numeric keypad down arrow key.
static int	VK_KP_LEFT 
          Constant for the numeric keypad left arrow key.
static int	VK_KP_RIGHT 
          Constant for the numeric keypad right arrow key.
static int	VK_KP_UP 
          Constant for the numeric keypad up arrow key.
static int	VK_L 
           
static int	VK_LEFT 
          Constant for the non-numpad left arrow key.
static int	VK_LEFT_PARENTHESIS 
          Constant for the "(" key.
static int	VK_LESS 
           
static int	VK_M 
           
static int	VK_META 
           
static int	VK_MINUS 
          Constant for the "-" key.
static int	VK_MODECHANGE 
           
static int	VK_MULTIPLY 
           
static int	VK_N 
           
static int	VK_NONCONVERT 
          Constant for the Don't Convert function key.
static int	VK_NUM_LOCK 
           
static int	VK_NUMBER_SIGN 
          Constant for the "#" key.
static int	VK_NUMPAD0 
           
static int	VK_NUMPAD1 
           
static int	VK_NUMPAD2 
           
static int	VK_NUMPAD3 
           
static int	VK_NUMPAD4 
           
static int	VK_NUMPAD5 
           
static int	VK_NUMPAD6 
           
static int	VK_NUMPAD7 
           
static int	VK_NUMPAD8 
           
static int	VK_NUMPAD9 
           
static int	VK_O 
           
static int	VK_OPEN_BRACKET 
           
static int	VK_P 
           
static int	VK_PAGE_DOWN 
           
static int	VK_PAGE_UP 
           
static int	VK_PASTE 
           
static int	VK_PAUSE 
           
static int	VK_PERIOD 
           
static int	VK_PLUS 
          Constant for the "+" key.
static int	VK_PREVIOUS_CANDIDATE 
          Constant for the Previous Candidate function key.
static int	VK_PRINTSCREEN 
           
static int	VK_PROPS 
           
static int	VK_Q 
           
static int	VK_QUOTE 
           
static int	VK_QUOTEDBL 
           
static int	VK_R 
           
static int	VK_RIGHT 
          Constant for the non-numpad right arrow key.
static int	VK_RIGHT_PARENTHESIS 
          Constant for the ")" key.
static int	VK_ROMAN_CHARACTERS 
          Constant for the Roman Characters function key.
static int	VK_S 
           
static int	VK_SCROLL_LOCK 
           
static int	VK_SEMICOLON 
           
static int	VK_SEPARATER 
          This constant is obsolete, and is included only for backwards compatibility.
static int	VK_SEPARATOR 
          Constant for the Numpad Separator key.
static int	VK_SHIFT 
           
static int	VK_SLASH 
           
static int	VK_SPACE 
           
static int	VK_STOP 
           
static int	VK_SUBTRACT 
           
static int	VK_T 
           
static int	VK_TAB 
           
static int	VK_U 
           
static int	VK_UNDEFINED 
          This value is used to indicate that the keyCode is unknown.
static int	VK_UNDERSCORE 
          Constant for the "_" key.
static int	VK_UNDO 
           
static int	VK_UP 
          Constant for the non-numpad up arrow key.
static int	VK_V 
           
static int	VK_W 
           
static int	VK_X 
           
static int	VK_Y 
           
static int	VK_Z 
%}


