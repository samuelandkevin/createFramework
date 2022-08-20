# createFramework
iOS 静态库framework生成教程

[CSDN链接](https://blog.csdn.net/samuelandkevin/article/details/126436580)

### 新建 framework工程 Test.xcodeproject
在Test.xcodeproject中新建tartget , TestBundle(用于存放资源图片)和TestAgg(用于把模拟器和真机framework合成一个framework)

### 工程设置


#### 对TestBundle target进行设置

|TARGETS|General|iOS Deployment Target|设置设备和最低支持版本（Xcode13只有一个Deployment Target可选）|
|---|---|---|---|
|TARGETS| Build Settings | Base SDK |改成 iOS
|TARGETS| Build Settings| Supported Platforms|     改成 iOS
|TARGETS| Build Settings|Enable Bitcode |改成 NO
|TARGETS| Build Settings|Versioning System| 改为None（为了去掉构建后Bundle里的可执行文件exec）
|TARGETS| Build Settings| COMBINE_HIDPI_IMAGES| 改为NO（否则Bundle图片会变为tiff格式）


##### 对Test.framework target进行设置
进入TARGETS -> Build Settings 
|iOS Deployment Target | 设置最低支持版本|
|---|---|
|Base SDK| 改成 iOS|
|Supported Platforms |改成 iOS|
|Build Active Architecture Only |改成 NO（表示支持所有架构）|
|Dead Code Stripping | 改成 NO|
|Link With Standard Libraries |改成 NO|
|Mach-O Type | 改成 Static Library (静态库的意思，只有系统的framework里有的是动态库，自制的都是静态库)|
|Other Linker Flags |添加-ObjC（如果用了分类加这个参数）|
|Enable Bitcode |改成 NO|



##### 对TestAgg target进行设置
添加脚本
```
# Type a script or drag a script file from your workspace to insert its path.
#!/bin/sh

#要build的target名

TARGET_NAME=${PROJECT_NAME}

if [[ $1 ]]

then

TARGET_NAME=$1

fi

UNIVERSAL_OUTPUT_FOLDER="${SRCROOT}/${PROJECT_NAME}/"

#创建输出目录，并删除之前的framework文件

mkdir -p "${UNIVERSAL_OUTPUT_FOLDER}"

rm -rf "${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework"

#分别编译模拟器和真机的Framework

xcodebuild -target "${TARGET_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

xcodebuild -target "${TARGET_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

#拷贝framework到univer目录

cp -R "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework" "${UNIVERSAL_OUTPUT_FOLDER}"

lipo "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework/${TARGET_NAME}" -remove arm64 -output "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework/${TARGET_NAME}"

#合并framework，输出最终的framework到build目录

lipo -create -output "${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework/${TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework/${TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework/${TARGET_NAME}"

#删除编译之后生成的无关的配置文件

dir_path="${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework/"

for file in ls $dir_path

do

if [[ ${file} =~ ".xcconfig" ]]

then

rm -f "${dir_path}/${file}"

fi

done

#判断build文件夹是否存在，存在则删除

if [ -d "${SRCROOT}/build" ]

then

rm -rf "${SRCROOT}/build"

fi

rm -rf "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator" "${BUILD_DIR}/${CONFIGURATION}-iphoneos"

#打开合并后的文件夹

open "${UNIVERSAL_OUTPUT_FOLDER}"


```
