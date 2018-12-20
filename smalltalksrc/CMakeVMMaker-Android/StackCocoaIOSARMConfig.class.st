Class {
	#name : #StackCocoaIOSARMConfig,
	#superclass : #StackCocoaIOSConfig,
	#category : #'CMakeVMMaker-IOS'
}

{ #category : #accessing }
StackCocoaIOSARMConfig >> architecture [ 
	^'armv6'
]

{ #category : #settings }
StackCocoaIOSARMConfig >> commonCompilerFlags [
	"Common compiler flags"
	^{
	"'-miphoneos-version-min=4.3'. "
	'-isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS', self sdkVersion, '.sdk'.
	'-x objective-c'.
	'-std=gnu99'.
	'-falign-functions=16'.
	'-fno-gcse'.
	'-fno-cse-follow-jumps'.
	'-fvisibility=hidden'.
	'-funroll-loops'.
	'-finline-functions'.
	'-DSTACKVM=1'.
	'-DCOGMTVM=0'. 
	'-DUSE_GLOBAL_STRUCT=0'. 
	'-DBASE_HEADER_SIZE=4'.
	'-DTARGET_OS_IS_IPHONE'.
	'-DHAVE_UUID_GENERATE'.
	'-DUSE_INLINE_MEMORY_ACCESSORS'. 
	'-DHAVE_SYS_TIME_H'.
	'-DLSB_FIRST'.
	'-DHAVE_NANOSLEEP'.
	"'-DXXXUSE_INLINE_MEMORY_ACCESSORS'."
	'-DISQUEAK_IMAGE=iPhone'.
	'-DISQUEAK_SOURCES=PharoV10'}
]

{ #category : #settings }
StackCocoaIOSARMConfig >> compilerFlagsDebug [
	^#('-g3' '-O0' "'-fasm-blocks'" "'-mfpmath=sse'" "'-march=pentium-m'" "'-mtune=prescott'" '-fno-cse-follow-jumps' '-DDEBUGVM=1')
]

{ #category : #settings }
StackCocoaIOSARMConfig >> compilerFlagsRelease [ 
	^#('-g0' '-Os' "'-fasm-blocks'" '-finline-functions' "'-mfpmath=sse'" '-fomit-frame-pointer' "'-march=pentium-m'" "'-mtune=prescott'" '-DNDEBUG' '-DDEBUGVM=0')
]

{ #category : #settings }
StackCocoaIOSARMConfig >> defaultExternalPlugins [ 
	^#()
]

{ #category : #settings }
StackCocoaIOSARMConfig >> defaultInternalPlugins [
	^ #(
		ADPCMCodecPlugin
		BMPReadWriterPlugin 
		BalloonEnginePlugin 
		BitBltSimulation 
		DSAPlugin 
		DeflatePlugin 
		"DropPlugin" 
		FFTPlugin 
		FilePlugin 
		FloatArrayPlugin 
		HostWindowPlugin 
		JPEGReadWriter2Plugin 
		JPEGReaderPlugin 
		LargeIntegersPlugin 
		Matrix2x3Plugin 
		MiscPrimitivePlugin 
		"RePlugin" 
		SecurityPlugin 
		"SocketPlugin" 
		SoundCodecPlugin 
		SoundGenerationPlugin 
		SoundPlugin
		SurfacePlugin
		UUIDPlugin
		"IOSPlugin")
]

{ #category : #accessing }
StackCocoaIOSARMConfig >> executableName [
	^ 'iStackVM'
]

{ #category : #'plugin extra rules' }
StackCocoaIOSARMConfig >> extraPluginSettings: maker [	
	self architecture
		ifNotNil: [ :arch | maker set: 'CMAKE_OSX_ARCHITECTURES' toString: arch ].
		
	self setCommonProperties: maker.

	maker 
		setTargetProperty: 'COMPILE_FLAGS' 
		to: '"-include \"', (self buildDir / self prefixHeaderFileName) fullName, '\""'.  

	maker isExternal ifTrue: [
		"copy result to results dir "
		maker set: 'LIBRARY_OUTPUT_PATH' toString: self outputDir.
		maker set: 'EXECUTABLE_OUTPUT_PATH' toString: self outputDir.
		maker puts: 'list(APPEND linkFlags "-undefined dynamic_lookup")' ].
	
	"maker addXCodeProperty: 'GCC_VERSION' value: '4.3'."
	maker addXCodeProperty: 'GCC_PREFIX_HEADER' value: '${buildDir}/' , self executableName , '_Prefix.pch'.
	

]

{ #category : #'source files' }
StackCocoaIOSARMConfig >> extraSources [
	" mac VM using some unix sources "
	
	^'${buildDir}/', self prefixHeaderFileName, ' 
${resources} ', 
'${buildDir}/', self prefixHeaderFileName, ' 
${resourcesLocaleEnglish} 
${platformsDir}/unix/vm/sqUnixHeartbeat.c  
${platformsDir}/unix/vm/sqUnixThreads.c
'
]

{ #category : #accessing }
StackCocoaIOSARMConfig >> frameworks [
	^ #(
	CoreAudio
	CoreGraphics
	CoreLocation
	UIKit
	Foundation
	QuartzCore
	OpenGLES
	AudioToolbox
	SystemConfiguration)
]

{ #category : #settings }
StackCocoaIOSARMConfig >> imageResources [ 
	^#(
	'iPhone.image'
	'iPhone.changes'
	'PharoV10.sources')
]

{ #category : #'source files' }
StackCocoaIOSARMConfig >> platformSources [
	"files added from platform/iOS/vm dir "
	^ #(
		'Common/main.m'
		'Common/Classes/Queue.m'
		'Common/Classes/sqMacV2Time.c'
		'Common/Classes/sqSqueakAppDelegate.m'
		'Common/Classes/sqSqueakFileDirectoryAPI.m'
		'Common/Classes/sqSqueakFileDirectoryInterface.m'
		'Common/Classes/sqSqueakInfoPlistInterface.m'
		'Common/Classes/sqSqueakMainApplication.m'
		'Common/Classes/sqSqueakMainApplication+attributes.m'
		'Common/Classes/sqSqueakMainApplication+events.m'
		'Common/Classes/sqSqueakMainApplication+imageReadWrite.m'
		'Common/Classes/sqSqueakMainApplication+sound.m'
		'Common/Classes/sqSqueakMainApplication+vmAndImagePath.m'
		'Common/Classes/sqSqueakMainApplication+screen.m'
		'Common/Classes/sqSqueakMainApplication+cursor.m'
		"'Common/Classes/sqSqueakCursorAPI.m'"
		'Common/Classes/sqSqueakAttributesAPI.m'
		'Common/Classes/sqSqueakSoundAPI.m'
		'Common/Classes/sqSqueakVmAndImagePathAPI.m'
		'Common/Classes/sqSqueakMainApp.m'
		'Common/Classes/sqSqueakEventsAPI.m'
		'Common/Classes/sqSqueakScreenAPI.m'
		'Common/Classes/sqSqueakScreenAndWindow.m'
		'iPhone/Classes/SqueakNoOGLIPhoneAppDelegate.m'
		'iPhone/Classes/sqSqueakIPhoneApplication.m'
		'iPhone/Classes/sqSqueakIPhoneApplication+attributes.m'
		'iPhone/Classes/sqSqueakIPhoneApplication+clipboard.m'
		'iPhone/Classes/sqSqueakIPhoneApplication+imageReadWrite.m'
		'iPhone/Classes/sqSqueakIPhoneApplication+events.m'
		'iPhone/Classes/sqSqueakIPhoneApplication+Network.m'
		'iPhone/Classes/sqSqueakiPhoneApplication+sound.m'
		'iPhone/Classes/sqSqueakIPhoneFileDirectoryInterface.m'
		'iPhone/Classes/sqSqueakIPhoneInfoPlistInterface.m'
		'iPhone/Classes/sqiPhoneScreenAndWindow.m'
		'iPhone/Classes/SqueakUIView.m'
		'iPhone/Classes/SqueakUIViewCALayer.m'
		'iPhone/Classes/SqueakUIViewOpenGL.m'
		'iPhone/Classes/SqueakUIController.m'
		'iPhone/Classes/sqSqueakIPhoneClipboardAPI.m'
		'iPhone/macintoshextra.c'
		'iPhone/osExports.c'
		'iPhone/sqDummyaio.c'
		'iPhone/sqMacV2Memory.c'
		)
]

{ #category : #'bundle strings' }
StackCocoaIOSARMConfig >> plistTemplate [ 
	self flag: #todo. "CFBundleDisplayName is using @CFBundleExecutable@ that's probably wrong"
	^'<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>BuildMachineOSBuild</key>
	<string>10J869</string>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleDisplayName</key>
	<string>@CFBundleExecutable@</string>
	<key>CFBundleExecutable</key>
	<string>@CFBundleExecutable@</string>
	<key>CFBundleIconFile</key>
	<string>@CFBundleIconFile@</string>
	<key>CFBundleIdentifier</key>
	<string>@CFBundleIdentifier@</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>@CFBundleName@</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleResourceSpecification</key>
	<string>ResourceRules.plist</string>
	<key>CFBundleSignature</key>
	<string>FRAC</string>
	<key>CFBundleSupportedPlatforms</key>
	<array>
		<string>iPhoneOS</string>
	</array>
	<key>CFBundleVersion</key>
	<string>1.1.7</string>
	<key>DTCompiler</key>
	<string>4.2</string>
	<key>DTPlatformBuild</key>
	<string>8H7</string>
	<key>DTPlatformName</key>
	<string>iphoneos</string>
	<key>DTPlatformVersion</key>
	<string>4.3</string>
	<key>DTSDKBuild</key>
	<string>8H7</string>
	<key>DTSDKName</key>
	<string>iphoneos4.3</string>
	<key>DTXcode</key>
	<string>0402</string>
	<key>DTXcodeBuild</key>
	<string>4A2002a</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>MinimumOSVersion</key>
	<string>3.1.3</string>
	<key>NSMainNibFile</key>
	<string>MainWindow</string>
	<key>UIDeviceFamily</key>
	<array>
		<integer>1</integer>
	</array>
	<key>UIPrerenderedIcon</key>
	<true/>
	<key>UIStatusBarHidden</key>
	<true/>
</dict>
</plist>
'
]

{ #category : #settings }
StackCocoaIOSARMConfig >> precompiledImports [ 
	^#(
	'Foundation/Foundation.h' 
	'UIKit/UIKit.h')
]

{ #category : #settings }
StackCocoaIOSARMConfig >> resources [ 
	^#('Cog.icns'), self imageResources
]

{ #category : #accessing }
StackCocoaIOSARMConfig >> sdkVersion [ 
	^'5.0'
]

{ #category : #settings }
StackCocoaIOSARMConfig >> setCommonProperties: maker [ 
	maker set: 'CMAKE_CROSSCOMPILING' to: 'TRUE'.
	maker set: 'CMAKE_SYSTEM_NAME' to: 'Darwin'.
	maker set: 'CMAKE_SYSTEM_PROCESSOR' to: 'arm'.

	maker set: 'SDKVER' toString: self sdkVersion.
	maker set: 'DEVROOT' toString: '/Developer/Platforms/iPhoneOS.platform/Developer'.
	maker set: 'SDKROOT' toString: '${DEVROOT}/SDKs/iPhoneOS${SDKVER}.sdk'.

	maker 
		set: 'CMAKE_OSX_SYSROOT' 
		to: 'iphoneos${SDKVER}'.
		
	maker set: 'CMAKE_C_COMPILER' to: '${DEVROOT}/usr/bin/llvm-gcc'.
	maker set: 'CMAKE_CXX_COMPILER' to: '${DEVROOT}/usr/bin/llvm-g++'.
	"maker set: 'CMAKE_C_COMPILER' to: 'gcc-4.2'.
	maker set: 'CMAKE_CXX_COMPILER' to: 'g++-4.2'."
		
	maker set: 'CMAKE_FIND_ROOT_PATH' to: '"${SDKROOT}" "${DEVROOT}"'.
	maker set: 'CMAKE_FIND_ROOT_PATH_MODE_PROGRAM' to: 'ONLY'.
	maker set: 'CMAKE_FIND_ROOT_PATH_MODE_LIBRARY' to: 'ONLY'.
	maker set: 'CMAKE_FIND_ROOT_PATH_MODE_INCLUDE' to: 'ONLY'.
	
	maker set: 'CMAKE_EXE_LINKER_FLAGS' toString: '-L${SDKROOT}/usr/lib -L${SDKROOT}/usr/lib/system'.

	maker addFrameworks: self frameworks.

]

{ #category : #settings }
StackCocoaIOSARMConfig >> setExtraTargetProperties: maker [
	"super setExtraTargetProperties: maker."

	| precompiledHeaders plist |
	
	precompiledHeaders := (self executableName, '_Prefix.pch').
	(maker buildDir forceNewFileNamed: precompiledHeaders) 
		nextPutAll: self precompiledHeaders;
		close.
	maker addXCodeProperty: 'GCC_PREFIX_HEADER' value: '${buildDir}/', precompiledHeaders.
	
	self setCommonProperties: maker.

	" generated and add Info.plist file "
	plist := self plistFile.

	(maker buildDir forceNewFileNamed: 'Info.plist') 
		nextPutAll: plist; 
		close.

	maker 
		addProperty: 'MACOSX_BUNDLE_INFO_PLIST' 
		value: '${buildDir}/Info.plist'.  

	maker 
		cmd: 'set_target_properties' 
		params: self executableName, ' PROPERTIES COMPILE_FLAGS "-include \"', (self buildDir / self prefixHeaderFileName) fullName, '\""'. 
	
	maker set: 'EXECUTABLE_OUTPUT_PATH' toString: self outputDir.
	maker set: 'RUNTIME_OUTPUT_DIRECTORY' toString: self outputDir.

]

{ #category : #settings }
StackCocoaIOSARMConfig >> setResourceProperties: maker [
	maker set: 'resourceDir' toString: self resourcesDir, '/ProjectBuilder'.

	maker 
		set: 'resources' 
		to: (String streamContents: [ :stream | 
			self  resources
				do: [ :each | 
					stream 
						nextPut: $";
						nextPutAll: '${resourceDir}/';
						nextPutAll: each;
						nextPut: $"]
				separatedBy: [ stream space ] ]).
		
	maker 
		set: 'resourcesLocaleEnglish' 
		toString: '${resourceDir}/iPhone-English.lproj/MainWindow.nib'.

	maker 
		cmd: 'set_source_files_properties' 
		params: '${resources} PROPERTIES MACOSX_PACKAGE_LOCATION .'.

	maker 
		cmd: 'set_source_files_properties' 
		params: '${resourcesLocaleEnglish} PROPERTIES MACOSX_PACKAGE_LOCATION .'.


]

{ #category : #'source files' }
StackCocoaIOSARMConfig >> standardIncludes [
	^#(
	'${srcDir}/vm'
	'${platformsDir}/iOS/vm/iPhone'
	'${platformsDir}/iOS/vm/iPhone/Classes'
	'${platformsDir}/iOS/vm/OSX'
	'${platformsDir}/unix/vm'
	'${platformsDir}/iOS/vm/Common/Classes'
	'${platformsDir}/iOS/plugins/SoundPlugin'
	'${platformsDir}/iOS/vm/OSX/plugins/SoundPlugin'
	'${crossDir}/plugins/SoundPlugin'
	'${crossDir}/plugins/HostWindowPlugin'
	'${platformsDir}/Cross/plugins/HostWindowPlugin'
	'${platformsDir}/iOS/vm/iPhone/plugins/HostWindowPlugin'
	'${crossDir}/plugins/FilePlugin'
	)	

]