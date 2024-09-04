### [快速入门](https://www.electronjs.org/zh/docs/latest/tutorial/quick-start)

#### 创建你的应用程序

##### 使用脚手架创建

```shell
mkdir my-electron-app && cd my-electron-app
yarn init
```



`init`初始化命令会提示您在项目初始化配置中设置一些值 为本教程的目的，有几条规则需要遵循：

- `entry point` 应为 `main.js`.
- `author` 与 `description` 可为任意值，但对于[应用打包](https://www.electronjs.org/zh/docs/latest/tutorial/quick-start#package-and-distribute-your-application)是必填项。

你的 `package.json` 文件应该像这样：

```json
{
  "name": "my-electron-app",
  "version": "1.0.0",
  "description": "Hello World!",
  "main": "main.js",
  "author": "Jane Doe",
  "license": "MIT"
}
```



然后，将 electron 包安装到应用的开发依赖中。

```shell
yarn add --dev electron
```



最后，您希望能够执行 Electron 如下所示，在您的 [`package.json`](https://docs.npmjs.com/cli/v7/using-npm/scripts)配置文件中的`scripts`字段下增加一条`start`命令：

```json
{
  "scripts": {
    "start": "electron ."
  }
}
```

start命令能让您在开发模式下打开您的应用

```shell
yarn start
```

对比，electron start shell启动脚本。

##### 运行主进程

任何 Electron 应用程序的入口都是 main 文件。 这个文件控制了主进程，它运行在一个完整的Node.js环境中，负责控制您应用的生命周期，显示原生界面，执行特殊操作并管理渲染器进程(稍后详细介绍)。



执行期间，Electron 将依据应用中 `package.json`配置下[`main`](https://docs.npmjs.com/cli/v7/configuring-npm/package-json#main)字段中配置的值查找此文件，您应该已在[应用脚手架](https://www.electronjs.org/zh/docs/latest/tutorial/quick-start#scaffold-the-project)步骤中配置。

要初始化这个`main`文件，需要在您项目的根目录下创建一个名为`main.js`的空文件。

> 注意：如果您此时再次运行`start`命令，您的应用将不再抛出任何错误！ 然而，它不会做任何事因为我们还没有在`main.js`中添加任何代码。

对比，主进程，windowsmanager.ts

##### [创建页面](https://www.electronjs.org/zh/docs/latest/tutorial/quick-start#创建页面)

在可以为我们的应用创建窗口前，我们需要先创建加载进该窗口的内容。 在Electron中，各个窗口显示的内容可以是本地HTML文件，也可以是一个远程url。

此教程中，您将采用本地HTML的方式。 在您的项目根目录下创建一个名为`index.html`的文件：

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <!-- https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP -->
    <meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self'">
    <title>Hello World!</title>
  </head>
  <body>
    <h1>Hello World!</h1>
    We are using Node.js <span id="node-version"></span>,
    Chromium <span id="chrome-version"></span>,
    and Electron <span id="electron-version"></span>.
  </body>
</html>
```



#### [在窗口中打开您的页面](https://www.electronjs.org/zh/docs/latest/tutorial/quick-start#在窗口中打开您的页面)

现在您有了一个页面，将它加载进应用窗口中。 要做到这一点，你需要 两个Electron模块：

- [`app`](https://www.electronjs.org/zh/docs/latest/api/app) 模块，它控制应用程序的事件生命周期。
- [`BrowserWindow`](https://www.electronjs.org/zh/docs/latest/api/browser-window) 模块，它创建和管理应用程序 窗口。

因为主进程运行 Node.js，您可以将这些导入您的 `main.js` 文件顶端：

```js
const { app, BrowserWindow } = require('electron')
```



然后，添加一个`createWindow()`方法来将`index.html`加载进一个新的`BrowserWindow`实例。

```js
const createWindow = () => {
  const win = new BrowserWindow({
    width: 800,
    height: 600
  })

  win.loadFile('index.html')
}
```

对比，windowsmanager.ts初始化会议窗口。



接着，调用`createWindow()`函数来打开您的窗口。

在 Electron 中，只有在 `app` 模块的 [`ready`](https://www.electronjs.org/zh/docs/latest/api/app#event-ready) 事件被激发后才能创建浏览器窗口。 您可以通过使用 [`app.whenReady()`](https://www.electronjs.org/zh/docs/latest/api/app#appwhenready) API来监听此事件。 在`whenReady()`成功后调用`createWindow()`。

```js
app.whenReady().then(() => {
  createWindow()
})
```

对比，windowsmanager.ts中createmeeting窗口。

> 注意：此时，您的电子应用程序应当成功 打开显示您页面的窗口！



#### [管理窗口的生命周期](https://www.electronjs.org/zh/docs/latest/tutorial/quick-start#管理窗口的生命周期)

虽然你现在可以打开一个浏览器窗口，但你还需要一些额外的模板代码使其看起来更像是各平台原生的。 应用程序窗口在每个OS下有不同的行为，Electron将在app中实现这些约定的责任交给开发者们。

一般而言，你可以使用 `进程` 全局的 [`platform`](https://nodejs.org/api/process.html#process_process_platform) 属性来专门为某些操作系统运行代码。



##### [关闭所有窗口时退出应用 (Windows & Linux)](https://www.electronjs.org/zh/docs/latest/tutorial/quick-start#关闭所有窗口时退出应用-windows--linux)

在Windows和Linux上，关闭所有窗口通常会完全退出一个应用程序。

为了实现这一点，你需要监听 `app` 模块的 [`'window-all-closed'`](https://www.electronjs.org/zh/docs/latest/api/app#event-window-all-closed) 事件。如果用户不是在 macOS(`darwin`) 上运行程序，则调用 [`app.quit()`](https://www.electronjs.org/zh/docs/latest/api/app#appquit)。

```js
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit()
})
```

对比，truemeet中的.on关闭开启事件。



#### [关闭所有窗口时退出应用 (Windows & Linux)](https://www.electronjs.org/zh/docs/latest/tutorial/quick-start#关闭所有窗口时退出应用-windows--linux)

在Windows和Linux上，关闭所有窗口通常会完全退出一个应用程序。

为了实现这一点，你需要监听 `app` 模块的 [`'window-all-closed'`](https://www.electronjs.org/zh/docs/latest/api/app#event-window-all-closed) 事件。如果用户不是在 macOS(`darwin`) 上运行程序，则调用 [`app.quit()`](https://www.electronjs.org/zh/docs/latest/api/app#appquit)。

```js
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit()
})
```



[Window：load 事件](https://developer.mozilla.org/zh-CN/docs/Web/API/Window/load_event)

[JavaScript window.onload](https://www.runoob.com/w3cnote/javascript-window-onload.html)

[js加载顺序疑惑：window.load、document.body.load和$(function(){})](https://blog.csdn.net/zhangzhao100110/article/details/84659528?spm=1001.2101.3001.6650.3&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-3-84659528-blog-99714246.235%5Ev43%5Epc_blog_bottom_relevance_base2&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-3-84659528-blog-99714246.235%5Ev43%5Epc_blog_bottom_relevance_base2&utm_relevant_index=6)

