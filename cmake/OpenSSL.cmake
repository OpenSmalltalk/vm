set(OpenSSL_Spec_URL "https://www.openssl.org/source/openssl-1.0.2q.tar.gz")
set(OpenSSL_Spec_ArchiveName openssl-1.0.2q.tar.gz)
set(OpenSSL_Spec_ArchiveSha256 5744cfcbcec2b1b48629f7354203bc1e5e9b5466998bbccc5b5fcde3b18eb684)

set(OpenSSL_Spec_MacLibraries libssl.1.0.0.dylib libcrypto.1.0.0.dylib)
set(OpenSSL_Spec_MacLibrariesSymlinks libssl*.dylib libcrypto*.dylib)
set(OpenSSL_Spec_LinuxLibraries libssl.so.1.0.0 libcrypto.so.1.0.0)
set(OpenSSL_Spec_LinuxLibrariesSymlinks libssl.so* libcrypto.so*)
set(OpenSSL_Spec_WindowsDLLs ssleay32.dll libeay32.dll)

#-------------------------------------------------------------------------------
# OpenSSL dependency building
#-------------------------------------------------------------------------------
check_thirdparty_build_artifacts(HaveCachedOpenSSL
    MAC_LIBRARIES ${OpenSSL_Spec_MacLibraries}
    LINUX_LIBRARIES ${OpenSSL_Spec_LinuxLibraries}
    WINDOWS_DLLS ${OpenSSL_Spec_WindowsDLLs}
)

if(HaveCachedOpenSSL)
    set(OpenSSL_BuildDep)
    message(STATUS "Not building cached OpenSSL")
else()
    if(DARWIN)
        set(OpenSSL_ConfigureCommand "./Configure" darwin64-x86_64-cc
            "--prefix=${ThirdPartyCacheInstall}" shared )
        set(OpenSSL_BuildCommand
            "LDFLAGS=-Wl,-rpath,@executable_path:@executable_path/Plugins"
            make
            -s
        )
    elseif(WIN32)
        if(SQUEAK_PLATFORM_X86_64)
            set(OpenSSL_ConfigureCommand "./Configure" mingw64
                "--prefix=${ThirdPartyCacheInstall}" shared)
        elseif(SQUEAK_PLATFORM_X86_32)
            set(OpenSSL_ConfigureCommand "./Configure" mingw
                "--prefix=${ThirdPartyCacheInstall}" shared)
        endif()
        set(OpenSSL_BuildCommand make)
    else(UNIX)
        if(SQUEAK_PLATFORM_X86_64)
            set(OpenSSL_ConfigureCommand "./Configure" linux-generic32
                "--prefix=${ThirdPartyCacheInstall}" shared)
        elseif(SQUEAK_PLATFORM_X86_32)
            set(OpenSSL_ConfigureCommand setarch i386 ./config -m32
                "--prefix=${ThirdPartyCacheInstall}" shared)
        endif()
        set(OpenSSL_BuildCommand make)
    endif()

    ExternalProject_Add(OpenSSL
        URL ${OpenSSL_Spec_URL}
        URL_HASH "SHA256=${OpenSSL_Spec_ArchiveSha256}"
        DOWNLOAD_NAME ${OpenSSL_Spec_ArchiveName}
        DOWNLOAD_DIR "${ThirdPartyCacheDownloadDirectory}"
        PREFIX "${CMAKE_CURRENT_BINARY_DIR}/thirdparty/OpenSSL"
        CONFIGURE_COMMAND "${OpenSSL_ConfigureCommand}"
        BUILD_COMMAND "${OpenSSL_BuildCommand}"
        BUILD_IN_SOURCE TRUE
    )
    set(OpenSSL_BuildDep OpenSSL)
    if(PkgConfig_BuildDep)
        add_dependencies(OpenSSL ${PkgConfig_BuildDep})
    endif()
endif()

install_thirdparty_build_artifacts(OpenSSL
    MAC_LIBRARIES ${OpenSSL_Spec_MacLibraries}
    MAC_LIBRARIES_SYMLINK_PATTERNS ${OpenSSL_Spec_MacLibrariesSymlinks}
    LINUX_LIBRARIES ${OpenSSL_Spec_LinuxLibraries}
    LINUX_LIBRARIES_SYMLINK_PATTERNS ${OpenSSL_Spec_LinuxLibrariesSymlinks}
    WINDOWS_DLLS ${OpenSSL_Spec_WindowsDLLs}
)
