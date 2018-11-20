/* Automatically generated by
	VMPluginCodeGenerator VMMaker.oscog-eem.2480 uuid: bb3ffda7-8241-4dea-b886-d656e474b6c1
   from
	SoundCodecPlugin VMMaker.oscog-eem.2480 uuid: bb3ffda7-8241-4dea-b886-d656e474b6c1
 */
static char __buildInfo[] = "SoundCodecPlugin VMMaker.oscog-eem.2480 uuid: bb3ffda7-8241-4dea-b886-d656e474b6c1 " __DATE__ ;



#include "config.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/* Default EXPORT macro that does nothing (see comment in sq.h): */
#define EXPORT(returnType) returnType

/* Do not include the entire sq.h file but just those parts needed. */
#include "sqConfig.h"			/* Configuration options */
#include "sqVirtualMachine.h"	/*  The virtual machine proxy definition */
#include "sqPlatformSpecific.h"	/* Platform specific definitions */

#define true 1
#define false 0
#define null 0  /* using 'null' because nil is predefined in Think C */
#ifdef SQUEAK_BUILTIN_PLUGIN
# undef EXPORT
# define EXPORT(returnType) static returnType
#endif

#include "SoundCodecPrims.h"
#include "sqMemoryAccess.h"


/*** Function Prototypes ***/
EXPORT(const char*) getModuleName(void);
EXPORT(sqInt) primitiveGSMDecode(void);
EXPORT(sqInt) primitiveGSMEncode(void);
EXPORT(sqInt) primitiveGSMNewState(void);
EXPORT(sqInt) setInterpreter(struct VirtualMachine *anInterpreter);


/*** Variables ***/

#if !defined(SQUEAK_BUILTIN_PLUGIN)
static sqInt (*classByteArray)(void);
static sqInt (*failed)(void);
static sqInt (*instantiateClassindexableSize)(sqInt classPointer, sqInt size);
static sqInt (*isBytes)(sqInt oop);
static sqInt (*isWords)(sqInt oop);
static sqInt (*makePointwithxValueyValue)(sqInt xValue, sqInt yValue);
static sqInt (*popthenPush)(sqInt nItems, sqInt oop);
static sqInt (*slotSizeOf)(sqInt oop);
static sqInt (*stackIntegerValue)(sqInt offset);
static sqInt (*stackValue)(sqInt offset);
static sqInt (*success)(sqInt aBoolean);
#else /* !defined(SQUEAK_BUILTIN_PLUGIN) */
extern sqInt classByteArray(void);
extern sqInt failed(void);
extern sqInt instantiateClassindexableSize(sqInt classPointer, sqInt size);
extern sqInt isBytes(sqInt oop);
extern sqInt isWords(sqInt oop);
extern sqInt makePointwithxValueyValue(sqInt xValue, sqInt yValue);
extern sqInt popthenPush(sqInt nItems, sqInt oop);
extern sqInt slotSizeOf(sqInt oop);
extern sqInt stackIntegerValue(sqInt offset);
extern sqInt stackValue(sqInt offset);
extern sqInt success(sqInt aBoolean);
extern
#endif
struct VirtualMachine* interpreterProxy;
static const char *moduleName =
#ifdef SQUEAK_BUILTIN_PLUGIN
	"SoundCodecPrims VMMaker.oscog-eem.2480 (i)"
#else
	"SoundCodecPrims VMMaker.oscog-eem.2480 (e)"
#endif
;



/*	Note: This is hardcoded so it can be run from Squeak.
	The module name is used for validating a module *after*
	it is loaded to check if it does really contain the module
	we're thinking it contains. This is important! */

	/* InterpreterPlugin>>#getModuleName */
EXPORT(const char*)
getModuleName(void)
{
	return moduleName;
}

	/* SoundCodecPlugin>>#primitiveGSMDecode */
EXPORT(sqInt)
primitiveGSMDecode(void)
{
    sqInt dst;
    sqInt dstDelta;
    sqInt dstIndex;
    sqInt dstSize;
    sqInt frameCount;
    sqInt result;
    sqInt src;
    sqInt srcDelta;
    sqInt srcIndex;
    sqInt srcSize;
    sqInt state;

	dstDelta = 0;
	srcDelta = 0;
	dstIndex = stackIntegerValue(0);
	dst = stackValue(1);
	srcIndex = stackIntegerValue(2);
	src = stackValue(3);
	frameCount = stackIntegerValue(4);
	state = stackValue(5);
	success(isWords(dst));
	success(isBytes(src));
	success(isBytes(state));
	if (failed()) {
		return null;
	}
	srcSize = slotSizeOf(src);
	dstSize = (slotSizeOf(dst)) * 2;
	gsmDecode(state + BaseHeaderSize, frameCount, src, srcIndex, srcSize, dst, dstIndex, dstSize, &srcDelta, &dstDelta);
	if (failed()) {
		return null;
	}
	result = makePointwithxValueyValue(srcDelta, dstDelta);
	if (failed()) {
		return null;
	}
	popthenPush(6, result);
	return 0;
}

	/* SoundCodecPlugin>>#primitiveGSMEncode */
