# [1 汇编语言入门教程](https://www.ruanyifeng.com/blog/2018/01/assembly-language-primer.html)



## 1.1 学习目的

为了更好调试bug，看出程序崩溃的原因。



## 1.2 定义

操作计算机的<font color='red'>指令都是二进制</font>的，称为<font color='red'>操作码（opcode）</font>，比如加法指令就是00000011。编译器的作用，就是将高级语言写好的程序，翻译成一条条操作码。

<font color='red'>汇编语言是二进制指令的文本形式</font>，与指令是一一对应的关系。比如，加法指令00000011写成汇编语言就是 ADD。只要还原成二进制，汇编语言就可以被 CPU 直接执行，<font color='red'>所以它是最底层的低级语言。</font>



## 1.3 寄存器

先来看寄存器。<font color='red'>CPU 本身只负责运算，不负责储存数据。</font>数据一般都储存在内存之中，CPU 要用的时候就去<font color='red'>内存</font>读写数据。但是，CPU 的运算速度远高于内存的读写速度，为了避免被拖慢，<font color='red'>CPU 都自带一级缓存和二级缓存</font>。基本上，CPU 缓存可以看作是读写速度较快的内存。

但是，CPU 缓存还是不够快，另外数据在缓存里面的地址是不固定的，CPU 每次读写都要寻址也会拖慢速度。因此，除了缓存之外，CPU 还自带了<font color='red'>寄存器</font>（register），用来储存最常用的数据。也就是说，那些最频繁读写的数据（比如循环变量），都会放在寄存器里面，CPU 优先读写寄存器，再由寄存器跟内存交换数据。

## 1.4 寄存器种类

早期的 <font color='red'>x86 CPU</font> 只有8个寄存器，而且每个都有不同的用途。现在的寄存器已经有<font color='red'>100多个了，都变成通用寄存器，不特别指定用途了</font>，但是早期寄存器的名字都被保存了下来。

> - EAX
> - EBX
> - ECX
> - EDX
> - EDI
> - ESI
> - EBP
> - ESP

我们常常看到 32位 CPU、64位 CPU 这样的名称，其实指的就是寄存器的大小。<font color='red'>32 位 CPU 的寄存器大小就是4个字节。</font>

ESP 寄存器有特定用途，保存当前 Stack 的地址（详见下一节）。

## 1.5 内存模型：Heap堆

寄存器只能存放很少量的数据，大多数时候，CPU 要指挥寄存器，直接跟内存交换数据。所以，除了寄存器，还必须了解内存怎么储存数据。



程序运行的时候，操作系统会给它分配一段内存，用来储存程序和运行产生的数据。这段内存有起始地址和结束地址，<font color='red'>比如从0x1000到0x8000，</font>起始地址是较小的那个地址，结束地址是较大的那个地址。

![image-20241127005537755](汇编学习与dump调试.assets/image-20241127005537755.png)

<font color='red'>这种因为用户主动请求而划分出来的内存区域，叫做 Heap（堆）</font>。它由起始地址开始，从低位（地址）向高位（地址）增长。Heap 的一个重要特点就是不会自动消失，必须手动释放，或者由垃圾回收机制来回收。

## 1.6 内存模型：Stack栈

除了 Heap 以外，其他的内存占用叫做 Stack（栈）。简单说，Stack 是由于函数运行而临时占用的内存区域。



![image-20241127005819249](汇编学习与dump调试.assets/image-20241127005819249.png)



上面代码中，系统开始执行main函数时，会为它在内存里面建立一个帧（frame），所有main的内部变量（比如a和b）都保存在这个帧里面。main函数执行结束后，该帧就会被回收，释放所有的内部变量，不再占用空间。







## 其他

JS里的闭包，都是在堆中申请的，由GC管理，不是这里的栈，“JS栈”与汇编或C语言中的栈是两个概念。汇编栈不存在GC，由函数调用与返回来自动更新SP指针实现的。JS函数与这儿的函数是两种东西。

建议了解浏览器内存回收机制。闭包是因为一直保持引用关系，所以不会被回收



# 2 例子

## 2.1 相加例子

### c++源代码

```c++
#include <iostream>
#include <string>
using namespace std;

int main(){
	int a = 0;
	int b = 1;
	int c = a+b;
	cout << c << endl;
	    return 0;
}
```

