function idx = Aid_SearchCell(cellString,expr,ignorecase,noExprManipulate,DEBUGMODE)
% Durchsucht eine CellString Array nach der gegeben Regex und gibt dann entsprechenden logischen index zurück
%
% INVOKING: idx = Aid_SearchCell(cellString,expr)
%
% CATEGORY: Aid — D:\LO\DA\MatlabM\Lastdatenanalyse\Aid
%
%% DESCRIPTION
% Durchsucht eine CellString Array nach der gegeben Regex und gibt dann entsprechenden logischen index zurück
%
%% INPUT
%       cellString ... mxnxo CellString
%             expr ... gültige regex suche
%       ignorecase ... ignoriert groß/kleinschreibung  DEFAULT: true
% noExprManipulate ... true: expr == regex string      DEFAULT: false
%        DEBUGMODE ... 0 keine Ausgabe                 DEFAULT: 0
%                      1 Augabe von fund/nicht fund
%                      2 Ausgabe von fund
%                      3 Ausgabe von nicht fund
%
%% OUTPUT
%{   
             idx ... index in der cell

cellString(:,:)   = {'A','B','C';'D','E','F'};
cellString(:,:,2) = {'Cl','D','G';'Hacl','Z','L'};

cellString(:,:,1) =         cellString(:,:,2) = 
    'A'    'B'    'C'            'Cl'      'D'    'G'
    'D'    'E'    'F'            'Hacl'    'Z'    'L'

idx = Aid_SearchCell(cellString,'C')
idx(:,:,1) =                idx(:,:,2) =
     0     0     1               1     0     0
     0     0     0               1     0     0
%}
%% EXAMPLES
%{
[c1c2c3]    Any character contained within the brackets: c1 or c2 or c3
[^c1c2c3]   Any character not contained within the brackets: anything but c1 or c2 or c3
[c1-c2]     Any character in the range of c1 through c2
\s          Any white-space character; equivalent to [ \f\n\r\t\v]
\S          Any nonwhitespace character; equivalent to [^ \f\n\r\t\v]
\w          Any alphabetic, numeric, or underscore character. For English character sets, this is equivalent to [a-zA-Z_0-9].
\W          Any character that is not alphabetic, numeric, or underscore. For English character sets, this is equivalent to [^a-zA-Z_0-9].
\d          Any numeric digit; equivalent to [0-9]
\D          Any nondigit character; equivalent to [^0-9]

(F|M).(x|z)     => Sucht nach einer Kraft oder einem Moment in x bzw z richtung
PkF1\D          => Sucht nach PkF1 (es steht keine nummer nach dem 1er)
PkF             => Sucht nach PkF(Nr) (zb auch PkF12)
PkF([1-4])      => Sucht nach PkF(1-4) (zb auch PkF 12 oder PkF 34)
PkF([1-4])\D    => Sucht nach PkF(1-4)
PkF([1,4])\D    => Sucht nach PkF(1,4)

* kann für ein folgende Zeichen stehen: 'a-zA-Z' '_' '0-9' ',' '.' '~' ';' '-', '§'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Aid_getChanByRegex(SP,'F.x*1t*Pkf([1-4])*')
Aid_getChanByRegex(SP,'F.x*1t*Pkf([1,4])*')
Aid_getChanByRegex(SP,'(F|M).x*1t*Pkf([1,4])*')
Aid_getChanByRegex(SP,'(F|M).x*LaLg1*')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chList = Signal_nameChannel(SP,1:numel(SP.Messstelle),0,0,0,0,0,0)';
idx = Aid_SearchCell(chList,expr);

nCh = [SP.Messstelle(idx).Ch]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}  
%% VERSIONING
%             Author: Andreas J*****, ****-***, ** ** *** ** ** *** **-*
%      Creation date: 2012-08-22
%             Matlab: 7.14.0.739 (R2012b)
%  Required Products: -
%            Version: 1.0
%
%% REVISIONS
%
% V1.0 | 2012-08-22 |    Andreas J***** | Ersterstellung
% V1.1 | 2012-09-12 |    Andreas J***** | Code Optimierung
% V1.2 | 2012-10-11 |    Andreas J***** | Performance Optimierung
%                                         @isempty wrde fr:
%                                           cellString = repmat({'a'},10000,1000);
%                                           expr = 'a';
%                                          47 sekunden bentigen, mit neuer variante dauert es nur 7 sekunden
% V1.3 | 2013-01-16 |    Andreas J***** | wenn eine Cell bergeben wird die nicht nur aus strings besteht
%                                         werden sie durch '' ersetzt.
% V2.0 | 2013-02-04 |    Andreas J***** | Wenn doubles, logicals oder NaNs angegeben wurden so werden diese in strings
%                                         konvertiert -> damit ist es jetzt auch mglich nach zahlen zu suchen.
% See also 

%% --------------------------------------------------------------------------------------------
narginchk(1,5)
if ~isa(cellString,'cell')
    error('Aid_SearchCell:CellChk', 'Input ist keine Cell')
end
if nargin < 5 || isempty(DEBUGMODE)
    DEBUGMODE = false;
end
if nargin < 4 || isempty(noExprManipulate)
    noExprManipulate = false;
end
if nargin < 2 || isempty(expr)
    expr = '';
else
    if ~noExprManipulate
        if strcmp(regexp(expr,'\.','match'),'.')
            expr = regexprep(expr, '\.', '\\.');
        end
        expr = regexprep(expr, '\*', '\.\*');
    end
end

if nargin < 3 || isempty(ignorecase)
    ignorecase = true;
end

flag1 = 0;
for ii = 1:numel(cellString)
    if isa(cellString{ii},'char') %nvmd
    elseif isa(cellString{ii},'double') || isa(cellString{ii},'logical')
        cellString{ii} = num2str(cellString{ii});
        flag1 = 1;
    else
        cellString{ii} = '';
    end
end
if flag1
%     warning('Es wurden auch andere typen als "CHAR" gefunden. Diese wurden durch '''' ersetzt. Idee: automatisch num2str etc.')
end

% idx = cellfun(@(x)( ~isempty(x) ), regexpi(cellString,expr));
if ignorecase
    idx = ~cellfun('isempty', regexpi(cellString,expr));
else
    idx = ~cellfun('isempty', regexp(cellString,expr));
end
if DEBUGMODE > 0
    if any(DEBUGMODE == [1,2])
        fprintf('expr: %s; found: \n',expr)
        fprintf('%s, ',cellString{idx})
        fprintf('\n')
    end
    if any(DEBUGMODE == [1,3]) && all(~idx)
        cprintf('Green','\n NOT FOUND %s \n',expr);
    end
end

