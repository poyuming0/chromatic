package("blook")
    add_deps("cmake")
    add_syslinks("advapi32")
    set_sourcedir(path.join(os.scriptdir(), "blook"))
    on_install(function (package)
        local fcdir = package:cachedir() .. "/fetchcontent"
        local cxxflags = "/EHsc"
        if package:is_arch("x86") then
            cxxflags = cxxflags .. " --target=i686-pc-windows-msvc"
        end
        import("package.tools.cmake").install(package, {
                "-DCMAKE_INSTALL_PREFIX=" .. package:installdir(),
                "-DCMAKE_PREFIX_PATH=" .. package:installdir(),
                "-DFETCHCONTENT_QUIET=OFF",
                "-DFETCHCONTENT_BASE_DIR=" .. fcdir,
                "-DCMAKE_CXX_FLAGS=" .. cxxflags,
                "-DCMAKE_C_FLAGS=" .. (package:is_arch("x86") and "--target=i686-pc-windows-msvc" or ""),
        })
        
        os.cp("include/blook/**", package:installdir("include/blook/"))
        os.cp("external/zasm/zasm/include/**", package:installdir("include/zasm/"))
        os.cp(fcdir .. "/zydis-src/dependencies/zycore/include/**", package:installdir("include/zycore/"))
        os.cp(package:buildir() .. "/blook.lib", package:installdir("lib"))
        os.cp(package:buildir() .. "/external/zasm/zasm.lib", package:installdir("lib"))
    end)
package_end()
