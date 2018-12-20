Class {
	#name : #FloatMathPlugin,
	#superclass : #InterpreterPlugin,
	#category : #'VMMaker-Plugins'
}

{ #category : #'as yet unclassified' }
FloatMathPlugin class >> hasHeaderFile [
	"If there is a single intrinsic header file to be associated with the plugin, here is where you want to flag"
	^true
]

{ #category : #'as yet unclassified' }
FloatMathPlugin class >> requiresCrossPlatformFiles [
	"default is ok for most, any plugin needing platform specific files must say so"
	^true
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveArcCos [
	"Computes acos(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_acos(rcvr)' inSmalltalk: [rcvr arcCos].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveArcCosH [
	"Computes acosh(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_acosh(rcvr)' inSmalltalk: [rcvr arcCosH].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveArcSin [
	"Computes asin(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_asin(rcvr)' inSmalltalk: [rcvr arcSin].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveArcSinH [
	"Computes asinh(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_asinh(rcvr)' inSmalltalk: [rcvr arcSinH].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveArcTan [
	"Computes atan(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_atan(rcvr)' inSmalltalk: [rcvr arcTan].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveArcTan2 [
	"Computes atan2(receiver, arg)"
	| rcvr arg result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #arg type: 'double'.
	self var: #result type: 'double'.
	arg := interpreterProxy stackFloatValue: 0.
	rcvr := interpreterProxy stackFloatValue: 1.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_atan2(rcvr, arg)' inSmalltalk: [rcvr arcTan: arg].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveArcTanH [
	"Computes atanh(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_atanh(rcvr)' inSmalltalk: [rcvr arcTanH].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveCos [
	"Computes cos(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_cos(rcvr)' inSmalltalk: [rcvr cos].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveCosH [
	"Computes cosh(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_cosh(rcvr)' inSmalltalk: [rcvr cosH].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveExp [
	"Computes E raised to the receiver power."
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := (self cCode: '__ieee754_exp(rcvr)' inSmalltalk: [rcvr exp]).
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveFMod [
	"Computes receiver \\ arg"
	| rcvr arg result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #arg type: 'double'.
	self var: #result type: 'double'.
	arg := interpreterProxy stackFloatValue: 0.
	rcvr := interpreterProxy stackFloatValue: 1.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_fmod(rcvr, arg)' inSmalltalk: [rcvr \\ arg].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveFractionalPart [
	"Computes receiver \\ 1.0"
	| rcvr result trunc |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	self var: #trunc type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_modf(rcvr, &trunc)' inSmalltalk: [rcvr fractionPart].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveHypot [
	"hypot(x,y) returns sqrt(x^2+y^2) with error less  than 1 ulps"
	| rcvr arg result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #arg type: 'double'.
	self var: #result type: 'double'.
	arg := interpreterProxy stackFloatValue: 0.
	rcvr := interpreterProxy stackFloatValue: 1.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_hypot(rcvr, arg)' inSmalltalk: [rcvr hypot: arg].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveLog10 [
	"Computes log10(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	rcvr < 0.0 ifTrue:[^interpreterProxy primitiveFail].
	result := self cCode: '__ieee754_log10(rcvr)' inSmalltalk: [rcvr log: 10].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveLogN [
	"Computes log(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	rcvr < 0.0 ifTrue:[^interpreterProxy primitiveFail].
	result := self cCode: '__ieee754_log(rcvr)' inSmalltalk: [rcvr ln].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveRaisedToPower [
	"Computes receiver**arg"
	| rcvr arg result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #arg type: 'double'.
	self var: #result type: 'double'.
	arg := interpreterProxy stackFloatValue: 0.
	rcvr := interpreterProxy stackFloatValue: 1.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_pow(rcvr, arg)' inSmalltalk: [rcvr raisedTo: arg].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveSin [
	"Computes sin(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_sin(rcvr)' inSmalltalk: [rcvr sin].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveSinH [
	"Computes sinh(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_sinh(rcvr)' inSmalltalk: [rcvr sinH].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveSqrt [
	"Computes sqrt(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	rcvr < 0.0 ifTrue:[^interpreterProxy primitiveFail].
	result := self cCode: '__ieee754_sqrt(rcvr)' inSmalltalk: [rcvr sqrt].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveTan [
	"Computes tan(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_tan(rcvr)' inSmalltalk: [rcvr tan].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveTanH [
	"Computes tanh(receiver)"
	| rcvr result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	rcvr := interpreterProxy stackFloatValue: 0.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_tanh(rcvr)' inSmalltalk: [rcvr tanH].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]

{ #category : #'float primitives' }
FloatMathPlugin >> primitiveTimesTwoPower [
	"Computes E raised to the receiver power."
	| rcvr arg result |
	self export: true.
	self var: #rcvr type: 'double'.
	self var: #result type: 'double'.
	arg := interpreterProxy stackIntegerValue: 0.
	rcvr := interpreterProxy stackFloatValue: 1.
	(interpreterProxy failed) ifTrue:[^nil].
	result := self cCode: '__ieee754_ldexp(rcvr, arg)' inSmalltalk: [rcvr timesTwoPower: arg].
	(self isnan: result) ifTrue:[^interpreterProxy primitiveFail].
	interpreterProxy pop: interpreterProxy methodArgumentCount + 1.
	interpreterProxy pushFloat: result.
]