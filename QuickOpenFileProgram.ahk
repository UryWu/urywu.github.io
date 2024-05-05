#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.


SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode RegEx
SetTitleMatchMode 2

;热键标识符：^ = Ctrl, ! = alt, + = shift, # = windows , F1就是F1，< 左， > 右边的键
;按键重映射:https://wyagd001.github.io/zh-cn/docs/misc/Remap.htm#HookHotkeys
#!::CapsLock ; 这个根本无效
CapsLock::Enter
; $CapsLock::Enter 
^CapsLock::Send, {CtrlDown}{Enter}{CtrlUp}{CapsLock}
; LAlt & Capslock::SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off" : "On" ; 大小写转换设置
CapsLock & S::Backspace
CapsLock & D::Delete

full_command_line := DllCall("GetCommandLine", "str")

<!j::Send, {Down} ; 下 
<!l::Send, {Right} ; 右
<!h::Send, {Left} ; 左
<!k::Send, {Up} ; 上
<!u::Send, {PgUp} ; 上一页
<!d::Send, {PgDn} ; 下一页
<!b::Send, {Home} ;left alt+b 触发 Home
<!n::Send, {End} ;left alt+n 触发 End
>!j::Send, {ShiftDown}{Down}{ShiftUp} ; 下
>!l::Send, {ShiftDown}{Right}{ShiftUp} ; 右
>!h::Send, {ShiftDown}{Left}{ShiftUp} ; 左
>!k::Send, {ShiftDown}{Up}{ShiftUp} ; 上
>!u::Send, {ShiftDown}{PgUp}{ShiftUp} ; 选中下一页
>!d::Send, {ShiftDown}{PgDn}{ShiftUp} ; 选中上一页
>!b::Send, {ShiftDown}{Home}{ShiftUp} ;right alt+b 触发 shift+Home
>!n::Send, {ShiftDown}{End}{ShiftUp} ;right alt+n 触发 shift+End
CapsLock & h::Send, {CtrlDown}{Left}{CtrlUp} ;CapsLock + h 触发 ctrl+左
CapsLock & l::Send, {CtrlDown}{Right}{CtrlUp} ;CapsLock + l 触发 ctrl+右
CapsLock & j::Send, {CtrlDown}{ShiftDown}{Left}{ShiftUp}{CtrlUp}
CapsLock & k::Send, {CtrlDown}{ShiftDown}{Right}{ShiftUp}{CtrlUp}
>^>!h::Send, {CtrlDown}{ShiftDown}{Left}{ShiftUp}{CtrlUp} ;right ctrl + right alt + h 触发 ctrl+shift+左
>^>!l::Send, {CtrlDown}{ShiftDown}{Right}{ShiftUp}{CtrlUp} ;right ctrl + right alt + l 触发 ctrl+shift+右
<!,::Send, {Volume_Down} ; 调低音量
<!.::Send, {Volume_Up} ; 升高音量
CapsLock & t::
FormatTime, CurrentDateTime,, yyyy年MM月dd日 ddd HH时mm分ss秒
SendInput %CurrentDateTime%
return
CapsLock & g::send, 👍
CapsLock & [::Run, %ComSpec% /c shutdown -h ; 睡眠
#b::Send {MButton}
<![::Send {XButton1}
<!]::Send {XButton2}

; Reload script , 保存并重新加载脚本   
F9::
{
    Send, {CtrlDown}s{CtrlUp}
    Reload
    return
}

<^,::Send, {-} ; 用于打字时查看上一页
<^.::Send, {=} ; 用于打字时查看下一页
; 多个组合键，好像无法用，带capslock的也失效
; CapsLock & LShift::
;     While (A_TimeSinceThisHotkey < 500) {
;         if (GetKeyState("h"))
;             Send, {CtrlDown}{ShiftDown}{Left}{ShiftUp}{CtrlUp}
;         else if (GetKeyState("l"))
;             Send, {CtrlDown}{ShiftDown}{Right}{ShiftUp}{CtrlUp}
;         return
;     }

;全局变量放外面必死，只能在函数里面用，见：https://www.cnblogs.com/CyLee/p/8879824.html
;快捷键 windows+n 用记事本打开选中文件，
;%file_path%两边需要加上`"来把路径包括到双引号里面，否则路径含空格的话无法打开，run命令会spilit空格并打开分割后的多个文件。
#n::
{
    file_path := Explorer_GetSelection(hwnd)
    run, C:\Windows\Notepad.exe `"%file_path%`"
    ;MsgBox %file_path%  ;弹窗输出当前文件的路径
    return
}

;快捷键 windows+e 用vscode打开选中文件
#e::
{
    file_path := Explorer_GetSelection(hwnd)

    run, E:\Microsoft VS Code1.51.1.0\_\Code.exe `"%file_path%`"
    ;MsgBox %file_path%  ;弹窗输出当前文件的路径
    return
}

;快捷键 windows+y 用typora打开选中文件
#y::
{
    file_path := Explorer_GetSelection(hwnd)
    run, E:\typora_x64_1.2.4\Typora\Typora.exe `"%file_path%`"
    ;MsgBox %file_path%  ;弹窗输出当前文件的路径
    return
}

;快捷键 windows+a 用potplayer播放器打开选中文件
#a::
{
    file_path := Explorer_GetSelection(hwnd)
    run, G:\softwares\PotPlayer\PotPlayerMini64.exe `"%file_path%`"
    ;MsgBox %file_path%  ;弹窗输出当前文件的路径
    return
}

;快捷键 ctrl+alt+c 用chrome打开选中文件
<^<!c::
{
    file_path := Explorer_GetSelection(hwnd)
    run, C:\Program Files\Google\Chrome\Application\chrome.exe `"%file_path%`"
    ;MsgBox %file_path%  ;弹窗输出当前文件的路径
    return
}

