chcp 65001
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
::到达当前路径
::cd /d "%~dp0"

:: 以管理员权限运行
echo run with administrator rights
:: 您当前使用的用户
echo your current user is %USERNAME%
:: 您当前的计算机名
echo your computer name is %COMPUTER%
@echo off
taskkill /F /IM telegram.exe
taskkill /F /IM ShadowBot.Shell.exe
if errorlevel 1 echo Failed to terminate Telegram process.

::设置延迟3秒关闭窗口
timeout /t 3