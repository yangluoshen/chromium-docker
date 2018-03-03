# chromium-docker

方便headless chrome调试的docker镜像。

### Usage

    docker build -t chromium .
    docker run --rm -d -p 19222:19222 chromium
    curl localhost:19222/json    #check if ok
    
    
### Pull from dockerhub

    docker run --rm -d -p 19222:19222 shenweimin/chromium
    

### Description

* 支持中文字体，emoji（noto emoji)
* 最新chromium下载[参见](https://github.com/scheib/chromium-latest-linux)
