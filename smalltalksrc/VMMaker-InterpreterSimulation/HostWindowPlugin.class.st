"
This plugin provides access to creating, destroying and manipulating host OS windows. See the Cross/plugins/HostWindowPlugin/HostWindowPlugin.h file for documented declarations for the C functions you need to provide.
"
Class {
	#name : #HostWindowPlugin,
	#superclass : #SmartSyntaxInterpreterPlugin,
	#category : #'VMMaker-Plugins'
}

{ #category : #translation }
HostWindowPlugin class >> hasHeaderFile [
	^true
]

{ #category : #translation }
HostWindowPlugin class >> requiresPlatformFiles [
	^true
]

{ #category : #'system primitives' }
HostWindowPlugin >> primitiveCloseHostWindow: windowIndex [
"Close a host window. windowIndex is the SmallInt handle returned previously by primitiveCreateHostWindow. Fail if the index is invalid or the platform code fails"
	| ok |
	self primitive: 'primitiveCloseHostWindow'
		parameters: #(SmallInteger).
	
	ok := self closeWindow: windowIndex.
	ok ifFalse:[interpreterProxy primitiveFail].

]

{ #category : #'system primitives' }
HostWindowPlugin >> primitiveCreateHostWindowWidth: w height: h originX: x y: y attributes: list [
"Create a host window of width 'w' pixels, height 'h' with the origin of the
user area at 'x@y' from the topleft corner of the screen.
Return the SmallInt value of the internal index to the window description block
- which is whatever the host platform code needs it to be."
	| windowIndex listLength |
	self primitive: 'primitiveCreateHostWindow'
		parameters: #(SmallInteger SmallInteger SmallInteger SmallInteger ByteArray).

	"createWindowWidthheightoriginXyattr(int w, int h, int x, int y, int*
attributeList) must create a hostwindow and return an integer index. Return 0 if
failed"
	listLength := interpreterProxy slotSizeOf: list cPtrAsOop.
	windowIndex := self createWindowWidth: w height: h originX: x y: y attr: list
length: listLength.
	windowIndex > 0 ifTrue:[^windowIndex asSmallIntegerObj]
		ifFalse:[^interpreterProxy primitiveFail].

]

{ #category : #'system primitives' }
HostWindowPlugin >> primitiveHostWindowPosition: windowIndex [ 
	"Return the origin position of the user area of the window in pixels from the topleft corner of the screen. Fail if the windowIndex is invalid or the platform routine returns -1 to indicate failure"
	| pos |
	self primitive: 'primitiveHostWindowPosition'
		parameters: #(SmallInteger ).
	pos := self ioPositionOfWindow: windowIndex.
	pos = -1
		ifTrue: [^ interpreterProxy primitiveFail]
		ifFalse: [^ interpreterProxy makePointwithxValue: pos >> 16  yValue: (pos bitAnd: 16rFFFF)]
]

{ #category : #'system primitives' }
HostWindowPlugin >> primitiveHostWindowPositionSet: windowIndex x:  x y: y [
	"Set the origin position of the user area of the window  in pixels from the topleft corner of the screen- return the position actually set by the OS/GUI/window manager. Fail if the windowIndex is invalid or the platform routine returns -1 to indicate failure"
	| pos |
	self primitive: 'primitiveHostWindowPositionSet'
		parameters: #(SmallInteger SmallInteger SmallInteger).
	pos := self ioPositionOfWindowSet: windowIndex x: x y: y.
	pos = -1
		ifTrue: [^ interpreterProxy primitiveFail]
		ifFalse: [^ interpreterProxy makePointwithxValue: pos >> 16  yValue: (pos bitAnd: 16rFFFF)]
]

{ #category : #'system primitives' }
HostWindowPlugin >> primitiveHostWindowSize: windowIndex [ 
	"Return the size of the user area of the window in pixels. Fail if the windowIndex is invalid or the platform routine returns -1 to indicate failure"
	| size |
	self primitive: 'primitiveHostWindowSize'
		parameters: #(SmallInteger ).
	size := self ioSizeOfWindow: windowIndex.
	size = -1
		ifTrue: [^ interpreterProxy primitiveFail]
		ifFalse: [^ interpreterProxy makePointwithxValue: size >> 16  yValue: (size bitAnd: 16rFFFF)]
]

{ #category : #'system primitives' }
HostWindowPlugin >> primitiveHostWindowSizeSet: windowIndex x: x y: y [
	"Set the size of the user area of the window in pixels - return what is actually set by the OS/GUI/window manager. Fail if the windowIndex is invalid or the platform routine returns -1 to indicate failure"
	| size |
	self primitive: 'primitiveHostWindowSizeSet'
		parameters: #(SmallInteger SmallInteger SmallInteger).
	size := self ioSizeOfWindowSet: windowIndex x: x y: y.
	size = -1
		ifTrue: [^ interpreterProxy primitiveFail]
		ifFalse: [^ interpreterProxy makePointwithxValue: size >> 16  yValue: (size bitAnd: 16rFFFF)]
]

{ #category : #'system primitives' }
HostWindowPlugin >> primitiveHostWindowTitle: id string: titleString [
	"Set the title bar label of the window. Fail if the windowIndex is invalid or the platform routine returns -1 to indicate failure"
	| res titleLength |
	self primitive: 'primitiveHostWindowTitle'
		parameters: #(SmallInteger String).
	titleLength := interpreterProxy slotSizeOf: titleString cPtrAsOop.
	res := self cCode: 'ioSetTitleOfWindow(id, titleString, titleLength)'.
	res = -1
		ifTrue: [interpreterProxy primitiveFail]
]

{ #category : #'system primitives' }
HostWindowPlugin >> primitiveShowHostWindow: windowIndex bits: dispBits width: w height: h depth: d
left: left right: right top: top bottom: bottom [
"Host window analogue of DisplayScreen> primShowRectLeft:right:top:bottom:
(Interpreter>primitiveShowDisplayRect) which takes the window index, bitmap
details and the rectangle bounds. Fail if the windowIndex is invalid or the
platform routine returns false to indicate failure"
	|ok|
	self primitive: 'primitiveShowHostWindowRect'
		parameters: #(SmallInteger WordArray SmallInteger SmallInteger SmallInteger
SmallInteger SmallInteger SmallInteger SmallInteger).

	"Tell the vm to copy pixel's from dispBits to the screen - this is just
ioShowDisplay with the extra parameter of the windowIndex integer"
	ok := self cCode: 'ioShowDisplayOnWindow(dispBits, w, h, d, left, right, top,
bottom, windowIndex)'.
	ok ifFalse:[interpreterProxy primitiveFail]
]

{ #category : #'initialize-release' }
HostWindowPlugin >> shutdownModule [
"do any window related VM closing down work your platform requires."
	self export: true.
	^self cCode: 'ioCloseAllWindows()' inSmalltalk:[true]
]