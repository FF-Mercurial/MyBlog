@title
    常见的前端优化手段
@tags
    web前端
@summary
    如题
@content

- css sprite

    大量的小图标会增加大量请求, 利用`background-size`和`background-origin`属性可以实现将大量图标放在一张图片上使用, 将请求减少至一次

- 使用`DocumentFragment`或`innerHTML`代替复杂的DOM操作

    DOM操作很慢, `DocumentFragment`相当于一个DOM Buffer, 将DOM操作减少至一次, `innerHTML`同理

- js异步加载(ajax, defer, async)

    防止耗时的js阻塞之后的内容的加载(提高并行性)

- 静态资源设置超长过期时间(Expires / Cache-Control)
    
    最大程度利用缓存, 如何更新? 可以将特征值(版本号或摘要)写入querystring防止使用缓存

- 使用`Array.prototype.join`代替字符串连接

    字符串连接很慢(`+`, `+=`等操作会生成新字符串而不是直接在原字符串上操作)

- 循环遍历时, 缓存`collection.length`, 不要重复获取

    各种Collection会随DOM操作实时更新, 因此`collection.length`也需要重新计算
    
    此处保留质疑: 经测试, 一个length=1000的Collection, 千万次获取length仅需要8s(chrome39; ie11为4s), 百万次测试结果约为1/10, 不足1s, 万次测试已经在0.01s左右, 而实际中真的需要如此数量级的访问吗

- 合并js, css

    好处是减少请求数, 但对于通用库等多个页面都使用的资源, 这样做反而影响http缓存的发挥, 需要权衡

- 压缩js, css

    减小资源体积(顺带加密效果)

- 手动解除引用

    `variable = null`, 提示GC已经可以进行回收, 不必等待退出作用域