EXPORT(sqInt)
primitiveGSMEncode(void)
{
    sqInt dst;
    sqInt dstDelta;
    sqInt dstIndex;
    sqInt dstSize;
    sqInt frameCount;
    sqInt result;
    sqInt src;
    sqInt srcDelta;
    sqInt srcIndex;
    sqInt srcSize;
    sqInt state;

	dstDelta = 0;
	srcDelta = 0;
	dstIndex = stackIntegerValue(0);
	dst = stackValue(1);
	srcIndex = stackIntegerValue(2);
	src = stackValue(3);
	frameCount = stackIntegerValue(4);
	state = stackValue(5);
	success(isBytes(dst));
	success(isWords(src));
	success(isBytes(state));
	if (failed()) {
		return null;
	}
	srcSize = (slotSizeOf(src)) * 2;
	dstSize = slotSizeOf(dst);
	gsmEncode(state + BaseHeaderSize, frameCount, src, srcIndex, srcSize, dst, dstIndex, dstSize, &srcDelta, &dstDelta);
	if (failed()) {
		return null;
	}
	result = makePointwithxValueyValue(srcDelta, dstDelta);
	if (failed()) {
		return null;
	}
	popthenPush(6, result);
	return 0;
}

	/* SoundCodecPlugin>>#primitiveGSMNewState */
EXPORT(sqInt)
primitiveGSMNewState(void)
{
    sqInt state;

	state = instantiateClassindexableSize(classByteArray(), gsmStateBytes());
	gsmInitState(state + BaseHeaderSize);
	popthenPush(1, state);
	return 0;
}


/*	Note: This is coded so that it can be run in Squeak. */

	/* InterpreterPlugin>>#setInterpreter: */
EXPORT(sqInt)
setInterpreter(struct VirtualMachine *anInterpreter)
{
    sqInt ok;

	interpreterProxy = anInterpreter;
	ok = ((interpreterProxy->majorVersion()) == (VM_PROXY_MAJOR))
	 && ((interpreterProxy->minorVersion()) >= (VM_PROXY_MINOR));
	if (ok) {
		
#if !defined(SQUEAK_BUILTIN_PLUGIN)
		classByteArray = interpreterProxy->classByteArray;
		failed = interpreterProxy->failed;
		instantiateClassindexableSize = interpreterProxy->instantiateClassindexableSize;
		isBytes = interpreterProxy->isBytes;
		isWords = interpreterProxy->isWords;
		makePointwithxValueyValue = interpreterProxy->makePointwithxValueyValue;
		popthenPush = interpreterProxy->popthenPush;
		slotSizeOf = interpreterProxy->slotSizeOf;
		stackIntegerValue = interpreterProxy->stackIntegerValue;
		stackValue = interpreterProxy->stackValue;
		success = interpreterProxy->success;
#endif /* !defined(SQUEAK_BUILTIN_PLUGIN) */
	}
	return ok;
}


#ifdef SQUEAK_BUILTIN_PLUGIN

static char _m[] = "SoundCodecPrims";
void* SoundCodecPrims_exports[][3] = {
	{(void*)_m, "getModuleName", (void*)getModuleName},
	{(void*)_m, "primitiveGSMDecode\000\000", (void*)primitiveGSMDecode},
	{(void*)_m, "primitiveGSMEncode\000\000", (void*)primitiveGSMEncode},
	{(void*)_m, "primitiveGSMNewState\000\377", (void*)primitiveGSMNewState},
	{(void*)_m, "setInterpreter", (void*)setInterpreter},
	{NULL, NULL, NULL}
};

#else /* ifdef SQ_BUILTIN_PLUGIN */

signed char primitiveGSMDecodeAccessorDepth = 0;
signed char primitiveGSMEncodeAccessorDepth = 0;

#endif /* ifdef SQ_BUILTIN_PLUGIN */
