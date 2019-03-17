# Hulk--短地址服务

---
### 名称含义

> Hulk 绿巨人--可弹性伸缩,与短地址长地址有异曲同工之妙

---
### 注意事项
1./etc/hosts文件中修改域名映射地址,如我本机上测试使用的是
```
127.0.0.1     lh.cn
```

2.通过
```
http://lh.cn:3000 or http://localhost:3000
```
访问主页.

3.由于本机测试时80端口有被占用,无法使用80端口,所以在`config/application`中,`config.base_short_url = "http://lh.cn:3000/"`,在您自行使用时,可更改

4.生成短地址的接口测试位于`./test/controllers`下

5.重载了rails的日志格式,日志信息位于`./log`文件夹下

---
### 数据表设计
``` 
CREATE TABLE `short_url` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` text COMMENT '原始链接地址',
  `keyword` varchar(128) NOT NULL DEFAULT '' COMMENT '短链key',
  `create_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0:系统创建,1:用户自定义',
  `in_black_list` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否在黑名单中,不让被访问,0:false,1:true',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否删除,0:已删除,1:未删除',
  `use_count` int(10) NOT NULL DEFAULT '0' COMMENT '链接访问次数',
  `addtime` int(10) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `modify_time` int(10) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='短链接基本表'

```
---
###接口文档
1.生成短地址接口
```
URL: 
    base_url + "short_url/api/create_short_url"
请求方式:
    POST
入参: 
 名称                  类型          必传         备注 
 long_url_input        String         Y           长地址
 customer_generate     boolean        Y           是否自定义
 keyword               String         N           用户自定义短链

返回值格式:
    json

成功返回示例:
    {
        "success": true,
        "message": "成功",
        "data": {
            "short_url": "http://lh.cn:3000/fagaff"
        }
    }
失败返回示例:
    {
        "success": false,
        "message": "XXXXX",
        "data": {
        }
    }
失败返回message
    *必传参数未传值
    *系统内部错误,请联系管理员查看原因
    *输入的url不合法,请重新输入
```
2.获取长地址接口
```
URL: 
    base_url + "short_url/api/search_long_url"
请求方式:
    POST
入参: 
 名称                  类型          必传         备注 
 short_url_input        String         Y          短地址

返回值格式:
    json

成功返回示例:
    {
        "success": true,
        "message": "成功",
        "data": {
            "long_url": "http://www.baidu.com"
        }
    }
失败返回示例:
    {
        "success": false,
        "message": "XXXXX",
        "data": {
        }
    }
失败返回message
    *必传参数未传值
    *输入的url没有命中任何数据,请重新输入
    *输入的url中没有短链关键词,请重新输入
    *输入的url不合法,请重新输入
```
---
###扩展点
1.管理平台中扩展删除,编辑短地址,增加黑名单白名单的功能

2.接口调用暂时未使用BA认证或者鉴权等方案,后续迭代可添加

3.用户自定义项目前只支持短链自定义,后续可增加一些自主服务

4.安全性保证:可能存在短时间内攻击导致自增ID耗光,出现重复.第一,可限流,第二,缓存`long_url => keyword`的映射关系,用一个长地址打到服务器上,直接从缓存中返回即可,不用操作数据库

5.目前的计数功能基于最简单的操作数据库直接保存,后续可以改动为先将一段时间内的计数缓存至redis中,在底峰期持久化到硬盘中