# MSVC Local Build: ./build.ps1 -init
Param(
    # [switch]
    # $f, 
    [switch]
    $init
)

# Env. vars
$env:CCACHE_DIR = "./.ccache"
$env:CCACHE_COMPILERCHECK = "content"
$env:CCACHE_SLOPPINESS = "time_macros"

if ($init) {
    git config --global core.autocrlf input
}

# deps: ccache ninja wget ctest python3 (used by aqt command)
cmake -G Ninja `
    -DCMAKE_C_COMPILER=cl -DCMAKE_CXX_COMPILER=cl -B build `
    -DCMAKE_LINKER=link `
    -DCMAKE_BUILD_TYPE=Release `
    -DCMAKE_C_COMPILER_LAUNCHER=ccache `
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache `
    -DENABLE_QT_TRANSLATION=ON `
    -DCITRA_ENABLE_COMPATIBILITY_REPORTING=ON `
    -DENABLE_COMPATIBILITY_LIST_DOWNLOAD=ON `
    -DUSE_DISCORD_PRESENCE=ON `
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# cd ./build && ninja && ninja bundle
cmake --build ./build -j $Env:NUMBER_OF_PROCESSORS

ccache -s -v
ctest -VV -C Release || Write-Output "::error ::Test error occurred on Windows build"

# ./test.ps1