### 汇编代码结合c++源代码

用vs studio的窗口->反汇编工具看：

```asm
#include `<iostream>`
#include `<string>`
using namespace std;

int main(){
003013C0  push        ebp
003013C1  mov         ebp,esp
003013C3  sub         esp,0E4h
003013C9  push        ebx
003013CA  push        esi
003013CB  push        edi
003013CC  lea         edi,[ebp-0E4h]
003013D2  mov         ecx,39h
003013D7  mov         eax,0CCCCCCCCh
003013DC  rep stos    dword ptr es:[edi]

	int a = 0;
003013DE  mov         dword ptr [a],0
	int b = 1;
003013E5  mov         dword ptr [b],1
	int c = a+b;
003013EC  mov         eax,dword ptr [a]
003013EF  add         eax,dword ptr [b]
003013F2  mov         dword ptr [c],eax

	cout << c << endl;
003013F5  mov         esi,esp
003013F7  mov         eax,dword ptr [__imp_std::endl (308298h)]
003013FC  push        eax
003013FD  mov         edi,esp
003013FF  mov         ecx,dword ptr [c]
00301402  push        ecx
00301403  mov         ecx,dword ptr [__imp_std::cout (308290h)]
00301409  call        dword ptr [__imp_std::basic_ostream[char,std::char_traitschar< >::operator<< (308294h)]
0030140F  cmp         edi,esp
00301411  call        @ILT+325(__RTC_CheckEsp) (30114Ah)
00301416  mov         ecx,eax
00301418  call        dword ptr [__imp_std::basic_ostream](char,std::char_traits%3Cchar)[char,std::char_traitschar< >::operator<< (30829Ch)]
0030141E  cmp         esi,esp
00301420  call        @ILT+325(__RTC_CheckEsp) (30114Ah)
	    return 0;
...
```



## 2.2 访问越界



```c++
int main() {
	int a[] = { 0,1,2 };
	*(a+3) = 9;
	for (int i = 0; i < 3; ++i) {
		std::cout << *(a+i) << std::endl;
	}
	return 0;
}
```



代码：猜测是访问越界导致，所以单写了代码越界的代码调试用

```asm
...

int a[] = { 0,1,2 };
0058198F  mov         dword ptr [a],0  
00581996  mov         dword ptr [ebp-10h],1  
0058199D  mov         dword ptr [ebp-0Ch],2  
	*(a+3) = 9;
005819A4  mov         dword ptr [ebp-8],9  
	for (int i = 0; i < 3; ++i) {
005819AB  mov         dword ptr [ebp-20h],0  
005819B2  jmp         __$EncStackInitStart+51h (05819BDh)  
005819B4  mov         eax,dword ptr [ebp-20h]  
005819B7  add         eax,1  
005819BA  mov         dword ptr [ebp-20h],eax  
005819BD  cmp         dword ptr [ebp-20h],3  
005819C1  jge         __$EncStackInitStart+8Ch (05819F8h) 

		std::cout << *(a+i) << std::endl;
...
```



# 3 windbg使用

[windbg使用超详细教程(我是新手，大佬轻虐)](https://www.cnblogs.com/jijm123/p/16392465.html)



# 4 其他



https://blog.csdn.net/chenlycly/article/details/125529931  

https://blog.csdn.net/chenlycly/article/details/52485425  

https://blog.csdn.net/chenlycly/article/details/52485476





[汇编语言中mov和lea的区别有哪些？](https://www.zhihu.com/question/40720890/answer/110774673)

lea是“load effective address”的缩写，简单的说，lea指令可以用来将一个内存地址直接赋给目的操作数，例如：lea eax,[ebx+8]就是将ebx+8这个值直接赋给eax，而不是把ebx+8处的内存地址里的数据赋给eax。而mov指令则恰恰相反，例如：mov eax,[ebx+8]则是把内存地址为ebx+8处的数据赋给eax。

发布于 2016-07-12 20:21

[猿人张丘山](https://www.zhihu.com/people/0eb45c2e141f5b4ceb3d87c3be97a854)

lea eax,[ebx+8] 等价于 mov eax,ebx+8

2023-02-25

