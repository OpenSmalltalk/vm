"
Special VMMaker class for Acorn RiscOS - add generation of a configuration file for each plugin, required by the dynamic loading libraries
"
Class {
	#name : #RiscOSVMMaker,
	#superclass : #VMMaker,
	#category : #'VMMaker-Building'
}

{ #category : #initialize }
RiscOSVMMaker >> createCodeGenerator [
"set up a CCodeGenerator for this VMMaker - RiscOS uses the global struct and no local def of the structure because of the global register trickery"
	^CCodeGeneratorGlobalStructure new initialize; globalStructDefined: false
]

{ #category : #'generate sources' }
RiscOSVMMaker >> export: exportList forExternalPlugin: aPlugin [
"it may be useful on certain platforms to do something with the export list of external plugins, just as the internal plugins' exports get added to the VM list. Default is to do nothing though."
"For RiscOS using the 'rink' external linker each plugin needs a 'dsc' file that looks like
id:SqueakSO
main_version:100
code_version:001

entries:
//
named_entries:
getModuleName
//
with all the exported names in the list. We also need a '/o' directory for the object files"

	"open a file called plugindir/pluginname.dsc and write into it"
	| f fd dfd |
	fd := self externalPluginsDirectoryFor: aPlugin.

	"If we get an error to do with opening the .dsc file, we need to raise an application error to suit"
	[(fd directoryExists: 'dsc') ifFalse:[fd createDirectory: 'dsc'].
	dfd := fd directoryNamed: 'dsc'.
	f := CrLfFileStream forceNewFileNamed: (dfd fullNameFor: aPlugin moduleName)] on: FileStreamException do:[^self couldNotOpenFile: (dfd fullNameFor: aPlugin moduleName)].

	f nextPutAll: 'id:SqueakSO
main_version:100
code_version:001

entries:
//
named_entries:
'.
	exportList do:[:el|
		f nextPutAll: el.
		f cr].
	f nextPutAll: '//'; cr.
	f close.
	(fd directoryNamed: 'o') assureExistence

]

{ #category : #'generate sources' }
RiscOSVMMaker >> interpreterExportsFilePath [
	"return the full path for the interpreter exports file"
	"RiscOS keeps the exports file in a 'h' subdirectory of coreVMDirectory"
	self coreVMDirectory assureExistenceOfPath: 'h'.
	^(self coreVMDirectory directoryNamed: 'h') fullNameFor: 'sqNamedPrims'
]

{ #category : #'generate sources' }
RiscOSVMMaker >> interpreterFilePath [
	"return the full path for the interpreter file"
	"RiscOS keeps the interp file in a 'c' subdirectory of coreVMDirectory"
	self coreVMDirectory assureExistenceOfPath: 'c'.
	^(self coreVMDirectory directoryNamed: 'c') fullNameFor: self interpreterFilename
]

{ #category : #'target directories' }
RiscOSVMMaker >> interpreterFilename [
	"what is the filename for the core interpreter. Default is interp.c"
	^'interp'
]

{ #category : #'generate sources' }
RiscOSVMMaker >> interpreterHeaderPath [
	"return the full path for the interpreter header file"
	"RiscOS keeps the interp file in a 'h' subdirectory of coreVMDirectory"
	self coreVMDirectory assureExistenceOfPath: 'h'.
	^(self coreVMDirectory directoryNamed: 'h') fullNameFor: self interpreterFilename
]

{ #category : #initialize }
RiscOSVMMaker >> needsToRegenerateInterpreterFile [
"check the timestamp for the relevant classes and then the timestamp for the interp.c file if it already exists. Return true if the file needs regenerating, false if not"

	| tStamp fstat |
	tStamp := { self interpreterClass. ObjectMemory} inject: 0 into: [:tS :cl|
		tS := tS max: cl timeStamp].

	"don't translate if the file is newer than my timeStamp"
	"RiscOS keeps the interp file in a 'c' subdirectory of coreVMDirectory"
	(self coreVMDirectory directoryExists: 'c') ifFalse:[^true].

	fstat := (self coreVMDirectory directoryNamed: 'c') entryAt: self interpreterFilename ifAbsent:[nil].
	fstat ifNotNil:[tStamp < fstat modificationTime ifTrue:[^false]].
	^true

]

{ #category : #'processing external files' }
RiscOSVMMaker >> processFilesForExternalPlugin: plugin [ 
	"After the plugin has created any files we need to move them around a little to suit RiscOS; any *.c file must be moved to a 'c' subdirectory, likwise any h file"
	| files fd |
	files := (fd := self externalPluginsDirectoryFor: plugin) fileNamesMatching:'*.c'.
	files notEmpty ifTrue:[fd assureExistenceOfPath: 'c'.
		files do:[:fn|
			self copyFileNamed: (fd fullNameFor: fn) to: ((fd directoryNamed:'c') fullNameFor:(fn allButLast: 2)).
			fd deleteFileNamed: fn]].

	files := (self externalPluginsDirectoryFor: plugin) fileNamesMatching:'*.h'.
	files notEmpty ifTrue:[fd assureExistenceOfPath: 'h'.
		files do:[:fn|
			self copyFileNamed: (fd fullNameFor: fn) to: ((fd directoryNamed:'h') fullNameFor:(fn allButLast: 2)).
			fd deleteFileNamed: fn]].
	super processFilesForExternalPlugin: plugin

]

{ #category : #'processing external files' }
RiscOSVMMaker >> processFilesForInternalPlugin: plugin [ 
	"After the plugin has created any files we need to move them around a little to suit RiscOS; any *.c file must be moved to a 'c' subdirectory, likwise any h file"
	| files fd |
	files := (fd := self internalPluginsDirectoryFor: plugin) fileNamesMatching:'*.c'.
	files notEmpty ifTrue:[fd assureExistenceOfPath: 'c'.
		files do:[:fn|
			self copyFileNamed: (fd localNameFor: fn) to: ((fd directoryNamed:'c') localNameFor:(fn allButLast: 2)).
			fd deleteFileNamed: fn]].

	files := (self internalPluginsDirectoryFor: plugin) fileNamesMatching:'*.h'.
	files notEmpty ifTrue:[fd assureExistenceOfPath: 'h'.
		files do:[:fn|
			self copyFileNamed: (fd localNameFor: fn) to: ((fd directoryNamed:'h') localNameFor:(fn allButLast: 2)).
			fd deleteFileNamed: fn]].
	super processFilesForInternalPlugin: plugin

]

{ #category : #exports }
RiscOSVMMaker >> storeExternalPluginList [
	"RiscOS doesn't need this"
]

{ #category : #exports }
RiscOSVMMaker >> storeInternalPluginList [
	"RiscOS doesn't need this"
]