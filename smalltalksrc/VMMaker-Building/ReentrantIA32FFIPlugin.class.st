Class {
	#name : #ReentrantIA32FFIPlugin,
	#superclass : #ReentrantFFIPlugin,
	#category : #'VMMaker-Plugins'
}

{ #category : #'callout support' }
ReentrantIA32FFIPlugin >> ffiCalloutTo: procAddr SpecOnStack: specOnStack in: calloutState [
	<var: #procAddr type: #'void *'>
	<var: #calloutState type: #'CalloutState *'>
	"Go out, call this guy and create the return value.  This *must* be inlined because of
	 the alloca of the outgoing stack frame in ffiCall:WithFlags:NumArgs:Args:AndTypes:"
	| atomicType floatRet intRet |
	<var: #floatRet type: #double>
	<var: #intRet type: #usqLong>
	<inline: true>

	self registerArgsSlop + self cStackAlignment > 0 ifTrue:
		[self setsp: calloutState argVector].

	atomicType := self atomicTypeOf: calloutState ffiRetHeader.
	(atomicType = FFITypeSingleFloat
	 or: [atomicType = FFITypeDoubleFloat])
		ifTrue:
			[floatRet := self dispatchFunctionPointer: (self cCoerceSimple: procAddr to: 'double (*)()')]
		ifFalse:
			[intRet := self dispatchFunctionPointer: (self cCoerceSimple: procAddr to: 'usqLong (*)()')].
	"undo any callee argument pops because it may confuse stack management with the alloca."
	(self isCalleePopsConvention: calloutState callFlags) ifTrue:
		[self setsp: calloutState argVector].

	"Note: Order is important here since FFIFlagPointer + FFIFlagStructure is used to represent
	 'typedef void* VoidPointer' and VoidPointer must be returned as pointer *not* as struct."
	(calloutState ffiRetHeader anyMask: FFIFlagPointer) ifTrue:
		[^self ffiReturnPointer: intRet ofType: (self ffiReturnType: specOnStack) in: calloutState].

	(calloutState ffiRetHeader anyMask: FFIFlagStructure) ifTrue:
		[^self ffiReturnStruct: intRet ofType: (self ffiReturnType: specOnStack) in: calloutState].
	
	(atomicType = FFITypeSingleFloat
	 or: [atomicType = FFITypeDoubleFloat]) ifTrue:
		[^interpreterProxy methodReturnValue: (interpreterProxy floatObjectOf: floatRet)].

	^interpreterProxy methodReturnValue: (self ffiCreateIntegralResultOop: intRet
												ofAtomicType: atomicType
												in: calloutState)
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushDoubleFloat: value in: calloutState [
	<var: #value type: #double>
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 8 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy storeFloatAtPointer: calloutState currentArg from: value.
	calloutState currentArg: calloutState currentArg + 8.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushPointer: pointer in: calloutState [
	<var: #pointer type: #'void *'>
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 4 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy longAt: calloutState currentArg put: pointer.
	calloutState currentArg: calloutState currentArg + 4.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushSignedByte: value in: calloutState [
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 4 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy longAt: calloutState currentArg put: (self cCoerceSimple: value to: #'signed char').
	calloutState currentArg: calloutState currentArg + 4.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushSignedChar: value in: calloutState [
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 4 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy longAt: calloutState currentArg put: (self cCoerceSimple: value to: #'signed char').
	calloutState currentArg: calloutState currentArg + 4.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushSignedInt: value in: calloutState [
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 4 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy longAt: calloutState currentArg put: value.
	calloutState currentArg: calloutState currentArg + 4.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushSignedLongLong: value in: calloutState [
	<var: #value type: #usqLong>
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 8 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy
		longAt: calloutState currentArg put: (self cCoerceSimple: value to: #usqInt);
		longAt: calloutState currentArg + 4 put: (self cCoerceSimple: value >> 32 to: #usqInt).
	calloutState currentArg: calloutState currentArg + 8.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushSignedShort: value in: calloutState [
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 4 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy longAt: calloutState currentArg put: (self cCoerceSimple: value to: #'signed short').
	calloutState currentArg: calloutState currentArg + 4.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushSingleFloat: value in: calloutState [
	<var: #value type: #float>
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 4 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy storeSingleFloatAtPointer: calloutState currentArg from: value.
	calloutState currentArg: calloutState currentArg + 4.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushStructure: pointer ofSize: structSize typeSpec: argSpec ofLength: argSpecSize in: calloutState [
	<var: #pointer type: #'void *'>
	<var: #argSpec type: #'sqInt *'>
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	| roundedSize |
	roundedSize := structSize + 3 bitAnd: 3 bitInvert32.
	calloutState currentArg + roundedSize > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	self mem: calloutState currentArg cp: pointer y: structSize.
	calloutState currentArg: calloutState currentArg + roundedSize.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushUnsignedByte: value in: calloutState [
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 4 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy longAt: calloutState currentArg put: (self cCoerceSimple: value to: #'unsigned char').
	calloutState currentArg: calloutState currentArg + 4.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushUnsignedChar: value in: calloutState [
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 4 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy longAt: calloutState currentArg put: (self cCoerceSimple: value to: #'unsigned char').
	calloutState currentArg: calloutState currentArg + 4.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushUnsignedInt: value in: calloutState [
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 4 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy longAt: calloutState currentArg put: value.
	calloutState currentArg: calloutState currentArg + 4.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushUnsignedLongLong: value in: calloutState [
	<var: #value type: #usqLong>
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 8 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy
		longAt: calloutState currentArg put: (self cCoerceSimple: value to: #usqInt);
		longAt: calloutState currentArg + 4 put: (self cCoerceSimple: value >> 32 to: #usqInt).
	calloutState currentArg: calloutState currentArg + 8.
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> ffiPushUnsignedShort: value in: calloutState [
	<var: #calloutState type: #'CalloutState *'>
	<inline: true>
	calloutState currentArg + 4 > calloutState limit ifTrue:
		[^FFIErrorCallFrameTooBig].
	interpreterProxy longAt: calloutState currentArg put: (self cCoerceSimple: value to: #'unsigned short').
	calloutState currentArg: calloutState currentArg + 4.
	^0
]

{ #category : #'callout support' }
ReentrantIA32FFIPlugin >> ffiReturnStruct: longLongRet ofType: ffiRetType in: calloutState [
	<var: #longLongRet type: #usqLong>
	<var: #calloutState type: #'CalloutState *'>
	"Create a structure return value from an external function call.  The value as been stored in
	 alloca'ed space pointed to by the calloutState."
	| retOop retClass oop |
	<inline: true>
	retClass := interpreterProxy fetchPointer: 1 ofObject: ffiRetType.
	retOop := interpreterProxy instantiateClass: retClass indexableSize: 0.
	interpreterProxy pushRemappableOop: retOop.
	oop := interpreterProxy 
			instantiateClass: interpreterProxy classByteArray 
			indexableSize: calloutState structReturnSize.
	(self returnStructInRegisters: calloutState structReturnSize)
		ifTrue:
			[self mem: (interpreterProxy firstIndexableField: oop) cp: (self addressOf: longLongRet) y: calloutState structReturnSize]
		ifFalse:
			[self mem: (interpreterProxy firstIndexableField: oop) cp: calloutState limit y: calloutState structReturnSize].
	retOop := interpreterProxy popRemappableOop.
	interpreterProxy storePointer: 0 ofObject: retOop withValue: oop.
	^interpreterProxy methodReturnValue: retOop
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> registerArgsSlop [
	"Answer any space needed to prevent the alloca'ed outgoing arguments marshalling area from
	 being overwritten by any register arguments during calls during marshalling.  On x86 this is 0"
	^0
]

{ #category : #marshalling }
ReentrantIA32FFIPlugin >> returnStructInRegisters: returnStructSize [
	"Answer if a struct result of a given size is returned in memory or not."
	<cmacro: '(sz) (WIN32_X86_STRUCT_RETURN && (sz) <= 8 && !((sz)&((sz)-1)))'>
	^returnStructSize <= 8 and: [(returnStructSize bitAnd: returnStructSize - 1) = 0]
]