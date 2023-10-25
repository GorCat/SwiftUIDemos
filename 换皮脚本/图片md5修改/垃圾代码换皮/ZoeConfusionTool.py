import re
import os
import sys
import random



class ConfusionTool:
    maxPropertyCount = 10
    maxNorFunc = 6
    maxFunc = 2
    maxTag = 10
    addPrefixStr = 'zzkago'
    prefixPath = ''
    methodNamePath = ''
    garbageMethodPath = ''
    methodNameArray = []
    garbageMethodArray = []
    codeArr = []
    allMPathArr = []
    hLjnameArr = []



    def isEndFh(self,codeStr):
       newStr = str(codeStr).replace(' ','').replace('\n','')
       if '//' in newStr:
          arr = newStr.split('//')
          newStr = str(arr[0])
       if len(newStr) == 0:
           return False
       lastWord = newStr[-1]
       if lastWord == ';':
           return True
       else:
           return False
    def find_last(string, str):
        last_position = -1
        while True:
            position = string.find(str, last_position + 1)
            if position == -1:
                return last_position
            last_position = position


    def getLjCodeTagWithIndex(self,index):
        str = ('//{}codeTag_{}\n'.format(self.addPrefixStr, index))
        print(str)
        return str
    def getLjCodeTag(self):
        str = ('//{}code_{}\n'.format(self.addPrefixStr, random.randint(2, self.maxTag+1)))
        print(str)
        return str

    def getLjPTypeStr(self):
        index  = random.randint(1, 6)
        if index == 1:
            str = ('@property (nonatomic, strong) NSString * {}Str;\n'.format( self.getMethonName(self.methodNameArray,self.addPrefixStr,2)))
            return str
        elif index == 2:
            str = ('@property (nonatomic, assign) BOOL  {};\n'.format( self.getMethonName(self.methodNameArray,self.addPrefixStr,2)))
            return str
        elif index == 3:
            str = ('@property (nonatomic, assign) NSInteger  {};\n'.format( self.getMethonName(self.methodNameArray,self.addPrefixStr,2)))
            return str
        elif index == 4:
            str = ('@property (nonatomic, strong) NSArray * {}Arr;\n'.format( self.getMethonName(self.methodNameArray,self.addPrefixStr,2)))
            return str
        elif index == 5:
            str = ('@property (nonatomic, strong) NSNumber * {};\n'.format( self.getMethonName(self.methodNameArray,self.addPrefixStr,2)))
            return str
        else:
            str = ('@property (nonatomic, strong) NSDictionary * {}Dic;\n'.format( self.getMethonName(self.methodNameArray,self.addPrefixStr,2)))
            return str



    def getLjPropertyArr(self,PArrCount):
        pArr = []
        pCount =  PArrCount
        if pCount == 0:
            return pArr
        if pCount*1>self.maxPropertyCount:
            locals()
            pCount = self.maxPropertyCount
        elif pCount*1<=1:
            locals()
            pCount = 1
        else:
            pCount = int(pCount*1)
        i = 0
        while i < pCount:
            str = self.getLjPTypeStr()
            pArr.append(str)
            i = i+1
        return pArr



    def getKBCreateFunc(self):
        funcName = self.getMethonName(self.methodNameArray,self.addPrefixStr,3)
        funcStr = '- (void)'+funcName+'{\n';
        codeArr = []
        codeArr.append(funcStr)
        codeArr.append('//newCreate \n')
        codeArr.append('\n')
        codeArr.append('}\n')
        return codeArr
    def getCreateFunc(self):
        funcName = self.getMethonName(self.methodNameArray,self.addPrefixStr,3)
        funcStr = ('- (void){} {\n'.format( funcName))
        codeArr = []
        codeArr.append(funcStr)
        newArr = self.getLjFuncArr()
        codeArr.extend(newArr)
        codeArr.append('}\n')
        return codeArr

    def getLjFuncArr(self):
        ljFuncArr = []
        codeArr = []
        isStartAdd = False
        dicArr = []
        khCount = - 1
        for codeStr in self.garbageMethodArray:
            locals()
            # print(codeStr)
            if isStartAdd == True:
                codeArr.append(codeStr)
            if '{' in codeStr:
                if khCount == -1:
                    khCount = 0
                    isStartAdd = True
                khCount = khCount + codeStr.count('{')
            if '}' in codeStr:
                khCount = khCount - codeStr.count('}')
                if khCount == 0:
                    isStartAdd = False
                    khCount = -1
                    codeArr.pop()
                    ljFuncArr.append(codeArr)
                    codeArr = []
        index = random.randint(0, len(ljFuncArr) - 1)
        newArr = list(ljFuncArr[index])
        newArr.insert(0,self.getLjCodeTagWithIndex(index))
        return newArr

    def generate_code(self,code_len=4):
        all_charts = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
        last_pos = len(all_charts) - 1
        code = ''
        for _ in range(code_len):
            index = random.randint(0, last_pos)
            code += all_charts[index]
        return code

    def getMethonName(self,arr,name,maxCount):
       maxWord = random.randint(1, maxCount)
       i = 0
       newWord =''
       while i < maxWord:
           index = random.randint(0, len(arr)-1)
           newWord=newWord+arr[index].replace('\n','').replace('\r','')
           i += 1
       outputStr = name+newWord
       if maxWord == 1:
           outputStr = outputStr+self.generate_code(2)
       return outputStr


    def startInputData(self):
        self.methodNamePath = os.path.dirname(__file__)+'/methodName.txt'
        self.garbageMethodPath = os.path.dirname(__file__)+'/GarbageMethod.m'
        methodNamefile = open(self.methodNamePath,'r');
        self.methodNameArray = methodNamefile.readlines()
        if(len(self.methodNameArray) == 0):
            print("error:路径下methodName.txt异常")
            return
        garbageMethodfile = open(self.garbageMethodPath,'r');
        self.garbageMethodArray = garbageMethodfile.readlines()
        if(len(self.garbageMethodArray) == 0):
            print("error:路径下garbageMethod.m异常")
            return
        print("常规混淆完毕之后再用(换完前缀)，提交下代码！代码玩坏别找我。暂支持OC")

        print('目录下GarbageMethod.m为垃圾代码模版，若要替换为自己的垃圾代码请严格按照模版格式,记得使用if永不实现这块垃圾代码，也可直接使用，了解请扣1')
        tipStr = input().strip()
        if tipStr != '1':
            print('为了代码安全，没扣1，停止混淆')
            return
        print("全局搜 \"垃圾前缀codeTag_x\" 如'zzkagoLjcodeTag_1'为垃圾代码插入的位置，相同的_x为相同的垃圾代码")
        print("输入垃圾代码前缀，建议\"包名+字符\" 如：zzkagoLj,与正常代码区分")
        self.addPrefixStr = input().strip()
        if(len(self.addPrefixStr)==0):
            print("error:需输入垃圾代码前缀>0")
            return
        print(self.addPrefixStr)
        print("拖入文件夹路径")
        self.prefixPath = input().strip()
        if(len(self.prefixPath)==0):
            print("error:需输入文件夹路径>0")
            return
        print(self.prefixPath)
        # codefile = open(self.prefixPath, 'r');
        # self.codeArr = codefile.readlines()
        # print("拖入路径下methodName.txt文件")
        # self.methodNamePath = input().strip()
        # if(len(self.methodNamePath)==0):
        #     print("error:拖入路径下methodName.txt文件路径>0")
        #     return
        # print(self.methodNamePath)
        self.goConfusion()
    def goConfusion(self):
        for root, dirs, files in os.walk(self.prefixPath):
            for file in files:
                path = os.path.join(root, file)
                bool = path.endswith(".m")

                # print(path)
                if bool == True :
                    self.allMPathArr.append(path)
        for mPath in self.allMPathArr:
            self.goParse(mPath)
    def goParse(self,mPath):  #识别和提取 打乱输出 m文件
        self.hLjnameArr = []
        print(mPath)
        codefile = open(mPath, 'r');
        codeArr = codefile.readlines()
        #allCodeArr 所有@implementation
        allCodeArr = []
        #oneCodeArr 单个@implementation
        oneCodeArr = []
        #codeNameStr @implementation name
        codeNameStr = ''
        completeArr = []
        headeripArr = []
        isStart = False
        for codeStr in codeArr:
            if '#import' in codeStr:
                headeripArr.append(codeStr)
            oneCodeArr.append(codeStr)
            if '@implementation' in codeStr:
               locals()
               codeName = codeStr.replace('@implementation','').rstrip('\n').strip()
               codeNameStr = codeName
               print(codeName)
               isStart = True
            if '@end' in codeStr:
                locals()
                if isStart == True:
                    allCodeArr.append({codeNameStr:oneCodeArr})
                    codeNameStr=''
                    oneCodeArr=[]
                    isStart = False
        # print(allCodeArr)
        endArrInArr = []
        for dic in allCodeArr:
            for arr in dic.values():
                oneCodeStrArr = []
                isStartOneCodeFunc = False
                isIfend = False
                isImp = False
                allFuncArr = []
                funcArr = []
                khCount = -1
                isFunczhushi = False
                for str in arr:
                    locals()
                    if '/*' in str and '/*' == str.replace(' ','')[0:2]:
                        if isStartOneCodeFunc == True:
                            funcArr.append(str)
                            continue;
                        oneCodeStrArr.append(str)
                        isFunczhushi = True
                        if '*/' in str :
                            print(str)
                            zIndex = str.find('*/')
                            zsStr = str[zIndex:].replace(' ','').replace('\n','')
                            if zsStr == '*/':
                                isFunczhushi = False
                        continue
                    if '*/' in str and '*/' == str.replace(' ','')[0:2]:
                        if isStartOneCodeFunc == True:
                            funcArr.append(str)
                            continue;
                        oneCodeStrArr.append(str)
                        isFunczhushi = False
                        continue
                    if isFunczhushi == True:
                        if isStartOneCodeFunc == True:
                            funcArr.append(str)
                            continue;
                        oneCodeStrArr.append(str)
                        continue
                    # completeArr.append(str)
                    if isStartOneCodeFunc == False:
                        # if re.match('//', str):
                        #     oneCodeStrArr.append(str)
                        #     continue
                        # matchStr = '/*'
                        # if re.match(matchStr, str):
                        #     oneCodeStrArr.append(str)
                        #     isFunczhushi = True
                        #     continue
                        # matchStr = '*/'
                        # if re.match(matchStr,str):
                        #     oneCodeStrArr.append(str)
                        #     isFunczhushi = False
                        #     continue
                        # if isFunczhushi == True:
                        #     oneCodeStrArr.append(str)
                        #     continue
                        if '@implementation' in str:
                            isImp = True
                        if isImp == False:
                            oneCodeStrArr.append(str)
                            continue

                        if '-(' in str.replace(' ','') or '+(' in str.replace(' ',''):
                            locals()
                            if isIfend == True:
                                oneCodeStrArr.append(str)
                                continue
                            if re.match('//', str):
                                oneCodeStrArr.append(str)
                                continue
                            isStartOneCodeFunc = True
                            funcArr.append(str)
                            if '{'in str:
                                if khCount == -1:
                                    khCount = 0
                                khCount = khCount + str.count('{')
                                xgIndex = str.find('//')
                                yhIndex = str.find('"',xgIndex + 1)
                                newStr = str[xgIndex:]
                                print(newStr)
                                if newStr.count('{') > 0 and yhIndex == -1:
                                    khCount = khCount - newStr.count('{')

                            if '}' in str:
                                khCount = khCount - str.count('}')
                                xgIndex = str.find('//')
                                yhIndex = str.find('"',xgIndex + 1)
                                newStr = str[xgIndex:]
                                print(newStr)
                                if newStr.count('}')> 0 and yhIndex == -1:
                                    khCount = khCount + newStr.count('}')
                            if khCount == 0:
                                locals()
                                khCount = -1
                                allFuncArr.append(funcArr)
                                funcArr = []
                                isStartOneCodeFunc = False
                        else:
                            locals()
                            if re.match('#if', str):
                                isIfend = True
                                oneCodeStrArr.append(str)
                                continue
                            if re.match('#endif', str):
                                isIfend = False
                                oneCodeStrArr.append(str)
                                continue
                            if isIfend == True:
                                oneCodeStrArr.append(str)
                                continue
                            oneCodeStrArr.append(str)
                    else:
                        locals()
                        funcArr.append(str)
                        if re.match('//', str):
                            continue
                        if '{' in str:
                            if khCount == -1:
                                khCount = 0
                            khCount = khCount + str.count('{')
                            xgIndex = str.find('//')
                            yhIndex = str.find('"', xgIndex + 1)
                            newStr = str[xgIndex:]
                            print(newStr)
                            if newStr.count('{') > 0 and yhIndex == -1:
                                khCount = khCount - newStr.count('{')
                        if '}' in str:
                            khCount = khCount - str.count('}')
                            xgIndex = str.find('//')
                            yhIndex = str.find('"', xgIndex + 1)
                            newStr = str[xgIndex:]
                            print(newStr)
                            if newStr.count('}') > 0 and yhIndex == -1:
                                khCount = khCount + newStr.count('}')
                        if khCount == 0:
                            locals()
                            khCount = -1
                            allFuncArr.append(funcArr)
                            funcArr = []
                            isStartOneCodeFunc = False
                # print(allFuncArr)
                # print(allFuncArr)
                # 在这里处理复制方法改名加垃圾代码

                allFuncArr = self.addFunc(allFuncArr,codeName)
                #在这里处理m文件里拓展里的属性（后期看时间是否优化）

                # print(allFuncArr)
                random.shuffle(allFuncArr)
                lastWord = oneCodeStrArr.pop()
                if '@end' in lastWord:
                    oneCodeStrArr.extend(allFuncArr)
                    oneCodeStrArr.append(lastWord)
                    for obj in oneCodeStrArr:
                        if isinstance(obj,list):
                            for objStr in obj:
                                endArrInArr.append(objStr)
                        else:
                            endArrInArr.append(obj)

        # print(oneCodeArr)
        for objCode in oneCodeArr:
            endArrInArr.append(objCode)
        newFile = open(mPath, 'w')
        newFile.writelines(endArrInArr)
        newFile.close()
        self.goHParse(mPath,self.hLjnameArr,headeripArr)



    def addFunc(self,funcArr,impName):
        if len(funcArr)== 0:
            return funcArr
        # print(funcArr)
        funcount = len(funcArr)
        if funcount == 0:
            return funcArr
        if funcount/2>self.maxFunc:
            locals()
            funcount = self.maxFunc
        elif funcount/2<=1:
            locals()
            funcount = 1
        else:
            funcount = int(funcount/2)
        i = 0
        ljFuncArr = []
        ljReNameFuncArr = []
        ljFuncNameArr = []
        less3Count = 0
        oldIndexArr = []
        isOver = False
        while i<funcount:
            locals()
            index = random.randint(0, len(funcArr) - 1)
            if len(oldIndexArr):
                while 1 :
                    isBreak = True
                    for oldIndex in oldIndexArr:
                         if index == oldIndex:
                             isBreak = False
                    if isBreak == True:
                        oldIndexArr.append(index)
                        break
                    else:
                        index = random.randint(0, len(funcArr) - 1)
                        if (len(oldIndexArr) == len(funcArr)):
                            isOver = True
                            break
            else:
                oldIndexArr.append(index)

            if isOver == True:
                break

            arr = list(funcArr[index])
            if(len(arr)<=3):
                less3Count = less3Count + 1
                if (len(funcArr)==less3Count):
                    break
                continue
            ljFuncArr.append(arr)
            i=i+1
        if len(ljFuncArr):
            ljIx = 0
            while ljIx < 2:
                ljNewfA = self.getKBCreateFunc()
                ljFuncArr.append(ljNewfA)
                ljIx = ljIx + 1

        for codeArr in ljFuncArr:
            isAdd =  random.randint(0, 3)
            if isAdd>0:
                isKyAddCode = False
                kyIndex = len(codeArr)
                isFristInSert = True
                if isAdd < 3:
                    kyIndex = -1
                for codeStr in codeArr:
                    if '-(void)' in codeStr.replace(' ','') or '+(void)' in codeStr.replace(' ',''):
                        isFristInSert = False
                    if isFristInSert == False:
                        if isAdd < 3:
                            kyIndex = kyIndex + 1
                            if isKyAddCode == True:
                                # tag = self.getLjCodeTag()
                                # codeArr.insert(kyIndex, tag)
                                ljNewFuncArr = self.getLjFuncArr()
                                while len(ljNewFuncArr):
                                    codeArr.insert(kyIndex,ljNewFuncArr.pop())
                                break
                            if '{' in codeStr:
                                isKyAddCode = True
                                continue
                        else:
                            kyIndex = kyIndex - 1
                            if '}' in codeArr[kyIndex]:
                                # tag = self.getLjCodeTag()
                                # codeArr.insert(kyIndex, tag)
                                ljNewFuncArr = self.getLjFuncArr()
                                while len(ljNewFuncArr):
                                    codeArr.insert(kyIndex,ljNewFuncArr.pop())
                                break
                    else:
                        if kyIndex == len(codeArr):
                            kyIndex = -1

                        kyIndex = kyIndex + 1
                        if isKyAddCode == True:
                            # tag = self.getLjCodeTag()
                            # codeArr.insert(kyIndex, tag)
                            ljNewFuncArr = self.getLjFuncArr()
                            while len(ljNewFuncArr):
                                codeArr.insert(kyIndex, ljNewFuncArr.pop())
                            break
                        if '{' in codeStr:
                            isKyAddCode = True
                            continue

            result = ''.join(codeArr)
            endIndex = result.find("{")
            funcAllName = result[0:endIndex]
            startfuncIndex = funcAllName.find(")")
            endfuncIndex = funcAllName.find(":")
            key = ""
            print(funcAllName)
            if(endfuncIndex == -1):
                key = funcAllName[startfuncIndex + 1:].replace(" ", "")
            else:
                key = funcAllName[startfuncIndex + 1:endfuncIndex].replace(" ", "")
            value = self.getMethonName(self.methodNameArray,self.addPrefixStr,3)
            if 'init' in funcAllName:
                continue

            # if 'collectionView' in funcAllName:
            #     continue
            # if 'tableView' in funcAllName:
            #     continue
            # print(key)
            funcAllNameValue = funcAllName.replace(key,value,1)
            if ':' not in funcAllNameValue and '(void)' in funcAllNameValue.replace(' ',''):
                ljFuncNameArr.append(funcAllNameValue + ';\n')
            # ljFuncNameArr.append(funcAllNameValue + ';\n')
            print(funcAllNameValue)
            result = result.replace(funcAllName,funcAllNameValue)
            array = result.split('\n')
            newArr = []
            for str in array:
                newArr.append(str+"\n")
            ljReNameFuncArr.append(newArr)


        funNorCount = len(funcArr)
        if funNorCount == 0:
            return funcArr
        if funNorCount / 2 > self.maxNorFunc:
            locals()
            funNorCount = self.maxNorFunc
        elif funNorCount / 2 <= 1:
            locals()
            funNorCount = 1
        else:
            funNorCount = int(funNorCount / 2)
        i = 0
        less3Count = 0
        oldIndexArr = []
        isOver = False
        while i<funNorCount:
            locals()
            index = random.randint(0, len(funcArr) - 1)
            if len(oldIndexArr):
                while 1 :
                    isBreak = True
                    for oldIndex in oldIndexArr:
                         if index == oldIndex:
                             isBreak = False
                    if isBreak == True:
                        oldIndexArr.append(index)
                        break
                    else:
                        index = random.randint(0, len(funcArr) - 1)
                        if (len(oldIndexArr) == len(funcArr)):
                            isOver = True
                            break
            else:
                oldIndexArr.append(index)
            if (isOver == True):
                break

            print(('funNorCount:{}').format(funNorCount))
            print(('oldIndexArr:{}').format(oldIndexArr))
            print(('index:{}').format(index))

            arr = list(funcArr[index])
            if(len(arr)<=3):
                less3Count = less3Count + 1
                if (len(funcArr)==less3Count):
                    break
                continue


            isNorAdd = random.randint(0, 3)
            if isNorAdd > 0:
                isKyAddCode = False
                kyIndex = len(arr)
                isFristInSert = True
                if isNorAdd < 3:
                    kyIndex = -1
                for codeStr in arr:
                    if '-(void)' in codeStr.replace(' ','') or '+(void)' in codeStr.replace(' ',''):
                        isFristInSert = False
                    if isFristInSert == False:
                        if isNorAdd < 3:
                            kyIndex = kyIndex + 1
                            if isKyAddCode == True:
                                # tag = self.getLjCodeTag()
                                # arr.insert(kyIndex, tag)zzz
                                ljNewFuncArr = self.getLjFuncArr()
                                while len(ljNewFuncArr):
                                    arr.insert(kyIndex,ljNewFuncArr.pop())
                                break
                            if '{' in codeStr:
                                isKyAddCode = True
                                continue
                        else:
                            kyIndex = kyIndex - 1
                            if '}' in arr[kyIndex]:
                                # tag = self.getLjCodeTag()
                                # arr.insert(kyIndex, tag)
                                ljNewFuncArr = self.getLjFuncArr()
                                while len(ljNewFuncArr):
                                    arr.insert(kyIndex,ljNewFuncArr.pop())
                                break
                    else:
                        if kyIndex == len(arr):
                            kyIndex = -1
                        kyIndex = kyIndex + 1
                        if isKyAddCode == True:
                            # tag = self.getLjCodeTag()
                            # arr.insert(kyIndex, tag)
                            ljNewFuncArr = self.getLjFuncArr()
                            while len(ljNewFuncArr):
                                arr.insert(kyIndex, ljNewFuncArr.pop())
                            break
                        if '{' in codeStr:
                            isKyAddCode = True
                            continue
                funcArr[index] = arr
                i=i+1

        ljFuncDic = {impName.replace(' ',''):ljFuncNameArr}
        self.hLjnameArr.append(ljFuncDic)
        funcArr.extend(ljReNameFuncArr)
            # print(funcArr)
        return funcArr

    def goHParse(self,mPath,keyWordArr,addIPClassArr):
        hPath=str(mPath).replace('.m','.h')
        isHavePath = os.path.exists(hPath)
        if isHavePath == False:
            print('不存在:'+hPath)
            return
        print(hPath)
        codefile = open(hPath, 'r');
        codeArr = codefile.readlines()
        if (len(codeArr) == 0):
            print('为空:'+hPath)
            return
        allFuncArr = []
        oneInterArr = []
        funcArr = []
        codeStrArr = []
        attributeArr = []
        isStart = False
        interName = ''
        endCodeArr = []

        # endCodeArr.extend(addIPClassArr)

        for codeStr in codeArr:
            locals()
            oneInterArr.append(codeStr)
            if '@interface' in codeStr or '@protocol' in codeStr:
                isStart = True
                if '@protocol' in codeStr:
                    interName = codeStr.replace('@protocol','').replace(' ','')
                    print(interName)
                if '@interface' in codeStr and ':' in codeStr:
                    name = codeStr.replace('@interface','').replace(' ','')
                    endIndex = name.find(':')
                    interName = name[:endIndex]
                    print(interName)
                if '@interface' in codeStr and '(' in codeStr:
                    interName = codeStr.replace('@interface','').replace(' ','')
                    print(interName)
            if '@end' in codeStr:
                if isStart == True:
                   allFuncArr.append({interName:oneInterArr})
                   isStart = False
                   oneInterArr=[]
                   interName=''


        for allAic in allFuncArr:
            for key in allAic:
                arr = list(allAic[key])
                isAddP = False
                isAddF = False
                pArr = []
                endPArr = []
                fArr = []
                endFArr = []
                newCodeStr = ''
                isInter = False
                isZhuShi = False
                for codeStr in arr:

                    if '@interface' in codeStr or '@protocol' in codeStr:
                        isInter = True
                    if isInter == False:
                        codeStrArr.append(codeStr)
                        continue
                    if re.match('//', codeStr) :
                        codeStrArr.append(codeStr)
                        continue
                    if '/*' in codeStr:
                        codeStrArr.append(codeStr)
                        isZhuShi = True
                        continue
                    if '*/' in codeStr:
                        codeStrArr.append(codeStr)
                        isZhuShi = False
                        continue
                    if isZhuShi == True:
                        codeStrArr.append(codeStr)
                        continue
                    if '@property' in codeStr:
                        pArr.append(codeStr)
                        isAddP = True
                        if self.isEndFh(codeStr):
                            endPArr.append(pArr)
                            pArr = []
                            isAddP = False
                        continue
                    if '-(' in str(codeStr).replace(' ', '') or '+(' in str(codeStr).replace(' ', ''):
                        fArr.append(codeStr)
                        isAddF = True
                        if self.isEndFh(codeStr):
                            endFArr.append(fArr)
                            fArr = []
                            isAddF = False
                        continue
                    if self.isEndFh(codeStr):
                        if isAddF == False and isAddP == False:
                            codeStrArr.append(codeStr)
                            continue;
                        if isAddP == True:
                            pArr.append(codeStr)
                            endPArr.append(pArr)
                            pArr = []
                            isAddP = False
                        if isAddF == True:
                            fArr.append(codeStr)
                            endFArr.append(fArr)
                            fArr = []
                            isAddF = False
                        continue
                    if isAddF == True:
                        fArr.append(codeStr)
                        continue
                    if isAddP == True:
                        pArr.append(codeStr)
                        continue
                    codeStrArr.append(codeStr)

                if len(endPArr) > 0:
                    endPArr.extend(self.getLjPropertyArr(len(endPArr)))

                for dic in keyWordArr:
                    for ljKey in dic:
                        if str(ljKey).replace('\n','').replace(' ','') == str(key).replace('\n','').replace(' ',''):
                            ljFuncWithDicArr = list(dic[ljKey])
                            endFArr.extend(ljFuncWithDicArr)
                            break

                random.shuffle(endPArr)
                random.shuffle(endFArr)
                endPAndFCodeStrArr = []
                for codePArr in endPArr:
                    for codePStr in codePArr:
                        endPAndFCodeStrArr.append(codePStr)
                for codeFArr in endFArr:
                    for codeFStr in codeFArr:
                        endPAndFCodeStrArr.append(codeFStr)
                lastWord = codeStrArr.pop()
                if '@end' in lastWord:
                    codeStrArr.extend(endPAndFCodeStrArr)
                    codeStrArr.append(lastWord)
                endCodeArr.extend(codeStrArr)
                codeStrArr = []
        endCodeArr.extend(oneInterArr)

        newFile = open(hPath, 'w')
        newFile.writelines(endCodeArr)
        newFile.close()























tool = ConfusionTool()
tool.startInputData()