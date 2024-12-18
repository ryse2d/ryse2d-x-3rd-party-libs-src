# libuv

LIBUV_GITURL := https://github.com/libuv/libuv

$(TARBALLS)/libuv-git.tar.xz:
	$(call download_git,$(LIBUV_GITURL),master,69c43d987b6aca)


uv: libuv-git.tar.xz 
	$(UNPACK)
	$(APPLY) $(SRC)/uv/android_remove_pthread_rt.patch
	$(MOVE)

ifdef HAVE_ANDROID
cmake_android_def = -DANDROID=1 -DCMAKE_SYSTEM_NAME=Android
endif

.uv: uv toolchain.cmake
	cd $< && $(HOSTVARS) CFLAGS="$(CFLAGS) $(EX_ECFLAGS)" $(CMAKE) -DBUILD_TESTING=OFF $(cmake_android_def) $(make_option) 
	cd $< && $(MAKE) VERBOSE=1 install
	touch $@
