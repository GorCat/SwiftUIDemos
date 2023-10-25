import re
import os
import sys
import random

class ConfusionTool:
    prefixPath = ''
    allPathArr = []
    allTagArr = ['@Protected','@discardableResult','@propertyWrapper','@dynamicMemberLookup','@objc','@_disfavoredOverload','open','public','internal','fileprivate','private','@objcMembers']
    allTagZSArr = ['@Protected//','@discardableResult//','@propertyWrapper//','@dynamicMemberLookup//','@objc//','@_disfavoredOverload//','open//','public//','internal//','fileprivate//','private//','@objcMembers//']
    addPrefixStr = 'zzkago'
    methodNameArray = []
    methodNamePath = ''
    garbageMethodPath = ''
    garbageMethodArray = []
    maxPropertyCount = 10
    maxFuncCount = 2

    def startInputData(self):
        self.methodNamePath = os.path.dirname(__file__)+'/methodName.txt'
        self.garbageMethodPath = os.path.dirname(__file__)+'/GarbageMethod.swift'
        methodNamefile = open(self.methodNamePath,'r');
        self.methodNameArray = methodNamefile.readlines()
        if(len(self.methodNameArray) == 0):
            print("error:路径下methodName.txt异常")
            return

        garbageMethodfile = open(self.garbageMethodPath,'r');
        self.garbageMethodArray = garbageMethodfile.readlines()
        if(len(self.garbageMethodArray) == 0):
            print("error:路径下garbageMethod.swift异常")
            return

        print("常规混淆完毕之后再用(换完前缀)，提交下代码！代码玩坏别找我。SWIFT版本，不支持SwiftUI,勿混SwiftUI相关代码")
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
        self.goConfusion()
    def getCreateFunc(self):
        funcName = self.getMethonName(self.methodNameArray,self.addPrefixStr,3)
        funcStr = ('func {}'.format( funcName))
        funcStr = funcStr+"(){\n"
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
    def getLjCodeTagWithIndex(self,index):
        str = ('//{}codeTag_{}\n'.format(self.addPrefixStr, index))
        return str
    def getLjPropertyArr(self,SXArr):
        pCount =  len(SXArr)
        if pCount == 0:
            return SXArr
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
            pArr = []
            str = self.getLjPTypeStr()
            pArr.append(str)
            i = i+1
            SXArr.append(pArr)
        return SXArr
    def getLjPTypeStr(self):
        index  = random.randint(1, 6)
        if index == 1:
            str = ('var {}:String?\n'.format( self.getMethonName(self.methodNameArray,self.addPrefixStr,2)))
            return str
        elif index == 2:
            str = ('var {}:Bool?\n'.format( self.getMethonName(self.methodNameArray,self.addPrefixStr,2)))
            return str
        elif index == 3:
            str = ('var {}:CGFloat?\n'.format( self.getMethonName(self.methodNameArray,self.addPrefixStr,2)))
            return str
        elif index == 4:
            str = ('var {}:Double?\n'.format( self.getMethonName(self.methodNameArray,self.addPrefixStr,2)))
            return str
        elif index == 5:
            str = ('var {}:Float?\n'.format( self.getMethonName(self.methodNameArray,self.addPrefixStr,2)))
            return str
        else:
            str = ('var {}:[Int] = [0,1,0,1]\n'.format( self.getMethonName(self.methodNameArray,self.addPrefixStr,2)))
            return str
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


    def goConfusion(self):
        locals()
        for root, dirs, files in os.walk(self.prefixPath):
            for file in files:
                path = os.path.join(root, file)
                bool = path.endswith(".swift")

                # print(path)
                if bool == True :
                    self.allPathArr.append(path)
        index = 1
        allIndex = len(self.allPathArr)
        for swiftPath in self.allPathArr:
            print(swiftPath)
            print(index/allIndex)
            if (index == allIndex):
                print('完成')
            index = index + 1
            self.goParse(swiftPath)
    def goParse(self,swiftPath):
        codefile = open(swiftPath, 'r');
        codeArr = codefile.readlines()
        allCodeArr = []
        oneCodeArr = []
        structCodeArr = []
        exCodeArr = []
        isStartClass = False
        isStartStruct = False
        isStartEX = False
        tagArr = []

        khCount = 0
        sKhCount = 0
        eKhCount = 0
        isFunczhushi = False

        for codeStr in codeArr:
            if ('//' in codeStr.replace(' ', '').replace('\n', '')[0:2]):
                # allCodeArr.append(codeStr)
                continue

            if '/*' in codeStr and '/*' == codeStr.replace(' ', '').replace('\n','')[0:2]:
                    isFunczhushi = True
                    if '*/' in codeStr:
                        zIndex = codeStr.find('*/')
                        zsStr = codeStr[zIndex:].replace(' ', '').replace('\n', '')
                        if zsStr == '*/':
                            # allCodeArr.append(codeStr)
                            isFunczhushi = False
                            continue

            if '*/' in codeStr and '*/' == codeStr.replace(' ', '').replace('\n','')[0:2]:
                    # allCodeArr.append(codeStr)
                    isFunczhushi = False
                    continue

            if isFunczhushi == True:
                # allCodeArr.append(codeStr)
                continue

            newYcodeStr = self.getNoYHStr(codeStr)

            if 'class ' in newYcodeStr and isStartStruct == False and isStartEX == False and (('protocol ' in newYcodeStr)==False):
                locals()
                if ('//' in codeStr.replace(' ', '').replace('\n', '')[0:2]) and isStartClass == False:
                    allCodeArr.append(codeStr)
                    continue
                isStartClass = True
                if len(tagArr)>0:
                    oneCodeArr.extend(tagArr)
                    tagArr = []
                oneCodeArr.append(codeStr)
                if "{" in codeStr:
                    khCount = self.getAddKHCount(khCount,codeStr)
                if khCount == 0:
                    khCount = -1
                if "}" in codeStr:
                    khCount = self.getJianKHCount(khCount,codeStr)
                continue
            if isStartClass == True:
                locals()
                oneCodeArr.append(codeStr)
                if "{" in codeStr:
                    if khCount == -1:
                        khCount = 0
                    khCount = self.getAddKHCount(khCount,codeStr)
                if "}" in codeStr:
                    khCount = self.getJianKHCount(khCount,codeStr)
                    # print(khCount)
                if khCount == 0:
                    isStartClass = False
                    newClassArr = self.goClassParse(oneCodeArr)
                    # for code in newClassArr:
                    #     if isinstance(code, list):
                    #         for codeStr in code:
                    #             allCodeArr.append(codeStr)
                    #     else:
                    #         allCodeArr.append(code)

                    allCodeArr.append(newClassArr)
                    # print(newClassArr)
                    oneCodeArr = []
                    continue
            if isStartClass == False:
                if 'extension ' in newYcodeStr and isStartStruct == False:
                    locals()
                    if ('//' in codeStr.replace(' ', '').replace('\n', '')[0:2]) and isStartEX == False:
                        allCodeArr.append(codeStr)
                        continue
                    isStartEX = True
                    if len(tagArr) > 0:
                        exCodeArr.extend(tagArr)
                        tagArr = []
                    exCodeArr.append(codeStr)
                    if "{" in codeStr:
                        eKhCount = self.getAddKHCount(eKhCount,codeStr)
                    if eKhCount == 0:
                        eKhCount = -1
                    if "}" in codeStr:
                        eKhCount = self.getJianKHCount(eKhCount,codeStr)
                    if eKhCount == 0:
                        isStartEX = False
                        newClassArr = self.goClassParse(exCodeArr,True,False)
                        # for code in newClassArr:
                        #     if isinstance(code, list):
                        #         for codeStr in code:
                        #             allCodeArr.append(codeStr)
                        #     else:
                        #         allCodeArr.append(code)
                        allCodeArr.append(newClassArr)

                        exCodeArr = []
                        continue
                    continue
                if isStartEX == True:
                    locals()
                    exCodeArr.append(codeStr)
                    if "{" in codeStr:
                        if eKhCount == -1:
                            eKhCount = 0
                        eKhCount = self.getAddKHCount(eKhCount,codeStr)
                    if "}" in codeStr:
                        eKhCount = self.getJianKHCount(eKhCount,codeStr)
                    if eKhCount == 0:
                        isStartEX = False

                        newClassArr = self.goClassParse(exCodeArr,True,False)

                        # for code in newClassArr:
                        #     if isinstance(code, list):
                        #         for codeStr in code:
                        #             allCodeArr.append(codeStr)
                        #     else:
                        #         allCodeArr.append(code)
                        allCodeArr.append(newClassArr)

                        exCodeArr = []
                        continue



                if 'struct ' in newYcodeStr and isStartEX == False:

                    locals()
                    if ('//' in codeStr.replace(' ', '').replace('\n', '')[0:2]) and isStartStruct == False:
                        allCodeArr.append(codeStr)
                        continue
                    isStartStruct = True
                    if len(tagArr) > 0:
                        structCodeArr.extend(tagArr)
                        tagArr = []
                    structCodeArr.append(codeStr)
                    if "{" in codeStr:
                        sKhCount = self.getAddKHCount(sKhCount,codeStr)
                    if sKhCount == 0:
                        sKhCount = -1
                    if "}" in codeStr:
                        sKhCount = self.getJianKHCount(sKhCount,codeStr)
                    if sKhCount == 0:
                        isStartStruct = False
                        newClassArr = self.goClassParse(structCodeArr)
                        # for code in newClassArr:
                        #     if isinstance(code, list):
                        #         for codeStr in code:
                        #             allCodeArr.append(codeStr)
                        #     else:
                        #         allCodeArr.append(code)

                        allCodeArr.append(newClassArr)
                        structCodeArr = []
                        continue
                    continue
                if isStartStruct == True:
                    structCodeArr.append(codeStr)
                    locals()
                    if "{" in codeStr:
                        if sKhCount == -1:
                            sKhCount = 0
                        sKhCount = self.getAddKHCount(sKhCount,codeStr)
                    if "}" in codeStr:
                        sKhCount = self.getJianKHCount(sKhCount,codeStr)
                    if sKhCount == 0:
                        isStartStruct = False
                        newClassArr = self.goClassParse(structCodeArr,False)
                        # for code in newClassArr:
                        #     if isinstance(code, list):
                        #         for codeStr in code:
                        #             allCodeArr.append(codeStr)
                        #     else:
                        #         allCodeArr.append(code)

                        allCodeArr.append(newClassArr)
                        # print(newClassArr)
                        structCodeArr = []
                        continue
                if isStartEX == False and isStartStruct == False and isStartEX == False:
                    newCodeStr = codeStr.replace(' ', '').replace('\n', '')
                    newCodeStr = self.getNoYHStr(newCodeStr)
                    if any(words == newCodeStr for words in self.allTagArr) == True:
                        tagArr.append(codeStr)

                        continue
                    if any(words == newCodeStr for words in self.allTagZSArr) == True:
                        tagArr.append(codeStr)
                        continue
                    if '@available' in newCodeStr and '@available' == newCodeStr[0:10]:
                        tagArr.append(codeStr)
                        continue
                    if '@objc(' in newCodeStr and '@objc(' == newCodeStr[0:6]:
                        tagArr.append(codeStr)
                        continue

                    if ('publicprotocol' in newCodeStr[0:14]) or ('protocol' in newCodeStr[0:8]) or ('openprotocol' in newCodeStr[0:12]) \
                            or ('internalprotocol' in newCodeStr[0:8])\
                            or ('enum' in newCodeStr[0:4])\
                            or ('internalenum' in newCodeStr[0:12])\
                            or ('openenum' in newCodeStr[0:8])\
                            or ('publicenum' in newCodeStr[0:10]):
                        if len(tagArr) > 0:
                            allCodeArr.extend(tagArr)
                            tagArr = []
                    allCodeArr.append(codeStr)
        endCodeArr = []
        isAllCodeStrBool = True
        for code in allCodeArr:
            if isinstance(code, list):
                isAllCodeStrBool = False
                for codenewStr in code:
                    if isinstance(codenewStr, list):
                        for codenew2Str in codenewStr:
                            endCodeArr.append(codenew2Str)
                    else:
                        endCodeArr.append(codenewStr)
            else:
                endCodeArr.append(code)
        if isAllCodeStrBool:
            endCodeArr = self.goStartMacroParse(endCodeArr)
        newFile = open(swiftPath, 'w')
        newFile.writelines(endCodeArr)
        newFile.close()

    def goClassParse(self,classCodeStrArr,sxdlBool = True,isAddXSBool = True):
        allCodeArr = []
        startCodeArr = []
        isStart = False
        isEnd = False
        khCount = 0
        # print(classCodeStrArr)
        for codeStr in classCodeStrArr:
            locals()
            if isStart == True and isEnd == False:
                startCodeArr.append(codeStr)
            if isStart == False and isEnd == False:
                allCodeArr.append(codeStr)
            if "{" in codeStr:
                khCount = self.getAddKHCount(khCount,codeStr)
                isStart = True
            if "}" in codeStr:
                khCount = self.getJianKHCount(khCount,codeStr)
                # print(khCount)
            if khCount == 0 and isStart == True:
                if len(startCodeArr) == 0:
                    continue
                startCodeArr.pop()

                newArr = self.goStartFuncAndSXParse(startCodeArr,sxdlBool,isAddXSBool)

                allCodeArr.append(newArr)
                allCodeArr.append(codeStr)

        # print(startCodeArr)
        # print(allCodeArr)
        return allCodeArr
    def goStartFuncAndSXParse(self,CodeStrArr,sxdlBool = True,isAddXSBool = True):
        allCodeArr = []
        funcCodeArr = []
        shuxingCodeArr = []
        funcAllCodeArr = []
        shuxingAllCodeArr = []
        tagArr = []
        isInFuncStart = False
        isInSXStart = False
        khCount = 0
        sxKhcount = 0
        isFunczhushi = False
        isJH = False
        funcKHCount = 0

        for codeStr in CodeStrArr:
            locals()
            if '/*' in codeStr and '/*' == codeStr.replace(' ', '').replace('\n','')[0:2]:
                if isInFuncStart == False:
                    isFunczhushi = True
                    if '*/' in codeStr:
                        zIndex = codeStr.find('*/')
                        zsStr = codeStr[zIndex:].replace(' ', '').replace('\n', '')
                        if zsStr == '*/':
                            allCodeArr.append(codeStr)
                            isFunczhushi = False
                            continue

            if '*/' in codeStr and '*/' == codeStr.replace(' ', '').replace('\n','')[0:2]:
                if isInFuncStart == False:
                    allCodeArr.append(codeStr)
                    isFunczhushi = False
                    continue

            if isFunczhushi == True:
                allCodeArr.append(codeStr)
                continue
            if '#if' in codeStr and '#if' == codeStr.replace(' ', '').replace('\n', '')[0:3]:
                if isInFuncStart == False and sxKhcount == 0:
                    isJH = True
                    if '#endif' in codeStr:
                        zIndex = codeStr.find('#endif')
                        zsStr = codeStr[zIndex:].replace(' ', '').replace('\n', '')
                        if zsStr == '#endif':
                            allCodeArr.append(codeStr)
                            isJH = False
                            continue

            if '#endif' in codeStr and '#endif' == codeStr.replace(' ', '').replace('\n', '')[0:6]:
                if isInFuncStart == False and sxKhcount == 0:
                    allCodeArr.append(codeStr)
                    isJH = False
                    continue

            if isJH == True:
                allCodeArr.append(codeStr)
                continue
            newCodeStr = codeStr.replace(' ', '').replace('\n','')
            if any(words == newCodeStr for words in self.allTagArr) == True and isInFuncStart == False:
                tagArr.append(codeStr)
                continue
            if any(words == newCodeStr for words in self.allTagZSArr) == True and isInFuncStart == False:
                tagArr.append(codeStr)
                continue
            if '@available' in newCodeStr and '@available' == newCodeStr[0:10] and isInFuncStart == False:
                tagArr.append(codeStr)
                continue
            if '@objc(' in newCodeStr and '@objc(' == newCodeStr[0:6]:
                tagArr.append(codeStr)
                continue
            newCodeStr = self.getNoYHStr(newCodeStr)
            newYcodeStr = self.getNoYHStr(codeStr)
            if 'func ' in newYcodeStr or 'override ' in newYcodeStr or  'enum ' in newYcodeStr or 'struct ' in newYcodeStr or 'class ' in newYcodeStr or 'convenience ' in newYcodeStr or ('required' in newYcodeStr and 'required' == newYcodeStr.replace(' ', '').replace('\n', '')[0:8]) or ('init' in newYcodeStr and 'init' == newYcodeStr.replace(' ', '').replace('\n', '')[0:4]) \
                    or ('deinit' in newYcodeStr and 'deinit' == newYcodeStr.replace(' ', '').replace('\n', '')[0:6]) \
                    or ('publicinit' in newYcodeStr.replace(' ', '').replace('\n', '')[0:10]) \
                    or ('privateinit' in newYcodeStr.replace(' ', '').replace('\n', '')[0:11]) \
                    or ('fileprivateinit' in  newYcodeStr.replace(' ', '').replace('\n', '')[0:15])\
                    or ('openinit' in newYcodeStr.replace(' ', '').replace('\n', '')[0:8])\
                    or ('internalinit' in newYcodeStr.replace(' ', '').replace('\n', '')[0:12])\
                    or ('publicsubscript' in newYcodeStr.replace(' ', '').replace('\n', '')[0:15])\
                    or ('subscript' in newYcodeStr.replace(' ', '').replace('\n', '')[0:9])\
                    or ('opensubscript' in newYcodeStr.replace(' ', '').replace('\n', '')[0:13])\
                    or ('fileprivatesubscript' in newYcodeStr.replace(' ', '').replace('\n', '')[0:20])\
                    or ('privatesubscript' in newYcodeStr.replace(' ', '').replace('\n', '')[0:16])\
                    or ('@objcpublicinit' in newYcodeStr.replace(' ', '').replace('\n', '')[0:15]):
                if isInSXStart == True:
                    sxKhcount = 0
                    shuxingAllCodeArr.append(shuxingCodeArr)
                    # print(shuxingCodeArr)
                    shuxingCodeArr = []
                if  isInFuncStart == True:
                    funcCodeArr.append(codeStr)
                    if khCount == -2:
                        if "(" in codeStr:
                            funcKHCount = funcKHCount + codeStr.count('(')
                        if ")" in codeStr:
                            funcKHCount = funcKHCount - codeStr.count(')')
                        funcLastkhIndex = 0
                        if funcKHCount == 0:
                            if ')' in codeStr:
                                funcLastkhIndex = codeStr.rindex(")")
                            else:
                                funcLastkhIndex = -1
                            if funcLastkhIndex == -1:
                                if "{" in codeStr:
                                    if khCount == -2:
                                        khCount = 0
                                    khCount = self.getAddKHCount(khCount,codeStr)
                                if "}" in codeStr:
                                    khCount = self.getJianKHCount(khCount,codeStr)
                                    # print(khCount)
                                if khCount == 0:
                                    isInFuncStart = False
                                    funcAllCodeArr.append(funcCodeArr)
                                    # print(funcAllCodeArr)
                                    # print(newClassArr)
                                    funcCodeArr = []
                                    continue
                            else:
                                newStr = codeStr[funcLastkhIndex:]
                                if "{" in newStr:
                                    if khCount == -2:
                                        khCount = 0
                                    khCount = khCount + newStr.count('{')
                                if "}" in codeStr:
                                    khCount = khCount - newStr.count('}')
                                    # print(khCount)
                                if khCount == 0:
                                    isInFuncStart = False
                                    funcAllCodeArr.append(funcCodeArr)
                                    # print(funcAllCodeArr)
                                    # print(newClassArr)
                                    funcCodeArr = []
                                    continue
                        else:
                            continue
                    else:
                        if "{" in codeStr:
                            if khCount == -1:
                                khCount = 0
                            khCount = self.getAddKHCount(khCount,codeStr)
                        if "}" in codeStr:
                            khCount = self.getJianKHCount(khCount,codeStr)
                            # print(khCount)
                        if khCount == 0:
                            isInFuncStart = False
                            funcAllCodeArr.append(funcCodeArr)
                            # print(funcAllCodeArr)
                            # print(newClassArr)
                            funcCodeArr = []
                            continue
                    continue
                if ('//' in codeStr.replace(' ', '').replace('\n', '')[0:2]) and isInFuncStart == False:
                    allCodeArr.append(codeStr)
                    continue
                isInSXStart = False
                isInFuncStart = True
                if len(tagArr)>0:
                    funcCodeArr.extend(tagArr)
                    tagArr = []
                funcCodeArr.append(codeStr)
                if "(" in codeStr:
                    funcKHCount = funcKHCount + codeStr.count('(')
                if ")" in codeStr:
                    funcKHCount = funcKHCount - codeStr.count(')')
                funcLastkhIndex = 0
                if funcKHCount == 0:
                    if ')' in codeStr:
                        funcLastkhIndex = codeStr.rindex(")")
                    else:
                        funcLastkhIndex = -1
                    if funcLastkhIndex == -1:
                        if "{" in codeStr:
                            khCount = self.getAddKHCount(khCount,codeStr)
                        if khCount == 0:
                            khCount = -1
                        if "}" in codeStr:
                            khCount = self.getJianKHCount(khCount,codeStr)
                        if khCount == 0:
                            isInFuncStart = False
                            funcAllCodeArr.append(funcCodeArr)
                            # print(funcAllCodeArr)
                            # print(newClassArr)
                            funcCodeArr = []
                        continue
                    else:
                        newStr = codeStr[funcLastkhIndex:]

                        if "{" in newStr:
                            khCount = khCount + newStr.count('{')
                        if khCount == 0:
                            khCount = -1
                        if "}" in newStr:
                            khCount = khCount - newStr.count('}')
                        if khCount > 0:
                            if ('func ' in newYcodeStr) and (('->' in newCodeStr)==False):
                                isAdd = random.randint(0, 3)
                                if isAdd < 1:
                                    funcCodeArr.extend(self.getLjFuncArr())
                        if khCount == 0:
                            isInFuncStart = False
                            funcAllCodeArr.append(funcCodeArr)
                            # print(funcAllCodeArr)
                            # print(newClassArr)
                            funcCodeArr = []
                        continue
                khCount = -2
                continue




            if isInFuncStart == True:
                locals()
                funcCodeArr.append(codeStr)
                # print(khCount)


                if khCount == -2:
                    if "(" in codeStr:
                        funcKHCount = funcKHCount + codeStr.count('(')
                    if ")" in codeStr:
                        funcKHCount = funcKHCount - codeStr.count(')')
                    funcLastkhIndex = 0
                    if funcKHCount == 0:
                        if ')' in codeStr:
                            funcLastkhIndex = codeStr.rindex(")")
                        else:
                            funcLastkhIndex = -1
                        if funcLastkhIndex == -1:
                            if "{" in codeStr:
                                if khCount == -2:
                                    khCount = 0
                                khCount = self.getAddKHCount(khCount,codeStr)
                            if "}" in codeStr:
                                khCount = self.getJianKHCount(khCount,codeStr)
                                # print(khCount)
                            if khCount == 0:
                                isInFuncStart = False
                                funcAllCodeArr.append(funcCodeArr)
                                # print(funcAllCodeArr)
                                # print(newClassArr)
                                funcCodeArr = []
                                continue
                        else:
                            newStr = codeStr[funcLastkhIndex:]
                            if "{" in newStr:
                                if khCount == -2:
                                    khCount = 0
                                khCount = khCount + newStr.count('{')
                            if "}" in codeStr:
                                khCount = khCount - newStr.count('}')
                                # print(khCount)
                            if khCount == 0:
                                isInFuncStart = False
                                funcAllCodeArr.append(funcCodeArr)
                                # print(funcAllCodeArr)
                                # print(newClassArr)
                                funcCodeArr = []
                                continue
                    else:
                        continue
                else:

                    if "{" in codeStr:
                        if khCount == -1:
                            khCount = 0
                        khCount = self.getAddKHCount(khCount,codeStr)
                    if "}" in codeStr:
                        khCount =  self.getJianKHCount(khCount,codeStr)
                        # print(khCount)
                    if khCount == 0:
                        isInFuncStart = False
                        funcAllCodeArr.append(funcCodeArr)
                        # print(funcAllCodeArr)
                        # print(newClassArr)
                        funcCodeArr = []
                        continue
            else:
                locals()
                if '//' in codeStr and '//' == codeStr.replace(' ', '').replace('\n', '')[0:2]:
                    allCodeArr.append(codeStr)
                    continue



                if ('let ' in newYcodeStr or  'var ' in newYcodeStr or 'typealias ' in newYcodeStr) and sxKhcount == 0:
                    if isInSXStart == True:
                        shuxingAllCodeArr.append(shuxingCodeArr)
                        shuxingCodeArr = []
                    isInSXStart = True
                    isInFuncStart = False
                    if len(tagArr) > 0:
                        shuxingCodeArr.extend(tagArr)
                        tagArr = []
                    shuxingCodeArr.append(codeStr)
                    if "{" in codeStr.replace(' ', '').replace('\n', ''):
                        sxKhcount = sxKhcount + codeStr.replace(' ', '').replace('\n', '').count('{')
                    if "}" in codeStr.replace(' ', '').replace('\n', ''):
                        sxKhcount = sxKhcount - codeStr.replace(' ', '').replace('\n', '').count('}')
                    continue

                if isInSXStart == False:
                    allCodeArr.append(codeStr)
                elif isInSXStart == True:
                    shuxingCodeArr.append(codeStr)
                    if "{" in codeStr.replace(' ', '').replace('\n', ''):
                        sxKhcount = sxKhcount + codeStr.replace(' ', '').replace('\n', '').count('{')
                    if "}" in codeStr.replace(' ', '').replace('\n', ''):
                        sxKhcount = sxKhcount - codeStr.replace(' ', '').replace('\n', '').count('}')
        # print(shuxingAllCodeArr)
        # print(funcAllCodeArr)

        #这里打乱加垃圾代码

        if len(shuxingCodeArr)>0:
            shuxingAllCodeArr.append(shuxingCodeArr)

        # print(shuxingAllCodeArr)
        if sxdlBool == True:
            if isAddXSBool == True:
                shuxingAllCodeArr = self.getLjPropertyArr(shuxingAllCodeArr)
            random.shuffle(shuxingAllCodeArr)
        i = 0
        isAdd = random.randint(0, 3)
        if isAdd < 1:
            while i < self.maxFuncCount:
                arr = self.getCreateFunc()
                funcAllCodeArr.append(arr)
                i = i + 1

        random.shuffle(funcAllCodeArr)

        for code in shuxingAllCodeArr:
            if isinstance(code, list):
                for codeStr in code:
                    allCodeArr.append(codeStr)
            else:
                allCodeArr.append(code)

        for code in funcAllCodeArr:
            if isinstance(code, list):
                for codeStr in code:
                    allCodeArr.append(codeStr)
            else:
                allCodeArr.append(code)



        # print(allCodeArr)
        return  allCodeArr


    def goStartMacroParse(self,CodeStrArr,sxdlBool = True):
        allCodeArr = []
        funcCodeArr = []
        shuxingCodeArr = []
        funcAllCodeArr = []
        shuxingAllCodeArr = []
        tagArr = []
        isInFuncStart = False
        isInSXStart = False
        khCount = 0
        sxKhcount = 0
        isFunczhushi = False
        isJH = False
        funcKHCount = 0

        for codeStr in CodeStrArr:
            locals()
            if '/*' in codeStr and '/*' == codeStr.replace(' ', '').replace('\n','')[0:2]:
                if isInFuncStart == False:
                    isFunczhushi = True
                    if '*/' in codeStr:
                        zIndex = codeStr.find('*/')
                        zsStr = codeStr[zIndex:].replace(' ', '').replace('\n', '')
                        if zsStr == '*/':
                            allCodeArr.append(codeStr)
                            isFunczhushi = False
                            continue

            if '*/' in codeStr and '*/' == codeStr.replace(' ', '').replace('\n','')[0:2]:
                if isInFuncStart == False:
                    allCodeArr.append(codeStr)
                    isFunczhushi = False
                    continue

            if isFunczhushi == True:
                allCodeArr.append(codeStr)
                continue
            if '#if' in codeStr and '#if' == codeStr.replace(' ', '').replace('\n', '')[0:3]:
                if isInFuncStart == False and sxKhcount == 0:
                    isJH = True
                    if '#endif' in codeStr:
                        zIndex = codeStr.find('#endif')
                        zsStr = codeStr[zIndex:].replace(' ', '').replace('\n', '')
                        if zsStr == '#endif':
                            allCodeArr.append(codeStr)
                            isJH = False
                            continue

            if '#endif' in codeStr and '#endif' == codeStr.replace(' ', '').replace('\n', '')[0:6]:
                if isInFuncStart == False and sxKhcount == 0:
                    allCodeArr.append(codeStr)
                    isJH = False
                    continue

            if isJH == True:
                allCodeArr.append(codeStr)
                continue
            newCodeStr = codeStr.replace(' ', '').replace('\n','')
            newCodeStr = self.getNoYHStr(newCodeStr)
            newYcodeStr = self.getNoYHStr(codeStr)
            if any(words == newCodeStr for words in self.allTagArr) == True and isInFuncStart == False:
                tagArr.append(codeStr)
                continue
            if any(words == newCodeStr for words in self.allTagZSArr) == True and isInFuncStart == False:
                tagArr.append(codeStr)
                continue
            if '@available' in newCodeStr and '@available' == newCodeStr[0:10] and isInFuncStart == False:
                tagArr.append(codeStr)
                continue
            if '@objc(' in newCodeStr and '@objc(' == newCodeStr[0:6]:
                tagArr.append(codeStr)
                continue

            if 'func ' in newYcodeStr or 'override ' in newYcodeStr or  'enum ' in newYcodeStr or 'struct ' in newYcodeStr or 'class ' in newYcodeStr or 'convenience ' in newYcodeStr or ('required' in newYcodeStr and 'required' == newYcodeStr.replace(' ', '').replace('\n', '')[0:8]) or ('init' in newYcodeStr and 'init' == newYcodeStr.replace(' ', '').replace('\n', '')[0:4]) \
                    or ('deinit' in newYcodeStr and 'deinit' == newYcodeStr.replace(' ', '').replace('\n', '')[0:6]) \
                    or ('publicinit' in newYcodeStr.replace(' ', '').replace('\n', '')[0:10]) \
                    or ('privateinit' in newYcodeStr.replace(' ', '').replace('\n', '')[0:11]) \
                    or ('fileprivateinit' in  newYcodeStr.replace(' ', '').replace('\n', '')[0:15])\
                    or ('openinit' in newYcodeStr.replace(' ', '').replace('\n', '')[0:8])\
                    or ('internalinit' in newYcodeStr.replace(' ', '').replace('\n', '')[0:12])\
                    or ('publicsubscript' in newYcodeStr.replace(' ', '').replace('\n', '')[0:15])\
                    or ('subscript' in newYcodeStr.replace(' ', '').replace('\n', '')[0:9])\
                    or ('opensubscript' in newYcodeStr.replace(' ', '').replace('\n', '')[0:13])\
                    or ('fileprivatesubscript' in newYcodeStr.replace(' ', '').replace('\n', '')[0:20])\
                    or ('privatesubscript' in newYcodeStr.replace(' ', '').replace('\n', '')[0:16])\
                    or ('@objcpublicinit' in newYcodeStr.replace(' ', '').replace('\n', '')[0:15])\
                    or ('publicprotocol' in newCodeStr[0:14]) or ('protocol' in newCodeStr[0:8]) or ('openprotocol' in newCodeStr[0:12]) \
                            or ('internalprotocol' in newCodeStr[0:8])\
                            or ('enum' in newCodeStr[0:4])\
                            or ('internalenum' in newCodeStr[0:12])\
                            or ('openenum' in newCodeStr[0:8])\
                            or ('publicenum' in newCodeStr[0:10]):


                if isInSXStart == True:
                    sxKhcount = 0
                    shuxingAllCodeArr.append(shuxingCodeArr)
                    # print(shuxingCodeArr)
                    shuxingCodeArr = []
                if  isInFuncStart == True:
                    funcCodeArr.append(codeStr)
                    if khCount == -2:
                        if "(" in codeStr:
                            funcKHCount = funcKHCount + codeStr.count('(')
                        if ")" in codeStr:
                            funcKHCount = funcKHCount - codeStr.count(')')
                        funcLastkhIndex = 0
                        if funcKHCount == 0:
                            if ')' in codeStr:
                                funcLastkhIndex = codeStr.rindex(")")
                            else:
                                funcLastkhIndex = -1
                            if funcLastkhIndex == -1:
                                if "{" in codeStr:
                                    if khCount == -2:
                                        khCount = 0
                                    khCount = self.getAddKHCount(khCount,codeStr)
                                if "}" in codeStr:
                                    khCount =  self.getJianKHCount(khCount,codeStr)
                                    # print(khCount)
                                if khCount == 0:
                                    isInFuncStart = False
                                    funcAllCodeArr.append(funcCodeArr)
                                    # print(funcAllCodeArr)
                                    # print(newClassArr)
                                    funcCodeArr = []
                                    continue
                            else:
                                newStr = codeStr[funcLastkhIndex:]
                                print(newStr)
                                if "{" in newStr:
                                    if khCount == -2:
                                        khCount = 0
                                    khCount = khCount + newStr.count('{')
                                if "}" in codeStr:
                                    khCount = khCount - newStr.count('}')
                                    # print(khCount)
                                if khCount == 0:
                                    isInFuncStart = False
                                    funcAllCodeArr.append(funcCodeArr)
                                    # print(funcAllCodeArr)
                                    # print(newClassArr)
                                    funcCodeArr = []
                                    continue
                        else:
                            continue
                    else:
                        if "{" in codeStr:
                            if khCount == -1:
                                khCount = 0
                            khCount = self.getAddKHCount(khCount,codeStr)
                        if "}" in codeStr:
                            khCount =  self.getJianKHCount(khCount,codeStr)
                            # print(khCount)
                        if khCount == 0:
                            isInFuncStart = False
                            funcAllCodeArr.append(funcCodeArr)
                            # print(funcAllCodeArr)
                            # print(newClassArr)
                            funcCodeArr = []
                            continue
                    continue
                if ('//' in codeStr.replace(' ', '').replace('\n', '')[0:2]) and isInFuncStart == False:
                    allCodeArr.append(codeStr)
                    continue
                isInSXStart = False
                isInFuncStart = True
                if len(tagArr)>0:
                    funcCodeArr.extend(tagArr)
                    tagArr = []
                funcCodeArr.append(codeStr)
                if "(" in codeStr:
                    funcKHCount = funcKHCount + codeStr.count('(')
                if ")" in codeStr:
                    funcKHCount = funcKHCount - codeStr.count(')')
                funcLastkhIndex = 0
                if funcKHCount == 0:
                    if ')' in codeStr:
                        funcLastkhIndex = codeStr.rindex(")")
                    else:
                        funcLastkhIndex = -1
                    if funcLastkhIndex == -1:
                        if "{" in codeStr:
                            khCount = self.getAddKHCount(khCount,codeStr)
                        if khCount == 0:
                            khCount = -1
                        if "}" in codeStr:
                            khCount =  self.getJianKHCount(khCount,codeStr)
                        if khCount == 0:
                            isInFuncStart = False
                            funcAllCodeArr.append(funcCodeArr)
                            # print(funcAllCodeArr)
                            # print(newClassArr)
                            funcCodeArr = []
                        continue
                    else:
                        newStr = codeStr[funcLastkhIndex:]

                        if "{" in newStr:
                            khCount = khCount + newStr.count('{')
                        if khCount == 0:
                            khCount = -1
                        if "}" in newStr:
                            khCount = khCount - newStr.count('}')
                        if khCount == 0:
                            isInFuncStart = False
                            funcAllCodeArr.append(funcCodeArr)
                            # print(funcAllCodeArr)
                            # print(newClassArr)
                            funcCodeArr = []
                        continue
                khCount = -2
                continue




            if isInFuncStart == True:
                locals()
                funcCodeArr.append(codeStr)
                # print(khCount)


                if khCount == -2:
                    if "(" in codeStr:
                        funcKHCount = funcKHCount + codeStr.count('(')
                    if ")" in codeStr:
                        funcKHCount = funcKHCount - codeStr.count(')')
                    funcLastkhIndex = 0
                    if funcKHCount == 0:
                        if ')' in codeStr:
                            funcLastkhIndex = codeStr.rindex(")")
                        else:
                            funcLastkhIndex = -1
                        if funcLastkhIndex == -1:
                            if "{" in codeStr:
                                if khCount == -2:
                                    khCount = 0
                                khCount = self.getAddKHCount(khCount,codeStr)
                            if "}" in codeStr:
                                khCount =  self.getJianKHCount(khCount,codeStr)
                                # print(khCount)
                            if khCount == 0:
                                isInFuncStart = False
                                funcAllCodeArr.append(funcCodeArr)
                                # print(funcAllCodeArr)
                                # print(newClassArr)
                                funcCodeArr = []
                                continue
                        else:
                            newStr = codeStr[funcLastkhIndex:]
                            print(newStr)
                            if "{" in newStr:
                                if khCount == -2:
                                    khCount = 0
                                khCount = khCount + newStr.count('{')
                            if "}" in codeStr:
                                khCount = khCount - newStr.count('}')
                                # print(khCount)
                            if khCount == 0:
                                isInFuncStart = False
                                funcAllCodeArr.append(funcCodeArr)
                                # print(funcAllCodeArr)
                                # print(newClassArr)
                                funcCodeArr = []
                                continue
                    else:
                        continue
                else:

                    if "{" in codeStr:
                        if khCount == -1:
                            khCount = 0
                        khCount = self.getAddKHCount(khCount,codeStr)
                    if "}" in codeStr:
                        khCount = self.getJianKHCount(khCount,codeStr)
                        # print(khCount)
                    if khCount == 0:
                        isInFuncStart = False
                        funcAllCodeArr.append(funcCodeArr)
                        # print(funcAllCodeArr)
                        # print(newClassArr)
                        funcCodeArr = []
                        continue
            else:
                locals()
                if '//' in codeStr and '//' == codeStr.replace(' ', '').replace('\n', '')[0:2]:
                    allCodeArr.append(codeStr)
                    continue



                if ('let ' in newYcodeStr or  'var ' in newYcodeStr or 'typealias ' in newYcodeStr) and sxKhcount == 0:
                    if isInSXStart == True:
                        shuxingAllCodeArr.append(shuxingCodeArr)
                        shuxingCodeArr = []
                    isInSXStart = True
                    isInFuncStart = False
                    if len(tagArr) > 0:
                        shuxingCodeArr.extend(tagArr)
                        tagArr = []
                    shuxingCodeArr.append(codeStr)
                    if "{" in codeStr.replace(' ', '').replace('\n', ''):
                        sxKhcount = sxKhcount + codeStr.replace(' ', '').replace('\n', '').count('{')
                    if "}" in codeStr.replace(' ', '').replace('\n', ''):
                        sxKhcount = sxKhcount - codeStr.replace(' ', '').replace('\n', '').count('}')
                    continue

                if isInSXStart == False:
                    allCodeArr.append(codeStr)
                elif isInSXStart == True:
                    shuxingCodeArr.append(codeStr)
                    if "{" in codeStr.replace(' ', '').replace('\n', ''):
                        sxKhcount = sxKhcount + codeStr.replace(' ', '').replace('\n', '').count('{')
                    if "}" in codeStr.replace(' ', '').replace('\n', ''):
                        sxKhcount = sxKhcount - codeStr.replace(' ', '').replace('\n', '').count('}')
        # print(shuxingAllCodeArr)
        # print(funcAllCodeArr)

        #这里打乱加垃圾代码

        if len(shuxingCodeArr)>0:
            shuxingAllCodeArr.append(shuxingCodeArr)


        # print(shuxingAllCodeArr)
        if sxdlBool == True:
            shuxingAllCodeArr = self.getLjPropertyArr(shuxingAllCodeArr)
            random.shuffle(shuxingAllCodeArr)
        i = 0
        isAdd = random.randint(0, 3)
        if isAdd < 1:
            while i < self.maxFuncCount:
                arr = self.getCreateFunc()
                funcAllCodeArr.append(arr)
                i = i + 1

        random.shuffle(funcAllCodeArr)

        for code in shuxingAllCodeArr:
            if isinstance(code, list):
                for codeStr in code:
                    allCodeArr.append(codeStr)
            else:
                allCodeArr.append(code)

        for code in funcAllCodeArr:
            if isinstance(code, list):
                for codeStr in code:
                    allCodeArr.append(codeStr)
            else:
                allCodeArr.append(code)



        return  allCodeArr

    def getAddKHCount(self,khCount,codeStr):
        khCount = khCount + codeStr.count('{')
        locals()
        yhCount = 0
        zsCount = 0
        if ( codeStr.count("\"")>=2):
            for c in codeStr:
                if c =="\"":
                    if yhCount == 0:
                        yhCount = 1
                    else:
                        yhCount = 0
                if yhCount == 1:
                    zsCount = 0
                    khCount = khCount - c.count('{')
                else:
                    zsCount = c.count("/") + zsCount
                    if zsCount >= 2:
                        khCount = khCount - c.count('{')
        else:
            if codeStr.count("//")>0:
                khCount = khCount - codeStr[codeStr.find("//"):].count('{')

        return khCount
    def getJianKHCount(self,khCount,codeStr):
        khCount = khCount - codeStr.count('}')
        locals()
        yhCount = 0
        zsCount = 0
        if (codeStr.count("\"") >= 2):
            for c in codeStr:
                if c =="\"":
                    if yhCount == 0:
                        yhCount = 1
                    else:
                        yhCount = 0
                if yhCount == 1:
                    zsCount = 0
                    khCount = khCount + c.count('}')
                else:
                    zsCount = c.count("/") + zsCount
                    if zsCount >= 2:
                        khCount = khCount + c.count('}')
        else:
            if codeStr.count("//") > 0:
                khCount = khCount + codeStr[codeStr.find("//"):].count('}')
        return khCount
    def getNoYHStr(self,codeStr):
        locals()
        yhCount = 0
        zsCount = 0
        newStr = ''
        if (codeStr.count("\"") >= 2):
            for c in codeStr:
                if c =="\"":
                    if yhCount == 0:
                        yhCount = 1
                    else:
                        yhCount = 0
                if yhCount == 1:
                    zsCount = 0
                else:
                    zsCount = c.count("/") + zsCount
                    if zsCount < 2 and c != '/':
                        newStr = (newStr+c)
        else:
            if codeStr.count("//") > 0:
                newStr = codeStr[:codeStr.find("//")]
            else:
                newStr = codeStr
        return newStr


p = ConfusionTool()
p.startInputData()