



### [学习Javascript闭包（Closure）](https://www.ruanyifeng.com/blog/2009/08/learning_javascript_closures.html)

#### 总结

各种专业文献上的"闭包"（closure）定义非常抽象，很难看懂。我的理解是，闭包就是能够读取其他函数内部变量的函数。

由于在Javascript语言中，只有函数内部的子函数才能读取局部变量，因此可以把闭包简单理解成"定义在一个函数内部的函数"。

所以，在本质上，闭包就是将函数内部和函数外部连接起来的一座桥梁。

有点像c++里面的友元函数，让类内部的私有成员给其他的类使用。也有点像getter方法。

#### 讲解

在函数外部自然无法读取函数内的局部变量。

> 　　function f1(){
> 　　　　var n=999;
> 　　}
>
> 　　alert(n); // error



```javascript
    function f1(){
        var n=999;
        function f2(){
            alert(n); // 999
        }
    }
```

在上面的代码中，函数f2就被包括在函数f1内部，<font color='red'>这时f1内部的所有局部变量，对f2都是可见的。但是反过来就不行</font>，f2内部的局部变量，对f1就是不可见的。这就是Javascript语言特有的<font color='red'>"链式作用域"</font>结构（chain scope），子对象会一级一级地向上寻找所有父对象的变量。<font color='red'>所以，父对象的所有变量，对子对象都是可见的，反之则不成立。</font>

既然f2可以读取f1中的局部变量，那么只要把f2作为返回值，我们不就可以在f1外部读取它的内部变量了吗！

```javascript
　function f1(){
　　　　var n=999;
　　　　function f2(){
　　　　　　alert(n);
　　　　}
　　　　return f2;
　　}
　　var result=f1();
　　result(); // 999
```



#### **闭包的用途**

闭包可以用在许多地方。它的最大用处有两个，一个是前面提到的可以读取函数内部的变量，另一个就是让这些变量的值始终保持在内存中。

怎么来理解这句话呢？请看下面的代码。

> 　　function f1(){
>
> 　　　　var n=999;
>
> 　　　　nAdd=function(){n+=1}
>
> 　　　　function f2(){
> 　　　　　　alert(n);
> 　　　　}
>
> 　　　　return f2;
>
> 　　}
>
> 　　var result=f1();
>
> 　　result(); // 999
>
> 　　nAdd();
>
> 　　result(); // 1000

在这段代码中，result实际上就是闭包f2函数。它一共运行了两次，第一次的值是999，第二次的值是1000。这证明了，函数f1中的局部变量n一直保存在内存中，并没有在f1调用后被自动清除。

为什么会这样呢？原因就在于f1是f2的父函数，而f2被赋给了一个全局变量，这导致f2始终在内存中，而f2的存在依赖于f1，因此f1也始终在内存中，不会在调用结束后，被垃圾回收机制（garbage collection）回收。

这段代码中另一个值得注意的地方，就是"nAdd=function(){n+=1}"这一行，首先在nAdd前面没有使用var关键字，因此nAdd是一个全局变量，而不是局部变量。其次，nAdd的值是一个匿名函数（anonymous function），而这个匿名函数本身也是一个闭包，所以nAdd相当于是一个setter，可以在函数外部对函数内部的局部变量进行操作。

#### **使用闭包的注意点**

1）由于闭包会使得函数中的变量都被保存在内存中，内存消耗很大，所以不能滥用闭包，否则会造成网页的性能问题，在IE中可能导致内存泄露。解决方法是，在退出函数之前，将不使用的局部变量全部删除。

2）闭包会在父函数外部，改变父函数内部变量的值。所以，如果你把父函数当作对象（object）使用，把闭包当作它的公用方法（Public Method），把内部变量当作它的私有属性（private value），这时一定要小心，不要随便改变父函数内部变量的值。



### JS里的闭包 在堆中申请

来源：[1 汇编语言入门教程](https://www.ruanyifeng.com/blog/2018/01/assembly-language-primer.html)

<font color='red'>JS里的闭包</font>，都是在<font color='red'>堆中申请</font>的，由<font color='red'>GC管理</font>，不是这里的栈，“JS栈”与汇编或C语言中的栈是两个概念。<font color='red'>汇编栈不存在GC</font>，由函数调用与返回来自动更新SP指针实现的。JS函数与这儿的函数是两种东西。

建议了解浏览器内存回收机制。闭包是因为一直保持引用关系，所以不会被回收



### [js怎么样删除一个变量](https://docs.pingcode.com/baike/3684701)

delete or =null =undefine



**2. JavaScript中删除变量的注意事项是什么？**

- **问题：** 在删除JavaScript变量时，有什么需要注意的事项？

- 回答：

   

  在删除变量时，需要注意以下几点：

  - 删除变量不会删除其值，只会删除对变量的引用。
  - 删除变量后，变量的值仍然可以在内存中存在，直到没有任何引用指向它时被垃圾回收机制清除。
  - 删除变量后，再次使用该变量名将会引发错误。

**3. 删除JavaScript变量与将其赋值为null有什么区别？**

- **问题：** 删除JavaScript变量和将其赋值为null有什么不同？

- 回答：

   

  删除变量和将其赋值为null之间存在一些区别：

  - 删除变量使用`delete`关键字，而将变量赋值为null使用赋值操作符`=`。
  - 删除变量会从内存中删除对变量的引用，而将其赋值为null只是将变量的值设置为null。
  - 删除变量后，无法再次使用该变量名，而将变量赋值为null后，可以重新赋予其他值。



### [js如何删除局部变量](https://docs.pingcode.com/baike/2316013)



### 让宏任务中的微任务同步执行问题



```javascript
function funcA(ms) {
  return new Promise((resolve) => {
    console.log("funcA过程", 1);
    resolve(1); // 返回值
  });
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
  let array = [0];

  // 使用 Promise.all 等待所有的 funcA 完成
  await Promise.all(array.map((item, i) => funcA(0).then((resolve) => {
    item =  resolve;
    console.log("funcA回调结果",item);
    array[i] = item;
  }));

  // 由于所有的 funcA 都完成了，以下代码会在它们完成后执行
  console.log("c");
  console.log("d");
  array.forEach((item, i) => console.log("main结果", item));
}

function watch(a) {
  // 可以在这里添加代码来观察a的值
}

main();
```