;快捷键 windows+c 复制文件绝对路径
;reference: https://blog.csdn.net/liuyukuan/article/details/53399286 https://itpcb.com/a/1538834
#c::
{
    file_path := Explorer_GetSelection(hwnd)
    clipboard := file_path
    return
}
Explorer_GetSelection(hwnd="")   
{  
    /* 获取和报告活动窗口的唯一 ID(HWND). MsgBox % "The active window's ID is " WinExist("A")
    WinExist("A") 就是获取所有活动窗口的进程id
    这里如果你直接往Explorer_GetSelection传句柄他就不用WinExist查进程了,?:三目表达式
    */
    WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")  ;
    WinGetClass class, ahk_id %hwnd%  
    if (process != "explorer.exe")  
        return  
    if (class ~= "Progman|WorkerW") { ;ahk_class WorkerW是桌面的
            ControlGet, files, List, Selected Col1, SysListView321, ahk_class %class%  
            Loop, Parse, files, `n, `r ; `r是回车：回到本行开头
                ToReturn .= A_Desktop "\" A_LoopField "`n" ;A_LoopField包含了InputVar中当前子字符串(片段) 的内容
    } else if (class ~= "(Cabinet|Explore)WClass") { ;CabinetWClass是资源管理器的ahk_class
        for window in ComObjCreate("Shell.Application").Windows ;遍历当前资源管理器中打开的窗口
        {
            try{
                if (window.hwnd==hwnd)  ;在多个窗口中取定位符合前面hwnd的那个窗口，应该是选中的项目
                    sel := window.Document.SelectedItems  
            }catch e {
                continue
            }
        }
        for item in sel  
            ToReturn .= item.path "`n"  
    }  
    return Trim(ToReturn,"`n")  
}

;快捷键 windows+f 打开有道词典，如果此程序已经运行则置顶主界面，主界面置顶时则最小化。
#f::open_and_hide_program("E:\Dict\Dict\YoudaoDict.exe", "YoudaoDict.exe", "YodaoMainWndClass", "网易有道词典")
open_and_hide_program(path, program, win_class, win_title)
{
    ; 失败
    /*
    DetectHiddenWindows,on ; 隐藏的窗口也一起检测
    SetTitleMatchMode,2
    WinGet, active_id, ID, %win_title% ; 这里获取的activa_id是获取窗口的唯一ID号，也称窗口句柄hwnd
	WinGet, MinMaxStatus, MinMax, %win_title% ; 这个语句还是无法获取窗口的状态
    if (MinMaxStatus=0)
        MsgBox 无法获取窗口的状态 %MinMaxStatus%   %active_id%
    
	; -1: 窗口处于最小化状态 (使用 WinRestore 可以让它还原). 
	; 1: 窗口处于最大化状态 (使用 WinRestore 可以让它还原).
	; 0: 窗口既不处于最小化状态也不处于最大化状态.
	*/
    
    ; a := WinExist("%program%")
    ; hwnd := WinActive(win_title) ; 当窗口置顶时，返回它的句柄hwnd，不置顶则返回0x0，win_title是窗口标题
    hwnd := WinActive("ahk_exe" program) ; 当窗口置顶时，返回它的句柄hwnd，不置顶则返回0x0
    ; MsgBox, %a% %hwnd% ; 这个WinExist函数永远返回0x0，用它来判断根本不靠谱。函数前放!可取反
    ; MsgBox %win_title%

    ; if if_exist_process(program)
    if WinExist("ahk_exe" program) ; 窗口是否存在，不考虑托盘程序。
    {
        if (hwnd = 0)
        {
            
            WinActivate, ahk_exe %program% ; 如果存在窗口则把它置顶，如果窗口是托盘程序则无法激活
        }
        else
        {
            ; WinMinimize, ahk_exe %program% ; 如果聚焦于此窗口则把它最小化，无效？
            WinMinimize, ahk_class %win_class% ; 最小化，比ahk_exe稳定
            ; WinMinimize, %win_title% ; 如果聚焦于此窗口则把它最小化，使用窗口标题比ahk_exe稳定
            ; PostMessage, 0x0112, 0xF020,,, %win_title%, ; 0x112 = WM_SYSCOMMAND, 0xF020 = SC_MINIMIZE, 最小化，特殊类型的窗口无法正确响应
        }
    }
    else
    {
        run, %path%, ,min ; 以最小化窗口启动
    }
    return

    ; WinHide ahk_exe %program%
    ; WinHide ahk_exe %program% ; 两次隐藏才能将它藏入托盘菜单
    ; WinMinimize, 网易有道词典 ; 可以直接写窗口中文名字
}

/* qq已经有ctrl+alt+z提取消息，此程序做参考用。
;快捷键 windows+q 打开TIM，如果此程序已经运行则置顶主界面，主界面置顶时则最小化。
#q::open_and_hide_tim("E:\TIM\Bin\TIM.exe", "TIM.exe", "TXGuiFoundation", "")
open_and_hide_tim(path, program, win_class, win_title)
{
    hwnd := WinActive("ahk_exe" program) ; 当窗口置顶时，返回它的句柄hwnd，不置顶则返回0x0
    ; 这里加入WinExist的判断似乎也没有加速激活窗口
    if if_exist_process(program)
    {
        if (hwnd = 0)
        {
            TrayIcon_Button(program, "L", 1) ; 双击此程序的托盘图标，L后面,1就是双击。不加1单击时比WinActivate慢
            ; WinActivate, ahk_exe %program% ; 如果存在窗口则把它置顶
        }
        else
        {
            ; WinMinimize, ahk_class %win_class% ; 最小化，比ahk_exe稳定
            WinMinimize, ahk_exe %program% ; 有时能用有时不能用
         }
    }
    else
    {
        run, %path%, ,min ; 以最小化窗口启动
    }
    return
}
*/

