"
A class to generate UUID
by John M McIntosh johnmci@smalltalkconsulting.com, since it requires platform support it will only be built when supported on your platform.
See http://www.webdav.org/specs/draft-leach-uuids-guids-01.txt

If a plugin does not exist then we generate a UUID version 4 type GUUID in Smalltalk
"
Class {
	#name : #UUIDPlugin,
	#superclass : #SmartSyntaxInterpreterPlugin,
	#category : #'VMMaker-Plugins'
}

{ #category : #translation }
UUIDPlugin class >> hasHeaderFile [
	"If there is a single intrinsic header file to be associated with the plugin, here is where you want to flag"
	^true
]

{ #category : #translation }
UUIDPlugin class >> requiresPlatformFiles [
	"this plugin requires platform specific files in order to work"
	^true
]

{ #category : #initialize }
UUIDPlugin >> initialiseModule [
	self export: true.
	^self cCode: 'sqUUIDInit()' inSmalltalk:[true]
]

{ #category : #'system primitives' }
UUIDPlugin >> primitiveMakeUUID [
	| oop location |
	self export: true.
	self var: #location type: 'char*'.
	interpreterProxy methodArgumentCount = 0
		ifFalse:[^interpreterProxy primitiveFail].
	oop := interpreterProxy stackObjectValue: 0.
	interpreterProxy failed ifTrue:[^nil].
	(interpreterProxy isBytes: oop) 
		ifFalse:[^interpreterProxy primitiveFail].
	(interpreterProxy byteSizeOf: oop) = 16
		ifFalse:[^interpreterProxy primitiveFail].
	location := interpreterProxy firstIndexableField: oop.

	self cCode: 'MakeUUID(location)' 
		inSmalltalk: [location. interpreterProxy primitiveFail].

]

{ #category : #initialize }
UUIDPlugin >> shutdownModule [
	self export: true.
	^self cCode: 'sqUUIDShutdown()' inSmalltalk:[true]
]