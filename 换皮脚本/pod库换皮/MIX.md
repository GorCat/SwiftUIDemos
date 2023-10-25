### 脚本使用方法

1. 将代码从[git](http://gitlab.wudi360.com/liqinglian/livekitswift.git)克隆到本地目录

   ```shell
   git clone http://gitlab.wudi360.com/liqinglian/livekitswift.git
   ```

2. 切换到Tools/ExcelToStrings文件夹下面

   ```shell
   目录说明
   live_strings.xlsx 直播间使用到的多语言文档
   main.sh shell执行脚本
   其余文件可不关心
   ```

3. 执行main.sh 脚本

   ```shell
   sh main.sh
   input what you want to do
   1. encrypt strings file with aes-128-cbc 
   2. replace prefix in directory 
   ```

​		**1）多语言加密，根据提示输入16位的key和16位的iv，执行完毕会在目录下生成多语言文件，可将多语言文件直接复制到Resources，并在BF_Configuration的初始化方法中将languageDecryptKey和languageDecryptIv的默认值替换成刚刚输入的key和iv**

​	    **2）前缀替换，根据提示输入文件夹，需要替换的前缀和要替换成的前缀，前缀会进行大小写匹配，比如将直播间的BF_替换成AAB_，则会将直播间的BF_替换成AAB_，并且把直播间的的bf_前缀替换成aab_前缀，这里会把资源文件一起替换掉，包括上面生成的多语言文件，注意脚本不会替换压缩包里面的内容，该功能暂未开发，语聊房的压缩包资源还需要自己更换**

4. 如果报错，可以配置一下环境

   ```shell
   sudo gem install bundler 
   bundle install
   ```