; 这个外部引入的文件我放在此脚本同目录
#Include TrayIcon.ahk
;快捷键 alt+l 打开clash/v2rayN，如果此程序已经运行则打开主界面，主界面置顶时则隐藏到系统托盘。
>^;::open_and_hide_clash("G:\softwares\v2rayN-With-Core\v2rayN.exe", "v2rayN.exe")
open_and_hide_clash(path, program)
{
    WinActivate, 屏幕识图 ;
    if WinExist("v2rayN")
    {
        run, %path%, ,

    }
    else if if_exist_process(program) ; 寻找此进程，其实用WinExist来写会简单很多。
    {
        ; word_array := StrSplit(program, A_Space, ".")  ; 分割空格，忽略句点。
        ; MsgBox %word_array1%
        
        ; StringSplit, word_array, program, ".",  ; 对program用"."分割后放入word_array
        ; MsgBox, The 1th word is %word_array1%
        ; WinShow, %word_array1%

        ; 右键点击托盘程序，打开菜单，参考：https://blog.csdn.net/liuyukuan/article/details/54143002
        TrayIcon_Button(program, "R")
    }
    else
        run, %path%, ,min
}
if_exist_process(program) ; 搜索所有进程，所有进程放入列表 l
{
    ; 当前存在的进程搜索参考：https://ahkcn.github.io/docs/commands/Process.htm
    ; 示例 #4: 使用 DllCall 获取正在运行的进程列表然后显示在 MsgBox.

    d := "  |  "  ; 字符串分隔符
    s := 4096  ; 缓存和数组的大小 (4 KB)

    Process, Exist  ; 设置 ErrorLevel 为这个正在运行脚本的 PID
    ; 使用 PROCESS_QUERY_INFORMATION (0x0400) 获取此脚本的句柄
    h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", ErrorLevel, "Ptr")
    ; 打开此进程的可调整的访问令牌 (TOKEN_ADJUST_PRIVILEGES = 32)
    DllCall("Advapi32.dll\OpenProcessToken", "Ptr", h, "UInt", 32, "PtrP", t)
    VarSetCapacity(ti, 16, 0)  ; 特权结构
    NumPut(1, ti, 0, "UInt")  ; 特权数组中的一个条目...
    ; 获取调试特权的本地唯一标识符:
    DllCall("Advapi32.dll\LookupPrivilegeValue", "Ptr", 0, "Str", "SeDebugPrivilege", "Int64P", luid)
    NumPut(luid, ti, 4, "Int64")
    NumPut(2, ti, 12, "UInt")  ; 启用这个特权: SE_PRIVILEGE_ENABLED = 2
    ; 使用新的访问令牌更新此进程的特权:
    r := DllCall("Advapi32.dll\AdjustTokenPrivileges", "Ptr", t, "Int", false, "Ptr", &ti, "UInt", 0, "Ptr", 0, "Ptr", 0)
    DllCall("CloseHandle", "Ptr", t)  ; 关闭此访问令牌句柄以节约内存
    DllCall("CloseHandle", "Ptr", h)  ; 关闭此进程句柄以节约内存

    hModule := DllCall("LoadLibrary", "Str", "Psapi.dll")  ; 通过预加载来提升性能
    s := VarSetCapacity(a, s)  ; 接收进程列表标识符的数组:
    c := 0  ; 用于进程标识符的计数器
    DllCall("Psapi.dll\EnumProcesses", "Ptr", &a, "UInt", s, "UIntP", r)

    program_exist_flag := 0 ; 检测程序进程是否存在标志位
    Loop, % r // 4  ; 把数组解析为 DWORD (32 位) 的标识符:
    {
    id := NumGet(a, A_Index * 4, "UInt")
    ; 打开进程: PROCESS_VM_READ (0x0010) | PROCESS_QUERY_INFORMATION (0x0400)
    h := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", id, "Ptr")
    if !h
        continue
    VarSetCapacity(n, s, 0)  ; 接收模块基础名称的缓存:
    e := DllCall("Psapi.dll\GetModuleBaseName", "Ptr", h, "Ptr", 0, "Str", n, "UInt", A_IsUnicode ? s//2 : s)
    if !e    ; 用于 64 位进程在 32 位模式时的回退方法:
        if e := DllCall("Psapi.dll\GetProcessImageFileName", "Ptr", h, "Str", n, "UInt", A_IsUnicode ? s//2 : s)
            SplitPath n, n
    DllCall("CloseHandle", "Ptr", h)  ; 关闭进程句柄以节约内存

    if (n && e)  ; 如果映像不是空的, 则添加到列表:
        l .= n . d, c++
        if (program = n)
        {
            program_exist_flag := 1
            ; MsgBox %n% ; 找到此程序并展示
        }
            
    }
    DllCall("FreeLibrary", "Ptr", hModule)  ; 卸载库来释放内存
    Sort, l, C  ; 取消注释这行来按字母顺序对列表进行排序
    ; MsgBox, 0, %c% Processes, %l% ; 用窗口显示当前存在所有进程“  |  ”符号分隔开
        
    return program_exist_flag
}


;参考：https://ahkcn.github.io/docs/Hotstrings.htm#Options 热字符串
;#Hotstring EndChars ' 表示只要'作为休止符 :'o:里要把你的休止符放进去(不放好像没事)，里面的o表示不输出休止符，如果放*进去就是不需要休止符
;这里休止符有两个，[和tab键（`t）
#Hotstring EndChars `t[
; 深度学习python
:o:ac::activate{Space}
:o:de::deactivate
:o:tf::tensorflow
:o:acf::activate tensorflow-gpu
:o:acy::activate yolov8
:o:jup::jupyter lab
:o:tb::tensorboard --logdir=training:
:o:py::python{Space}
:o:env::conda env list
:o:pyv::python -V
:o:pil::pip list{Space}
:o:pilf::pip list | findstr{Space}
:o:pipi::pip install{Space}
:o:pipu::pip uninstall{Space}
:o:nv::nvidia-smi
:o:env::conda env list
:o:isat::ISAT_with_segment_anything
:o:find::| findstr{Space}
:o:pr::punctuation restoration:
:o:bd::不修改原文内容，为下段话增加标点符号，分出自然段：
:o:vir::virtualenv{Space}
:o:venv::venv\Scripts\activate
:o:venvr::VENV_DIR\Scripts\activate
:o:pipd::pipdeptree -p{Space}
:o:cd::cd /d{Space}
:o:tra::python yolo_train.py
:o:pro::
prompt =
(
prompt:
``````
)
negative_prompt =
(
negative prompt:
``````
)
negative_prompt_text =
(
asian, chinese, japanese,abs,formal wear, (red eyes),(worst quality:2), grayscale, monochrome, flat color, flat background, dull composition, low quality, low detail,normal quality, high quality, traditional art
)
SendInput {Text}%prompt%
Sleep, 200
Send, {enter}{CtrlDown}{down}{down}{CtrlUp}
Sleep, 200
SendInput {Text}prompt
Sleep, 200
Send, {enter}
SendInput {Text}%negative_prompt%
Sleep, 200
Send, {enter}
SendInput {Text}%negative_prompt_text%
Sleep, 1000
Send, {CtrlDown}{up}{up}{up}{up}{CtrlUp}
return

; 启动程序
:o:pi::print(){Left}
:o:(::({CtrlDown}{Right}{CtrlUp}){Right}
:o:vsq::"E:\Microsoft VS Code1.51.1.0\_\Code.exe" .\scripts\QuickOpenFileProgram.ahk && exit
:o:js::javascript
:o:ahk::autohotkey
:o:exp::explorer{space}
:o:vs::Visual Studio
:o:vsc::"E:\Microsoft VS Code1.51.1.0\_\Code.exe"{Space}
:o:vs1::"C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe"
:o:vs2::Visual Studio 2022
:o:ty::"E:\Typora\Typora.exe"{Space}
:o:ch::"C:\Program Files\Google\Chrome\Application\chrome.exe"{Space}
:o:pha::"E:\phantomjs-2.1.1-windows\bin\phantomjs.exe"
:o:sni::Snipaste.exe
:o:tr::{^}天若OCR文字识别.exe$ ; 这里^是异或符号，无法作为字符输出。用括号括住即可。见：https://www.dazhuanlan.com/zlichao/topics/1018858
:o:umi::case:Umi-OCR.exe ; OCR软件
:o:te::telegram.exe
:o:bin::..\bin.bat
:o:wn::wn.run/
:o:qu::.\scripts\双拼全拼切换.bat && exit
:o:toy::PowerToys
:o:lo::localsend_app.exe
:o:pow::powershell

; 打开文件
:o:acc::accounts.7z

; 字符替换
:o:bc:://`t<-`t代码报错行 
:o:134::1345150167
:o:1345::1345150167
:o:13451::1345150167
:o:134@::1345150167@qq.com
:o:24::2024-
:o:ad::administrator
:o:mima::123456(Aa)
:o:u0::uart 0
:o:u1::uart 1
:o:lo::load xmodem1k
:o:uw::UryWu
:o:git::github
:o:sp::springboot
:o:ay::anonymous
:o:uijm::视频时间戳：
:o:ks::⠀⠀⠀
:o:.::ext:
:o:me::message3
:o:m:: .md
:o:proqt::projects_Qt
:o:kz::扩写以下句子，字数限制在30个字以内，并且超过20个字：

; 网站
:o:sear:: (site:w3school.com.cn OR site:developer.mozilla.org OR site:runoob.com)
:o:mg::magnet:?xt=urn:btih:
:o:text::`{#}:~:text=
:o:csdn:: site:blog.csdn.net/qq_25799253
:o:si::site:
:o:zhi::zhipin.com
:o:zhao::zhaopin.com
:o:ury@::urywu@qq.com

; everything
:o:.d:: ext:docx
:o:.e:: ext:exe
:o:.t:: ext:txt
:o:.l:: ext:lnk

; obsidian
:o:zo::zotero
:o:zoi::zotero integration
:o:zop::zotero plugin
:o:ob::obsidian
:o:qo::Quiet Outline
:o:nh::Number Headings
:o:fi::file:( .md){Left}{Left}{Left}{Left}{Left}
:o:li::line:(){Left}

; 其他
:o:ex:: && exit
; :o:vpn::set HTTP_PROXY=http://192.168.81.105:7890
; :o:vpns::set HTTPS_PROXY=http://192.168.81.105:7890
:o:vpn::  ; 函数热字串 https://wyagd001.github.io/zh-cn/docs/Hotstrings.htm#Function
    get_system_ip4() {
        
        ; Addresses := SysGetIPAddresses() ; 这个系统函数无法用。
        ipv4 := getIPv4()
        send set HTTP_PROXY=http://%ipv4%:10809
    }
:o:vpns::
    get_system_ip4_() {
        ipv4 := getIPv4()
        send set HTTPS_PROXY=https://%ipv4%:10809
    }
:o:vpnp::
    get_system_ip4_for_pip() {
        ipv4 := getIPv4()
        send set HTTPS_PROXY=http://%ipv4%:10809
    }

; cs生化竞技
;;一队中最大的激光地雷数
:o:mine99::zp_ltm_teammax 99
:o:mineh::zp_ltm_health 100
; 岗哨炮命令：http://sk00.com/dispbbs.asp?BoardID=15&ID=1832096&replyID=&skin=1
:o:senm::bind j sentry_menu
:o:senb::bind k sentry_build
:o:sen0::sentry_cost1 0 ; 建立岗哨跑所需要的钱
:o:sen::
(
bind j sentry_menu
bind k sentry_build
sentry_cost1 0
sentry_max 50

)
return

; 作用：用WshShell执行cmd命令并获取结果。
; https://www.autohotkey.com/boards/viewtopic.php?t=48132
cmdReturn(command){
    ; WshShell 对象: http://msdn.microsoft.com/en-us/library/aew9yb99
    shell := ComObjCreate("WScript.Shell")
    ; 通过 cmd.exe 执行单条命令
    exec := shell.Exec(ComSpec " /C " command)
    ; 读取并返回命令的输出
    return exec.StdOut.ReadAll()
}

; 作用：调用cmd命令获取ipv4
getIPv4(){
    ; 直接分组，从无线wlan这里拆分，正则表达式时间复杂度太高。
    str := cmdReturn("ipconfig")


    ; delimiter := "无线局域网适配器 WLAN:"  ; 系统显示语言为简体中文
    delimiter := "Wireless LAN adapter WLAN:" ; 系统显示语言为英语（美国）
    result := StrSplit(str, delimiter)

    string := result[2] ; 获取除去分隔符后的第二部分。
    ; MsgBox, % string 
    ; string := "ndPrint(regex, 23.135.2.255); "
    pattern := "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b" ;  正则表达式模式用于匹配IPv4地址

    if (RegExMatch(string, pattern, match))
        return match
    else
        MsgBox, Not found WLAN IPv4
}

/* C++快捷创建代码模板
*/
;; 输出语句
:o:co::
cpp_cout = 
(
cout <<  << endl;
)
SendInput {Text}%cpp_cout%
send, {left}{left}{left}{left}{left}{left}{left}{left}{left}
return

;; main函数 法1 退格不好用
; :o:main::
; (
; #include <iostream>
; using namespace std;

; int main(){

;     return 0;
; `b}
; )
; Send, {Up}   ; 按下向上键.
; return

;; main函数 法2 可跳转光标
:o:main::
cpp_main_complate_1 =
(
#include <iostream>
#include <string>
using namespace std;

int main(){

    return 0;
`b}
)
SendInput {Text}%cpp_main_complate_1%
send, {up}{up}{Tab}
return

;; for函数i 可跳转光标
:o:fori::
cpp_fori_complate_1 =
(
for(int i = 0;i < n;++i){
`b
)
SendInput {Text}%cpp_fori_complate_1%
send, {Tab}
return
; `b就是tab键

;; for函数j 可跳转光标
:o:forj::
cpp_forj_complate_1 =
(
for(int j = 0;j < m;++j){
`b
)
SendInput {Text}%cpp_forj_complate_1%
send, {Tab}
return
; `b就是tab键

;; for函数打印 可跳转光标
:o:forp::
cpp_forp_complate_1 =
(
for(int i = 0;i < n;++i){
cout << arr[i] << " ";
)
SendInput {Text}%cpp_forp_complate_1%
send, {down}{down}{enter}
SendInput {Text}`bcout << endl;`r
return
; `b就是tab键

; 代码注释
:o:/::/*  */{Left}{Left}{Left}

; 输出
:o:op::output:

;; typora bug信息模板
:o:bug::
typora_bug_complate =
(
#### bug:
**description:**

When execute code:


Exception output:


**solution:**

)
SendInput {Text}%typora_bug_complate%
send, {up}{up}{up}{up}{End}
return

; 模拟点击鼠标右键+w+上上上上+Enter来新建文本文档
; reference:https://superuser.com/questions/133175/is-there-a-shortcut-for-creating-a-new-file
>^t:: ;If Right Ctrl+t is pressed in Windows Explorer
{
    ; OutputText:=""
	; WinGet, OutWindowID, id, A ;获取当前聚焦的窗口的id(在ahk资源中的窗口句柄),OutWindowID变量用于接收id,A中的值是空的。
	; ; MsgBox, a:%A%  OutWindowID:%OutWindowID%
    ; WinGetClass, OutClass, %OutWindowID% ;获取此窗口的类名
    ; ;~ MsgBox, %OutClass%

	; ExploreWClass是桌面，写 WorkerW 更好，
	if WinActive("ahk_class WorkerW")
    {
        Send {RButton} ;Menu
        Sleep, 200
        Send w ;New Text Document
        Sleep, 200
        Send {Up}{Up}{Up}{Up}{NumpadEnter} ;select Text Document
        Return
    } ;资源管理器窗口的类名就是CabinetWClass
	else if WinActive("ahk_class CabinetWClass")
    {
        Send {RButton} ;Menu
        Sleep, 200
        Send w ;New Text Document
        Send w ;New Text Document
        Send {Enter} ;
        Sleep, 200
        Send {Up}{Up}{Up}{Up}{NumpadEnter} ;select Text Document
        Return
    }

}

/*
作者：sunwind1576157
日期：2019年12月8日
最新版地址：https://blog.csdn.net/liuyukuan/article/details/103413873
热键：windows+tA
功能：在当前目录，进入到DOS命令行界面
原理：利用Explorer支持的热键,利用TC支持的内部命令
*/
^!t:: ; 不能用的时候点进explorer地址栏然后windows+t之后就能正常用了
{
    OutputText:=""
	WinGet, OutWindowID, id, A ;获取当前聚焦的窗口的id(在ahk资源中的窗口句柄),OutWindowID变量用于接收id,A中的值是空的。
	; MsgBox, a:%A%  OutWindowID:%OutWindowID%
    WinGetClass, OutClass, %OutWindowID% ;获取此窗口的类名
    ;~ MsgBox, %OutClass%

	if (OutClass in "WorkerW,CabinetWClass") ;资源管理器窗口的类名就是CabinetWClass，ExploreWClass是桌面
	{

		send ^l ;键盘输入ctrl+l，就是选中资源管理器的地址栏

        ; 法一：
		/* controlclick,Edit1,a ;Edit1是上面获取的窗口的ClassNN(控件的类名和实例编号) 或控件的文本, 它们都可以通过Window Spy获取，详解见官网
		controlsettext,Edit1,cmd,a ;controlsettext用于改变控件的文本。在资源管理器的地址栏输入cmd，最后的这个a没有什么意义，是确定控件的其它条件
		send {enter} ;按下回车，打开cmd窗口。原来还可以这样进cmd
        */

        ;; 法二：C盘之外的盘无法跳转路径
        ; ControlGetText, path, Edit1, a ; 用path获取资源管理器的地址栏地址
        ; Run, %ComSpec% /c cd `"%path%`" && cmd /k color 2e && pause

        /* 法三：用run命令可以调整颜色，输入更多命令。但是手动调用剪贴板有时失效，无法取得剪贴板内容。
        所以用ControlGetText来获取资源管理器的地址栏地址。另外需要用cmd /k才能转换磁盘，然后后面就无法
        往里面嵌套命令了，非常可惜。只能模拟键盘来输入命令。
        */
        ;; send ^c ; 剪贴板不好用，间时失效
        ControlGetText, path, Edit1, a ; 用path获取资源管理器的地址栏地址
        ;; MsgBox, %path%

        ;; 进入c盘之外的磁盘，需要先转换磁盘。
        disk := SubStr(path, 1, 1) ; SubStr(原始字符串, 截取的起点从1开始 [, 截取的长度])
        ;; MsgBox, %disk%
        Run, %ComSpec% /c cmd /k `"%disk%:`" 
        sleep, 1000
        send cd{space}`"%path%`" && color 2e && title 保护视力专用 && cls{enter} 
        ;管理员身份打开cmd，进入桌面的Shortcuts目录，最后这个cmd /k就是再执行一次命令color 2e设置窗口背景绿色。
        ;最后这个cmd就是再进入一次cmd保持当前路径，因为这个run命令是像bat一样执行完退出。但是失败闪退


    } else if (OutClass = "TTOTAL_CMD") ; 懂了，这个TTOTAL_CMD应该是total command的文件浏览器的类名
	{
		PostMessage 1075,511,0,,ahk_class TTOTAL_CMD 
        ;读懂这个命令需要用spy++来监听软件窗口通信，但是现在的软件都有反破解意识，很难截取。
	}else
    {
        Run, %ComSpec% /c cd C:\Users\UryWu\Desktop\Shortcuts && cmd /k color 2e 
        ;管理员身份打开cmd，进入桌面的Shortcuts目录，最后这个cmd /k就是再执行一次命令color 2e设置窗口背景绿色。
        ;最后这个cmd就是再进入一次cmd保持当前路径，因为这个run命令是像bat一样执行完退出。但是失败闪退
    }
    
    return
}
#t::
{
    Run, %ComSpec% /c cd C:\Users\UryWu\Desktop\Shortcuts && cmd /k "color 71 && activate tensorflow-gpu" 
    ;管理员身份打开cmd，最后这个cmd /k就是再进入一次cmd保持当前路径，因为这个run命令是像bat一样执行完退出。
    ;然后这个cmd /k后面用引号括起来是为了在cmd /k里执行多命令。

    ;不执行activate tensorflow-gpu指令
    return
}


; 功能：隐藏桌面所有图标
; 热键：win+q
#q::
HideOrShowDesktopIcons()
return
HideOrShowDesktopIcons()
{
	ControlGet, class, Hwnd,, SysListView321, ahk_class Progman
	If class =
		ControlGet, class, Hwnd,, SysListView321, ahk_class WorkerW
 
	If DllCall("IsWindowVisible", UInt,class)
		WinHide, ahk_id %class%
	Else
		WinShow, ahk_id %class%
}

; 自动点击tim的屏幕识图中的复制按钮，然后关闭此窗口
>^.::
{	
	MouseGetPos, x, y
	WinActivate, 屏幕识图 ;有的时候虽然有屏幕识图窗口但是不会激活它，直接主动激活
	if WinExist("屏幕识图")
		WinActivate, 屏幕识图
	if WinActive("屏幕识图")
	{
		Sleep, 100
		Send, #{up}
		Sleep, 100
		MouseClick, left, 1832, 1004, 1, 0  ;点击复制内容
		;~ Sleep, 100
		;~ MsgBox, %Clipboard%
		FileAppend, %Clipboard%, C:\Users\UryWu\Desktop\Clipboard_log.txt
		SetControlDelay -1
		MouseClick, left, 1909, 23, 1, 0  ;点击关闭比键盘的方法更安全，不会关闭其它的窗口，但是鼠标也不要乱动。
		;~ Send, !{F4}!{F4}  ;第一次只关闭"复制成功",第二次才关闭识别的窗口.鼠标不要乱动，否则会关闭背景的程序。
		;~ WinKill, "屏幕识图"  ;还是关闭失败了
		;~ WinClose, "屏幕识图"  ;还是关闭失败了
	}
	;~ MouseMove, %x%, %y%, 0
	Sleep, 50
	MouseMove, %x%, %y%, 0
    return
}

;;这种#IfWinActive必须放在脚本的最后面，否则它下面的其它非#语句无效
; 使用条件：在Typora中
; 功能：快捷设置字体颜色，Typora自带快捷键ctrl+\则取消光标所在行的所有样式。
; SendInput {Text} 解决中文输入法问题
#IfWinActive ahk_exe Typora.exe
{
    ; 热键：Ctrl+Alt+O 橙色
    ^!o::addFontColor("orange")

    ; 热键：Ctrl+Alt+R 红色
    ^!r::addFontColor("red")
    
    ; 热键：Ctrl+Alt+B 浅蓝色
    ^!b::addFontColor("cornflowerblue")

    ; 热键：Ctrl+Alt+G 绿色
    ^!g::addFontColor("green")
    return
}

; 快捷增加字体颜色
addFontColor(color){
    clipboard := "" ; 清空剪切板
    Send {ctrl down}c{ctrl up} ; 复制
    SendInput {TEXT}<font color='%color%'> ;输出字符串
    SendInput {ctrl down}v{ctrl up} ; 粘贴
    If(clipboard = ""){
        SendInput {TEXT}</ ; Typora中自动补全标签
    }else{
        SendInput {TEXT}</ ; Typora中自动补全标签
    }
    return
}

#IfWinActive ahk_exe Code.exe
Ctrl & Space::ControlSend, , ^{Space}, ahk_exe Code.exe
/*
代码做了如下事情:
1.在Visual Studio Code 中按下Ctrl+Space 之后
2.接管Ctrl + Space, 不会触发微软拼音的中英文切换了
3.向Visual Studio Code 发送模拟按键Ctrl + Space, 触发补全 
作者：Jon-io https://www.bilibili.com/read/cv5012438/ 出处：bilibili
*/ 

; 容易导致alt+1、alt+2、alt+3word设置标题字体失效
; #IfWinActive ahk_exe WINWORD.EXE
; {
;     ; RAlt::ControlSend, , >!, ahk_exe WINWORD.EXE
;     ; 在word中接管右alt，不会触发菜单键。没用？只好如下再重复设置热键：

;     >!b::Send, {ShiftDown}{Home}{ShiftUp} ;right alt+b 触发 shift+Home
;     >!n::Send, {ShiftDown}{End}{ShiftUp} ;right alt+n 触发 shift+End

;     return
; }

 
; #IfWinActive ahk_exe chrome.exe
; LControl::ControlSend, , <^, ahk_exe chrome.exe

#IfWinActive ahk_class Chrome_WidgetWin_0  ; 让迅雷在线云播视频窗也有qe快进退功能 
{
    ; 热键：
    q::Send, {Left} ; 快退5s
    e::Send, {Right} ; 快进5s

    !<q::control_speed_for_thunder(0.5倍速) ; 0.5倍速
    !<1::control_speed_for_thunder(1倍速) ; 1倍速
    !<2::control_speed_for_thunder(1.25倍速) 
    !<3::control_speed_for_thunder(1.5倍速)

    return
}

control_speed_for_thunder(flag){ 
    MouseGetPos, origin_x, origin_y ; 获取鼠标原始位置
    WinGetPos, X, Y, W, H, A
    if(flag = 0.5倍速){
        MouseMove, W-135, H-35 ; 移动鼠标到进度条上面一点点的位置，显示速度调节栏。
        sleep, 1000 ; 等一秒，时间菜单栏未出现的时候直接去点就没用，无法弹出调节速度菜单。
        MouseClick, left, , , 2, 0  ; 点击两下，有时候它不弹出上拉菜单。
        MouseMove, 1, 1, 50, R  ; 动几下，弹出上拉菜单。
        MouseMove, 1, 1, 50, R
        MouseClick, left, W-132, H-62, 1, 0 ; 点击设置速度0.5
        
    }else if(flag = 1倍速){
        MouseMove, W-135, H-35 ; 移动鼠标到进度条上面一点点的位置，显示速度调节栏
        sleep, 1000 ; 等一秒，时间菜单栏未出现的时候直接去点就没用，无法弹出调节速度菜单。
        MouseClick, left, , , 2, 0  ; 点击两下，有时候它不弹出上拉菜单
        MouseMove, 1, 1, 50, R  ; 动几下，弹出上拉菜单
        MouseMove, 1, 1, 50, R
        MouseClick, left, W-132, H-117, 1, 0 ; 点击设置速度正常
    }else if(flag = 1.25倍速){
        MouseMove, W-135, H-35 ; 移动鼠标到进度条上面一点点的位置，显示速度调节栏。
        sleep, 1000 ; 等一秒，时间菜单栏未出现的时候直接去点就没用，无法弹出调节速度菜单。
        MouseClick, left, , , 2, 0  ; 点击两下，有时候它不弹出上拉菜单。
        MouseMove, 1, 1, 50, R  ; 动几下，弹出上拉菜单。
        MouseMove, 1, 1, 50, R
        MouseClick, left, W-132, H-155, 1, 0 ; 点击设置速度1.25
    }else if(flag = 1.5倍速){
        MouseMove, W-135, H-35 ; 移动鼠标到进度条上面一点点的位置，显示速度调节栏
        sleep, 1000 ; 等一秒，时间菜单栏未出现的时候直接去点就没用，无法弹出调节速度菜单。
        MouseClick, left, , , 2, 0  ; 点击两下，有时候它不弹出上拉菜单
        MouseMove, 1, 1, 50, R  ; 动几下，弹出上拉菜单
        MouseMove, 1, 1, 50, R
        MouseClick, left, W-132, H-189, 1, 0 ; 点击设置速度正常
    }
    ; MouseMove, %origin_x%, %origin_y% ; 将鼠标移动到它的原来的位置。
}

#IfWinActive ahk_class PotPlayer64  ; 让PotPlayer也有同ACGplayer的qe快慢进功能
{
    ; 热键：
    q::Send, {Left} ; 快退5s
    e::Send, {Right} ; 快进5s

    return
}

#IfWinActive ahk_exe Telegram.exe  ; 让telegram也有同ACGplayer的qe快慢进功能
{
    ; 热键：
    !q::Send, {Left} ; 快退5s
    !e::Send, {Right} ; 快进5s

    return
}

#IfWinActive ahk_exe ApplicationFrameHost.exe
{
    #IfWinActive ACG Player
    {
        ; 热键：
        q::Send, {Left} ; 快退5s
        e::Send, {Right} ; 快进5s
        !<q::control_speed("-") 
        !<w::control_speed("0") 
        !<e::control_speed("+") 

        ; q::ControlSend, , {Left}, ACG 播放器 ; controlSend命令不知为何无法用，只能直接热键替代
        ; e::ControlSend, , {Right}, ACG 播放器
        return
    }
}
control_speed(flag){ 
    MouseGetPos, origin_x, origin_y ; 获取鼠标原始位置
    WinGetPos, X, Y, W, H, A
    if(flag = "+"){
        /*ControlGetFocus, curCtrl
        ControlGet, curCtrlHwnd, Hwnd,, % curCtrl
        GetClientSize(curCtrlHwnd, cW, cH)
        cText .= "`nClient:" "`tw: " cW "`th: " cH
        MsgBox, %cText% ;想获取窗口大小
        */
        MouseMove, W-210, H-132 ; 移动鼠标到进度条上面一点点的位置，显示速度调节栏
        MouseClick, left, W-164, 113, 1, 0 ; 点击调节速度栏
        MouseClick, left, W-156, 191, 1, 30 ; 点击速度+0.25
        ; sleep, 400
        MouseClick, left, W-246, H-163, 1, 0 ; 点击空白处，点一次没有反应，需要再次。
        ; Sleep, 500
        MouseClick, left, W-246, H-163, 1, 0 ; 再次点击
    }else if(flag = "-"){
        MouseMove, W-210, H-132 ; 移动鼠标到进度条上面一点点的位置，显示速度调节栏
        MouseClick, left, W-164, 113, 1, 0 ; 点击调节速度栏
        MouseClick, left, W-156, 260, 1, 0 ; 点击速度-0.25
        ; sleep, 400
        MouseClick, left, W-246, H-163, 1, 0 ; 点击空白处，点一次没有反应，需要再次。
        ; Sleep, 500
        MouseClick, left, W-246, H-163, 1, 0 ; 再次点击
    }else if(flag = "0"){
        MouseMove, W-210, H-132 ; 移动鼠标到进度条上面一点点的位置，显示速度调节栏
        MouseClick, left, W-164, 113, 1, 0 ; 点击调节速度栏
        MouseClick, left, W-156, 439, 1, 90 ; 点击1.0速率
        ; sleep, 400
        MouseClick, left, W-246, H-163, 1, 90 ; 点击空白处，点一次没有反应，需要再次。
        Sleep, 600
        MouseClick, left, W-246, H-163, 1, 0 ; 再次点击
    }
    MouseMove, %origin_x%, %origin_y% ; 将鼠标移动到它的原来的位置。
}

#IfWinActive ahk_exe FoxitPhantomPDF.exe
{
    RAlt::ControlSend, , >!, ahk_exe FoxitPhantomPDF.exe ; 解决无法使用右alt快捷键的问题

    x := 300 ; 要点击位置的横坐标（默认值）
    y := 400 ; 要点击位置的纵坐标（默认值）
    <!`::save_bookmark_and_click(0) ; 保存于第一个书签，当只有一个pdf实例打开时

    <!1::save_bookmark_and_click(1) ; 当前目标位置保存于第一个书签，当有多个pdf实例打开时
    <!2::save_bookmark_and_click(2) ; 当前目标位置保存于第二个书签，当有多个pdf实例打开时
    <!3::save_bookmark_and_click(3) ; 放大页面到75%
    <!4::save_bookmark_and_click(4) ; 打开打字机
    <!5::save_bookmark_and_click(5) ; 插入注释
    <!6::save_bookmark_and_click(6) ; 插入web链接
    return
}
save_bookmark_and_click(flag){
    if(flag = 0){
        ; MouseMove, 10, 10, 50, R; 缓慢移动鼠标 (速度 50 比较起默认的 2 显然要缓慢) 到距离当前位置右边 20 个像素且在下面 30 个像素的位置:
        MouseGetPos, x, y
        MouseClick, right, 76, 252, 1, 0 ; 在指定坐标处点击鼠标右键
        sleep, 50
        send, s
        sleep, 50
        send, {space}
        send, {CtrlDown}s{CtrlUp}
        MouseMove, %x%, %y%, 50,

    }else if(flag = 1){
        MouseGetPos, x, y
        MouseClick, right, 83, 294, 1, 0 ; 在指定坐标处点击鼠标右键
        sleep, 50
        send, s
        sleep, 100
        send, {space}
        send, {CtrlDown}s{CtrlUp}
        MouseMove, %x%, %y%, 50,
    }else if(flag = 2){
        MouseGetPos, x, y
        MouseClick, right, 84, 322, 1, 0 ; 在指定坐标处点击鼠标右键
        sleep, 50
        send, s
        sleep, 100
        send, {space}
        send, {CtrlDown}s{CtrlUp}
        MouseMove, %x%, %y%, 50,
    }else if(flag = 3){
        MouseGetPos, x, y
        MouseClick, left, 1671, 1012, 1, 0 ; 
        sleep, 30
        MouseClick, left, 1684, 613, 1, 0 ; 在指定坐标处点击鼠标左键

        MouseMove, %x%, %y%, 50,
    }else if(flag = 4){
        MouseGetPos, x, y ; 记录当前鼠标位置
        MouseClick, left, 514, 45, 1, 0 ; 点击注释
        sleep, 30
        MouseClick, left, 352, 97, 1, 0 ; 点击打字机

        MouseMove, %x%, %y%, 50, ; 返回模拟鼠标点击前的鼠标指针所在位置
    }else if(flag = 5){
        MouseGetPos, x, y ; 记录当前鼠标位置
        MouseClick, left, 514, 45, 1, 0 ; 点击注释
        sleep, 30
        MouseClick, left, 237, 103, 1, 0 ; 点击备注

        MouseMove, %x%, %y%, 50, ; 返回模拟鼠标点击前的鼠标指针所在位置
    }else if(flag = 6){
        MouseGetPos, x, y ; 记录当前鼠标位置
        MouseClick, left, 260, 58, 1, 0 ; 点击编辑
        sleep, 30
        MouseClick, left, 1388, 113, 1, 0 ; 点击插入web链接

        MouseMove, %x%, %y%, 50, ; 返回模拟鼠标点击前的鼠标指针所在位置
    }
}

;;必须以管理员权限运行本脚本，否则它无法在everything里生效
#IfWinActive ahk_exe Everything.exe
{
    
    <!j::Send, {Down} ; 下 
    <!l::Send, {Right} ; 右
    <!h::Send, {Left} ; 左
    <!k::Send, {Up} ; 上
    <!u::Send, {PgUp} ; 上一页
    <!d::Send, {PgDn} ; 下一页

    #n:: ; 在Everything用快捷键win+n启动用记事本打开你选中的文件
    {
        /* 法一：先获取选中项目的路径：从windowsSpy源码中学习到通过WinGetText能获得窗口状态栏里的信息，
        选中的项目的信息都在状态栏里，但虽然有路径名但是无文件名，非常尴尬，此方法失败。
        */
        /*
        DetectHiddenText, On
	    WinGetText, selecteditem ; 搜索框里的文字，修改此文件权限，文件大小，修改时间，访问时间，目录都在这里
        ; MsgBox, %selecteditem% ; 
        ; StatusBarGetText, file_path, ; 与上面那句相似作用，但能取到的数据更少
        RegExMatch(selecteditem , "路径:.*", search_text)  ; RegExMatch("源字符", "正则表达式", 保存结果变量)
        
        file_dir := StrSplit(search_text, "路径:")[2]  ; StrSplit("源字符", "分割符")[取用结果数组的第几个]
        file_dir := Trim(file_dir)  ; Trim("源字符串", 除去的字符默认除空格和tab) 填" "可同时去空格和制表符，填"`t"只能去制表符
        
        ; list1 := StrSplit(selecteditem, "`n")
        ; for k,v in list1
        ;     MsgBox, %k%=%v%

        selecteditem := "" ; 通过赋值为空可以释放大变量占用的内存
        run, C:\Windows\Notepad.exe `"%file_dir%`" ; 用记事本打开
        */
        
        /* 法二：选中项目后直接鼠标右键+f(获取文件绝对路径)，然后用记事本打开。 
        bug1:send类、Click类命令好像在Everything.exe中失效了
        solution:必须以管理员权限运行本脚本，否则它无法在everything里生效
        */

        MouseClick, Right
        Send, {f}
        Sleep, 350 ;
        ;~ MsgBox, %Clipboard%
        run, C:\Windows\Notepad.exe `"%Clipboard%`"
        

        return
    }
    
    #e:: ; 在Everything用快捷键windows+e来启动vscode来打开选中的文件
    {
        MouseClick, Right
        Sleep, 350
        Send, {f}
        Sleep, 350 ;
        run, E:\Microsoft VS Code1.51.1.0\_\Code.exe `"%Clipboard%`"
        return
    }

    ;快捷键 ctrl+alt+c 用chrome打开选中文件
    <^<!c::
    {
        MouseClick, Right
        Send, {f}
        Sleep, 200 ;
        run, C:\Program Files\Google\Chrome\Application\chrome.exe `"%Clipboard%`"
        ;MsgBox %file_path%  ;弹窗输出当前文件的路径
        return
    }
}

#IfWinActive ahk_exe cstrike.exe ; 这个是一个很好用的autohotkey的IDE
{
    F1:: ; 购买护甲到500，无限子弹，连跳技能，火箭筒
    {
        Send, m29995
        Send, m25
        Send, m25
        Send, m25
        Send, m25 ;护甲500
        Send, m27 ;无限子弹
        Send, m24 ;连跳技能
        Send, m24 ;连跳技能
        Send, m23 ;火箭筒
        Send, q
        return
    }
    F2:: ; 购买10个激光绊雷
    {
        Send, m29996
        Send, m26
        Send, m26
        Send, m26
        Send, m26
        Send, m26
        Send, m26
        Send, m26
        Send, m26
        Send, m26
        return
    }
    F3:: ; 购买5个燃烧弹
    {
        Send, m28885
        Send, m25
        Send, m25
        Send, m25
        Send, m25
        return
    }
    
    ; 鼠标后退键代替激光拌雷施放按键
    XButton1::p
}

#IfWinActive ahk_exe SciTE.exe ; 这个是一个很好用的autohotkey的IDE
{
    ^r:: ; ctrl+r 保存并运行代码
    {
        Send, ^s
        ;~ Send, {F5} ; SciTE4AutoHotkey里开始能用，后来失效了？
        Send, !tg ;如果脚本已经在运行，无法replace更改
        Reload ;没用，reload了但还是没用，只能退出脚本再运行。因为SciTE4运行一个ahk是一个进程，不会中途退出更新程序代码
        return
    }
    ^!r:: ; ctrl+shift+r 保存并调试代码
    {
        Send, ^s
        Send, {F7}
        Sleep, 500
        Send, +{F11}
        return
    }
    ^d:: ; ctrl+d 停止调试
    {
        MouseGetPos, x, y ; 记录当前鼠标位置
        MouseClick, left, 535, 77, 1, 0 ; 点击停止debug
        sleep, 30
        MouseMove, %x%, %y%, 0, ; 返回模拟鼠标点击前的鼠标指针所在位置
        return
    }
    
}

;;这种#IfWinActive必须放在脚本的最后面，否则它下面的其它非#语句无效



/*
;ctrl+F1 本热键用于测试，在新建的记事本中输入：New Text Here
^F1::
; ControlSetText, Edit1, New Text Here, 新建文本文档.txt - 记事本
 */



