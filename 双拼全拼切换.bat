@echo off
:: reference: https://zhuanlan.zhihu.com/p/142034339
set Mainkey=HKCU\SOFTWARE\Microsoft\InputMethod\Settings\CHS
for /f %%i in ('reg query %MainKey% /v "Enable Double Pinyin" ^| findstr /i "0x1"') do (set flg=%%i)
if not defined flg (
    reg add %MainKey% /v "Enable Double Pinyin" /t REG_DWORD /d 0x1 /f
    echo �Ѿ��л���˫ƴ
    (echo �Ѿ��л���˫ƴ
    echo 1����Զ��ر�)|msg %username% /time:1
) else (
    reg add %MainKey% /v "Enable Double Pinyin" /t REG_DWORD /d 0x0 /f
    (echo �Ѿ��л���ȫƴ
    echo 1����Զ��ر�)|msg %username% /time:1
)