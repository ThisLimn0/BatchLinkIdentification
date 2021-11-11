@if (@CodeSection == @Batch) @then
@ECHO OFF & SETLOCAL ENABLEDELAYEDEXPANSION

:MAIN
REM CALL :ClearAll
SET "getClipCmd=cscript /nologo /e:JScript "%~f0""
SET "URL="
FOR /f "tokens=*" %%I IN ('%getClipCmd%') DO (
	SET "URL=%%I"
)
CALL :SanitiseUserInput
CALL :AnalyseInput
SET "L1="
SET "L2="
FOR /L %%A IN (0,1,9) DO FOR /L %%B IN (0,1,9) DO IF DEFINED URL%%A%%BA SET "L2=!L2! !URL%%A%%BA! ^|"
CALL :CalculateLineLength
FOR /L %%A IN (0,1,9) DO IF DEFINED URL%%A SET "L1=!L1! !URL%%A! ^|"

SET "URLOld=%URL%"

REM // For performance reasons output down below, computing above.

CLS
ECHO.URLDepthLevel and Dissection
ECHO. http: // www . example . com / page . php?parameter=loremipsum
ECHO.   0    ^|           1           ^|            2                    [URLDepthLevel]
ECHO.   0    ^|   0  ^|    1     ^|  2  ^|    0    ^|          1          ^| [Dissection:Delimiter{.}]
ECHO.___________________________________________________________________________________________
FOR /L %%A IN (1,1,2) DO ECHO.!L%%A!
GOTO :MAIN

REM //
REM // END OF MAIN
REM //

:SanitiseUserInput
IF NOT "%URL:~0,1%"=="h" (
	ECHO.Status: Invalid URL.
	TIMEOUT /T 2 >NUL 
	EXIT /B
)
IF "%URL%"=="%URLOld%" (
	ECHO.Status: Valid URL. But same as before.
	TIMEOUT /T 2 >NUL 
	EXIT /B
)
IF "!URL!" EQU "" (
	ECHO.Status: The URL you provided is empty. Please try again.
	TIMEOUT /T 2 >NUL 
	EXIT /B
)
CALL :KillUnallowedCharacters URL URL

::: URLDepthLevel and Dissection
:::
::: http: // www . example . com / page . php?parameter=loremipsum
:::   0   |           1          |            2                    [URLDepthLevel]
:::       |   0  |    1    |  2  |  0   |          1             | [Dissection:Delimiter{.}]
SET URLDepthLevel=0
FOR /F "tokens=1,2,3,4,5,6,7,8,9 delims=/" %%A IN ("!URL!") DO (
  SET "URL0=%%A"
  IF DEFINED URL0 (
    SET "URL1=%%B"
    SET /A URLDepthLevel+=1
    IF DEFINED URL1 (
      SET "URL2=%%C"
      SET /A URLDepthLevel+=1
      IF DEFINED URL2 (
        SET "URL3=%%D"
        SET /A URLDepthLevel+=1
        IF DEFINED URL3 (
          SET "URL4=%%E"
          SET /A URLDepthLevel+=1
          IF DEFINED URL4 (
            SET "URL5=%%F"
            SET /A URLDepthLevel+=1
            IF DEFINED URL5 (
              SET "URL6=%%G"
              SET /A URLDepthLevel+=1
              IF DEFINED URL6 (
                SET "URL7=%%H"
                SET /A URLDepthLevel+=1
                IF DEFINED URL7 (
                  SET "URL8=%%I"
                  SET /A URLDepthLevel+=1
                )
              )
            )
          )
        )
      )
    )
  )
	REM ECHO.URL0=%%A
	REM ECHO.URL1=%%B
	REM ECHO.URL2=%%C
	REM ECHO.URL3=%%D
	REM ECHO.URL4=%%E
	REM ECHO.URL5=%%F
	REM ECHO.URL6=%%G
	REM ECHO.URL7=%%H
	REM ECHO.URL8=%%I
	REM ECHO.!URL8! !URLDepthLevel!
	REM ECHO.Domain: %%B
	REM ECHO.URL1: %%C
	REM ECHO.VideoID: %%D
	REM ECHO.VideoName: %%E
)
SET "URLHasHttpCount=0"
FOR %%A IN ("http" "https") DO (
  IF "!URL0!" EQU "%%~A:" (
      SET /A URLHasHttpCount+=1
      EXIT /B
  )
)
CALL :ResolveProblems
EXIT /B

:AnalyseInput
FOR /L %%A in (0,1,!URLDepthLevel!) DO (
  CALL :DissectURL URL%%A URL%%A . A
)
CALL :DissectionURLAnalysis
EXIT /B

