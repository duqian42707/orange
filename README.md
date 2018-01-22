# orange
集成了[openresty][t1]、[lor][t2]、[orange][t3]、mysql(mariadb)、java

镜像公网地址：
docker pull registry.cn-hangzhou.aliyuncs.com/duqian/orange

## 准备工作

将准备好的springboot的jar文件放在宿主机的某文件夹下（如：/data/jars），将该文件夹挂载到容器内。

## 启动容器

```bash
docker run --name my_orange -d -p 9999:9999 -p 8888:80 -p 3306:3306 \
    -v /data/jars:/root/jars registry.cn-hangzhou.aliyuncs.com/duqian/orange
```
## 进入容器

```bash
docker exec -it my_orange /bin/bash
```

### 部署springboot应用

```bash
[root@e1d1084145c1 orange]# cd /root/jars
[root@e1d1084145c1 jars]# nohup java -jar abc.jar &
```
注意：端口不要冲突

### 修改nginx配置文件

```bash
[root@e1d1084145c1 jars]# vi /usr/local/orange/conf/nginx.conf
```
添加或修改一个upstream节点
```conf
    upstream abc_upstream{
        server localhost:8082;
    } 
```

### 重启orange

```bash
[root@e1d1084145c1 jars]# cd /usr/local/orange/
[root@e1d1084145c1 orange]# orange restart
```

注意：启动orange的命令需要在orange的安装目录下执行，否则会报错。

## 退出容器

输入`exit` 或按组合键 `ctrl+P+Q`

## orange界面操作
- 浏览器访问 `http://localhost:9999`
- 输入用户名密码登录（默认为admin/orange_admin）
- 进入 **代理&分流**
- 启用该插件
- 添加选择器 - 启用
- 添加新规则
    
    规则 url match /abc
    
    处理 http://abc_upstream
    
    启用

![](http://ouapqg8mg.bkt.clouddn.com/18-1-20/62759662.jpg)

## 通过浏览器访问应用
```
http://localhost:8888/abc/demo/say
```

![](http://ouapqg8mg.bkt.clouddn.com/18-1-20/11898818.jpg)

[t1]: https://openresty.org/cn/
[t2]: https://github.com/sumory/lor
[t3]: http://orange.sumory.com/
