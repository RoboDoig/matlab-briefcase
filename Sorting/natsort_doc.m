%% NATSORT Examples
% The function <https://www.mathworks.com/matlabcentral/fileexchange/34464
% |NATSORT|> sorts a cell array of strings, taking into
% account any number values within the strings. This is known as a "natural
% order sort" or an "alphanumeric sort". Note that MATLAB's inbuilt
% <http://www.mathworks.com/help/matlab/ref/sort.html |SORT|> function only
% sorts by character order (as per |sort| in most programming languages).
%
% For sorting filenames or filepaths use
% <https://www.mathworks.com/matlabcentral/fileexchange/47434 |NATSORTFILES|>.
%
% For sorting the rows of a cell array of strings use
% <https://www.mathworks.com/matlabcentral/fileexchange/47433 |NATSORTROWS|>.
%
%% Basic Usage: Integer Numbers
% By default |NATSORT| interprets consecutive digits as being part of
% a single integer, each number is considered to be as wide as one letter:
A = {'a2', 'a10', 'a1'};
sort(A)
natsort(A)
B = {'v10.6', 'v9.10', 'v9.5', 'v10.10', 'v9.10.20', 'v9.10.8'};
sort(B)
natsort(B)
%% Output 2: Sort Index
% The second output argument is a numeric array of the sort indices |ndx|,
% such that |Y = X(ndx)| where |Y = natsort(X)|:
[~,ndx] = natsort(A)
%% Output 3: Debugging Array
% The third output is a cell array containing the individual characters and
% numbers (after converting to numeric). This is useful for confirming that
% the numbers are being correctly identified and parsed into numeric values.
% Note that the rows of the array are linear indexed from the input cell array.
[~,~,dbg] = natsort(B)
%% Regular Expression: Decimal Numbers, E-notation, +/- Sign.
% The |NATSORT| algorithm uses <http://www.mathworks.com/help/matlab/ref/regexp.html
% |REGEXP|> to detect numbers in the strings, and so provides a convenient
% way to specify the format of the numbers, e.g. decimal, +/- sign, etc.:
% by providing an appropriate <http://www.mathworks.com/help/matlab/matlab_prog/regular-expressions.html
% regular expression> as the second input argument:
C = {'test+Inf', 'test11.5', 'test-1.4', 'test', 'test-Inf', 'test+0.3'};
sort(C)
natsort(C, '(-|+)?(Inf|\d+(\.\d+)?)')
D = {'0.56e007', '', '4.3E-2', '10000', '9.8'};
sort(D)
natsort(D, '\d+(\.\d+)?(E(+|-)?\d+)?')
%% Regular Expression: Hexadecimal, Octal, and Binary Numbers.
% Numbers encoded in hexadecimal, octal, or binary may also be parsed and
% sorted correctly. This requires both an appropriate regular expression
% that can detect the numbers correctly, and also a suitable |SSCANF|
% format string (see the section " |SSCANF| Format String"):
E = {'a0X7C4z', 'a0X5z', 'a0X18z', 'aFz'};
sort(E)
natsort(E, '(?<=a)(0X)?[0-9A-F]+', '%x')
F = {'a11111000100z', 'a0B101z', 'a0B000000000011000z', 'a1111z'};
sort(F)
natsort(F, '(0B)?[01]+', '%b')
%% |SSCANF| Format String: Hexadecimal, Octal, and 64 Bit Numbers.
% The default format string of |%f| will correctly parse many common number
% substrings. This includes decimal integers, decimal digits, NaN, Inf, and
% numbers written in E-notation. For hexadecimal, octal, and for
% large integers the format string must be specified as an input argument:
% the supported <http://www.mathworks.com/help/matlab/ref/sscanf.html
% |SSCANF|> formats are shown in this table:
%
% <html>
% <table>
%  <tr><th>Format String</th><th>Number Types</th></tr>
%  <tr><td>%e, %f, %g</td>   <td>floating point numbers</td></tr>
%  <tr><td>%d</td>           <td>signed decimal</td></tr>
%  <tr><td>%i</td>           <td>signed decimal, octal, or hexadecimal</td></tr>
%  <tr><td>%ld, %li</td>     <td>signed 64 bit, decimal, octal, or hexadecimal</td></tr>
%  <tr><td>%u</td>           <td>unsigned decimal</td></tr>
%  <tr><td>%o</td>           <td>unsigned octal</td></tr>
%  <tr><td>%x</td>           <td>unsigend hexadecimal</td></tr>
%  <tr><td>%lu, %lo, %lx</td><td>unsigned 64-bit decimal, octal, or hexadecimal</td></tr>
% </table>
% </html>
%
% For example large
% integers can be converted to 64-bit numerics, with their full precision:
natsort({'a18446744073709551615z', 'a18446744073709551614z'}, [], '%lu')
%% Sort Options: Case Sensitivity
% By default |NATSORT| provides a case-insensitive sort of the input
% strings. An optional argument controls the case sensitivity (the option
% |ignorecase| sorts all letter characters as being upper-case):
G = {'a2', 'A20', 'A1', 'a10','A2', 'a1'};
natsort(G, [], 'ignorecase') % default
natsort(G, [], 'matchcase')
%% Sort Options: Sort Direction
% By default |NATSORT| provides an ascending sort of the input strings. An
% optional argument controls the sort direction (characters and numbers
% are either both ascending or both descending):
H = {'2', 'a', '3', 'B', '1'};
natsort(H, [], 'ascend') % default
natsort(H, [], 'descend')
%% Sort Options: Order of Numbers Relative to Characters
% By default |NATSORT| treats the detected numbers as if they sorted with
% the digit characters. An optional argument allows the numbers to be
% sorted before or after all characters:
X = num2cell(char(32+randperm(63)));
cell2mat(natsort(X, [], 'asdigit')) % default
cell2mat(natsort(X, [], 'beforechar'))
cell2mat(natsort(X, [], 'afterchar'))