:DissectURL
::: URLDepthLevel and Dissection
:::
::: http: // www . example . com / page . php?parameter=loremipsum
:::   0   |           1          |            2                    [URLDepthLevel]
:::       |   0  |    1    |  2  |  0   |          1             | [Dissection:Delimiter{.}]
SET "VarIn=%1"
SET "VarOut=%2"
SET "Delimiter=%3"
SET "CustomIdentifier=%4"
REM ECHO.DeBug: !VarIn! !VarOut! !%VarIn%! !%VarOut%! !Delimiter!
SET "!VarOut!DepthLevel!CustomIdentifier!=0"
FOR /F "tokens=1,2,3,4,5,6,7,8,9 delims=%Delimiter%" %%A IN ("!%VarIn%!!") DO (
  SET "!VarOut!0!CustomIdentifier!=%%A"
  IF DEFINED !VarOut!0!CustomIdentifier! (
    SET "!VarOut!1!CustomIdentifier!=%%B"
    SET /A !VarOut!DepthLevel!CustomIdentifier!+=1
    IF DEFINED !VarOut!1!CustomIdentifier! (
      SET "!VarOut!2!CustomIdentifier!=%%C"
      SET /A !VarOut!DepthLevel!CustomIdentifier!+=1
      IF DEFINED !VarOut!2!CustomIdentifier! (
        SET "!VarOut!3!CustomIdentifier!=%%D"
        SET /A !VarOut!DepthLevel!CustomIdentifier!+=1
        IF DEFINED !VarOut!3!CustomIdentifier! (
          SET "!VarOut!4!CustomIdentifier!=%%E"
          SET /A !VarOut!DepthLevel!CustomIdentifier!+=1
          IF DEFINED !VarOut!4!CustomIdentifier! (
            SET "!VarOut!5!CustomIdentifier!=%%F"
            SET /A !VarOut!DepthLevel!CustomIdentifier!+=1
            IF DEFINED !VarOut!5!CustomIdentifier! (
              SET "!VarOut!6!CustomIdentifier!=%%G"
              SET /A !VarOut!DepthLevel!CustomIdentifier!+=1
              IF DEFINED !VarOut!6!CustomIdentifier! (
                SET "!VarOut!7!CustomIdentifier!=%%H"
                SET /A !VarOut!DepthLevel!CustomIdentifier!+=1
                IF DEFINED !VarOut!7!CustomIdentifier! (
                  SET "!VarOut!8!CustomIdentifier!=%%I"
                  SET /A !VarOut!DepthLevel!CustomIdentifier!+=1
                )
              )
            )
          )
        )
      )
    )
  )
  REM ECHO.DeBug: !VarIn! !VarOut! !%VarIn%! !%VarOut%! !Delimiter!
  REM ECHO.%VarOut%1%CustomIdentifier% !%VarOut%1%CustomIdentifier%! !%VarOut%DepthLevel! !CustomIdentifier!
)
EXIT /B

:DissectionURLAnalysis
REM FOR /F "tokens=* delims=." %%A IN ("!URL1!!") DO (
REM  SET /A URL1AnalysisCounter+=1
REM )
IF !URLDepthLevel! EQU 2 (
  ECHO./^^!\ URL might be too short for Information.
  ECHO.The URL you provided was:
  ECHO.
  ECHO.       ^>^>^>!BuiltURL!^<^<^<
  ECHO.
  ECHO.Do you want to continue? [y/N]
  CHOICE /C YN /N >NUL
  IF NOT !ERRORLEVEL! EQU 1 (
	EXIT /B
  )
)
IF !URL1DepthLevelA! EQU 4 (
  SET "ServiceName=!URL11A!"
) ELSE IF !URL1DepthLevelA! EQU 3 (
  SET "ServiceName=!URL11A!"
) ELSE IF !URL1DepthLevelA! EQU 2 (
  SET "ServiceName=!URL10A!"
) ELSE (
  SET "ServiceName=!URL11A!"
)
IF !URLDepthLevel! EQU 3 (
  IF !URL1DepthLevelA! EQU 2 (
    IF !URL2DepthLevelA! EQU 1 (
      ECHO.URL Shortener detected^!
      SET "ServiceName=!URL10A!.!URL11A!"
    )
  )
)
EXIT /B

:KillUnallowedCharacters
SET "VarIn=%1"
SET "VarOut=%2"
SET "!VarIn!=!%VarIn%: =!"
SET "!VarIn!=!%VarIn%:&=^&!"
SET "!VarOut!=!%VarIn%!"
REM ECHO.DeBug: !VarIn! !VarOut! !%VarIn%! !%VarOut%!
EXIT /B

:ResolveProblems
ECHO.ResolveProblems: !URL!
IF /i "!URL0:~-2!"=="s:" (
  SET "URL0=https:"
  SET "URLHasHttpCount=1"
)
IF NOT DEFINED URL0 (
  SET "URL0=http:"
  SET "URLHasHttpCount=1"
)
IF NOT !URLHasHttpCount!==1 (
  SET "URL0=http:"
  SET "URLHasHttpCount=1"
)
IF !URLHttpWrongStandard!==1 (
  SET "URL0=https:"
)
IF !URLDepthLevel! EQU 1 (
  ECHO./^^!\ ERROR. Invalid URL.
  SET "URL="
  TIMEOUT /T 2 >NUL 
  EXIT /B
)
IF !URLDepthLevel! LSS 1 (
  ECHO./^^!\ ERROR. Invalid URL.
  SET "URL="
  TIMEOUT /T 2 >NUL 
  EXIT /B
)
ECHO.                 [TO]
CALL :BuildURL
ECHO.                 !BuiltURL!
EXIT /B

:BuildURL
SET "BuiltURL=!URL0!/"
SET /A URLDepthLevel2=%URLDepthLevel% - 1
FOR /L %%A IN (1,1,!URLDepthLevel2!) DO (
  SET "BuiltURL=!BuiltURL!/!URL%%A!"
)
SET "BuiltURL=!BuiltURL!!URL%URLDepthLevel%!/"
EXIT /B

:CalculateLineLength
EXIT /B

@end
WSH.Echo(WSH.CreateObject('htmlfile').parentWindow.clipboardData.getData('text'));
