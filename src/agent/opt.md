@title
    常见的前端优化手段
@tags
    web前端
@summary
    如题
@content

- css sprite

    大量的小图标会增加大量请求,利用background-size和background-origin属性可以实现将大量图标放在一张图片上使用,将请求减少至一次

- 使用DocumentFragment或innerHTML代替复杂的DOM操作

    DOM操作很慢,DocumentFragment相当于一个DOM Buffer,将DOM操作减少至一次,innerHTML同理

- 使用异步请求(Ajax or defer)实现外部js的异步加载

    防止耗时的js阻塞之后的内容的加载(提高并行性),隐患:脚本执行顺序发生改变

- 使用Array.prototype.join代替字符串连接

    字符串连接很慢(+,+=等操作会生成新字符串而不是直接在原字符串上操作)

- 尽可能使用css而不是js实现动画

    css动画比js动画性能更好(但有局限性: 可控性小)

- 控制DOM大小

    ::before & ::after, 这两者并不存在于DOM中, 却是文档结构的一部分

- 缓存重复使用的变量

    循环遍历时, 缓存collection.length, 不要重复获取
    
    此处保留质疑: 经测试, 一个length=1000的HTMLCollection, 千万次获取length仅需要8s(chrome39; ie11为4s), 百万次测试结果约为1/10, 不足1s, 万次测试已经在0.01s左右, 而实际中真的需要如此数量级的访问吗

- 合并js, css

    好处是减少请求数, 但对于通用库等多个页面都使用的资源, 这样做反而影响http缓存的发挥, 需要权衡

- 压缩js, css

    减小资源体积(顺带加密效果)

- 解除引用

    variable = null
