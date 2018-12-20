"
This class adds generalized block parameter access to C objects for vm simulation
"
Class {
	#name : #CPluggableAccessor,
	#superclass : #CArrayAccessor,
	#instVars : [
		'readBlock',
		'writeBlock'
	],
	#category : #'VMMaker-InterpreterSimulation'
}

{ #category : #accessing }
CPluggableAccessor >> at: index [
	^readBlock value: object value: index + offset + 1
]

{ #category : #accessing }
CPluggableAccessor >> at: index put: value [
	^writeBlock value: object value: index + offset + 1 value: value
]

{ #category : #initialize }
CPluggableAccessor >> atBlock: rBlock atPutBlock: wBlock [
	readBlock := rBlock.
	writeBlock := wBlock
]

{ #category : #initialize }
CPluggableAccessor >> readBlock: rBlock writeBlock: wBlock [
	readBlock := rBlock.
	writeBlock := wBlock
]