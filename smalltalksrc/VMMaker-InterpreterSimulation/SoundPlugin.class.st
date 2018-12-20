"
This plugin implements the main sound related primiives.  Since it requires platform support it will only be built when supported on your platform


FORMAT OF SOUND DATA

Squeak uses 16-bit signed samples encoded in the host's endian order.  A sound buffer is a sequence of ""frames"", or ""slices"", where each frame usually includes one sample per channel.  The exception is that for playback, each frame always includes 2 samples; for monaural playback, every other sample is ignored.

"
Class {
	#name : #SoundPlugin,
	#superclass : #SmartSyntaxInterpreterPlugin,
	#category : #'VMMaker-Plugins'
}

{ #category : #translation }
SoundPlugin class >> hasHeaderFile [
	"If there is a single intrinsic header file to be associated with the plugin, here is where you want to flag"
	^true
]

{ #category : #translation }
SoundPlugin class >> requiresPlatformFiles [
	"this plugin requires platform specific files in order to work"
	^true
]

{ #category : #'initialize-release' }
SoundPlugin >> initialiseModule [
	self export: true.
	^self cCode: 'soundInit()' inSmalltalk:[true]
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundAvailableSpace [
	"Returns the number of bytes of available sound output buffer space.  This should be (frames*4) if the device is in stereo mode, or (frames*2) otherwise"

	| frames |
	self primitive: 'primitiveSoundAvailableSpace'.
	frames := self cCode: 'snd_AvailableSpace()'.  "-1 if sound output not started"
	interpreterProxy success: frames >= 0.
	^frames asPositiveIntegerObj
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundGetRecordingSampleRate [
	"Return a float representing the actual sampling rate during recording. Fail if not currently recording."

	| rate |
	self var: #rate type: 'double '.
	self primitive: 'primitiveSoundGetRecordingSampleRate'.
	rate := self cCode: 'snd_GetRecordingSampleRate()'.  "fail if not recording"
	^rate asFloatObj
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundGetVolume [
	"Set the sound input recording level."
	| left right results | 
	self primitive: 'primitiveSoundGetVolume'
		parameters: #( ).
	self var: #left type: 'double '.
	self var: #right type: 'double '.
	left := 0.
	right := 0.
	self cCode: 'snd_Volume((double *) &left,(double *) &right)'.
	interpreterProxy pushRemappableOop: (right asOop: Float).
	interpreterProxy pushRemappableOop: (left asOop: Float).
	interpreterProxy pushRemappableOop: (interpreterProxy instantiateClass: (interpreterProxy classArray) indexableSize: 2).
	results := interpreterProxy popRemappableOop.
	interpreterProxy storePointer: 0 ofObject: results withValue: interpreterProxy popRemappableOop.
	interpreterProxy storePointer: 1 ofObject: results withValue: interpreterProxy popRemappableOop.
	^ results
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundInsertSamples: frameCount from: buf leadTime: leadTime [ 
	"Insert a buffer's worth of sound samples into the currently playing  
	buffer. Used to make a sound start playing as quickly as possible. The  
	new sound is mixed with the previously buffered sampled."
	"Details: Unlike primitiveSoundPlaySamples, this primitive always starts  
	with the first sample the given sample buffer. Its third argument  
	specifies the number of samples past the estimated sound output buffer  
	position the inserted sound should start. If successful, it returns the  
	number of samples inserted."
	| framesPlayed |
	self primitive: 'primitiveSoundInsertSamples'
		parameters: #(SmallInteger WordArray SmallInteger ).
	interpreterProxy success: frameCount <= (interpreterProxy slotSizeOf: buf cPtrAsOop).

	interpreterProxy failed
		ifFalse: [framesPlayed := self cCode: 'snd_InsertSamplesFromLeadTime(frameCount, (int)buf, leadTime)'.
			interpreterProxy success: framesPlayed >= 0].
	^ framesPlayed asPositiveIntegerObj
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundPlaySamples: frameCount from: buf startingAt: startIndex [ 
	"Output a buffer's worth of sound samples."
	| framesPlayed |
	self primitive: 'primitiveSoundPlaySamples'
		parameters: #(SmallInteger WordArray SmallInteger ).
	interpreterProxy success: (startIndex >= 1 and: [startIndex + frameCount - 1 <= (interpreterProxy slotSizeOf: buf cPtrAsOop)]).

	interpreterProxy failed
		ifFalse: [framesPlayed := self cCode: 'snd_PlaySamplesFromAtLength(frameCount, (int)buf, startIndex - 1)'.
			interpreterProxy success: framesPlayed >= 0].
	^ framesPlayed asPositiveIntegerObj
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundPlaySilence [
	"Output a buffer's worth of silence. Returns the number of sample frames played."

	| framesPlayed |
	self primitive: 'primitiveSoundPlaySilence'.
	framesPlayed := self cCode: 'snd_PlaySilence()'.  "-1 if sound output not started"
	interpreterProxy success: framesPlayed >= 0.
	^framesPlayed asPositiveIntegerObj
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundRecordSamplesInto: buf startingAt: startWordIndex [ 
	"Record a buffer's worth of 16-bit sound samples."
	| bufSizeInBytes samplesRecorded |
	self primitive: 'primitiveSoundRecordSamples'
		parameters: #(WordArray SmallInteger ).

	interpreterProxy failed
		ifFalse: [bufSizeInBytes := (interpreterProxy slotSizeOf: buf cPtrAsOop) * 4.
			interpreterProxy success: (startWordIndex >= 1 and: [startWordIndex - 1 * 2 < bufSizeInBytes])].

	interpreterProxy failed ifFalse: [samplesRecorded := self cCode: 'snd_RecordSamplesIntoAtLength((int)buf, startWordIndex - 1, bufSizeInBytes)'].
	^ samplesRecorded asPositiveIntegerObj
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundSetLeftVolume: aLeftVolume rightVolume: aRightVolume [
	"Set the sound input recording level."

	self primitive: 'primitiveSoundSetLeftVolume'
		parameters: #(Float Float).
	interpreterProxy failed ifFalse: [self cCode: 'snd_SetVolume(aLeftVolume,aRightVolume)'].

]

{ #category : #primitives }
SoundPlugin >> primitiveSoundSetRecordLevel: level [ 
	"Set the sound input recording level."
	self primitive: 'primitiveSoundSetRecordLevel'
		parameters: #(SmallInteger ).
	interpreterProxy failed ifFalse: [self cCode: 'snd_SetRecordLevel(level)']
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundStartBufferSize: bufFrames rate: samplesPerSec stereo: stereoFlag [
	"Start the double-buffered sound output with the given buffer size, sample rate, and stereo flag."

	self primitive: 'primitiveSoundStart'
		parameters: #(SmallInteger SmallInteger Boolean).
	interpreterProxy success: (self cCode: 'snd_Start(bufFrames, samplesPerSec, stereoFlag, 0)')
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundStartBufferSize: bufFrames rate: samplesPerSec stereo: stereoFlag semaIndex: semaIndex [
	"Start the double-buffered sound output with the given buffer size, sample rate, stereo flag, and semaphore index."

	self primitive: 'primitiveSoundStartWithSemaphore'
		parameters: #(SmallInteger SmallInteger Boolean SmallInteger).
	interpreterProxy success: (self cCode: 'snd_Start(bufFrames, samplesPerSec, stereoFlag, semaIndex)')
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundStartRecordingDesiredSampleRate: desiredSamplesPerSec stereo: stereoFlag semaIndex: semaIndex [
	"Start recording sound with the given parameters."

	self primitive: 'primitiveSoundStartRecording'
		parameters: #(SmallInteger Boolean SmallInteger).
	self cCode: 'snd_StartRecording(desiredSamplesPerSec, stereoFlag, semaIndex)'
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundStop [
	"Stop double-buffered sound output."

	self primitive: 'primitiveSoundStop'.

	self cCode: 'snd_Stop()'.  "leave rcvr on stack"
]

{ #category : #primitives }
SoundPlugin >> primitiveSoundStopRecording [
	"Stop recording sound."

	self primitive: 'primitiveSoundStopRecording'.
	self cCode: 'snd_StopRecording()'.  "leave rcvr on stack"
]

{ #category : #'initialize-release' }
SoundPlugin >> shutdownModule [
	self export: true.
	^self cCode: 'soundShutdown()' inSmalltalk:[true]
]