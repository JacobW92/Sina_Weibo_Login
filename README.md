在WYGetToken的头文件里，把需要授权的App的Key和Secret还有回调地址写上去，然后在ViewController的 ViewDidLoad里把账号密码填好，做了一下测试好像只要不是新注册的号，都是可以马上获得Token的。
那个公钥，就是微博一直以来用的Public Key，好像没有变过，变过的话到时候再更新就好了。



这个也就是在写爬虫的时候，才想起来，原来这边一直没有去实现过，现在满足了当时的自己。
就测试测试就好了，感觉bug会有点多。
