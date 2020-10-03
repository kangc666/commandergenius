# If SDL_Mixer should link to GPL-polluted libMAD (TODO: move this out of here)
SDL_MIXER_USE_LIBMAD :=
ifneq ($(strip $(filter mad, $(COMPILED_LIBRARIES))),)
SDL_MIXER_USE_LIBMAD := 1
endif

NDK_VERSION := $(strip $(patsubst android-ndk-%,%,$(filter android-ndk-%, $(subst /, ,$(dir $(TARGET_CC))))))
#$(info NDK version $(NDK_VERSION)) # This warning puzzles ndk-gdb
ifneq ($(filter r1 r2 r3 r4 r5 r6 r7 r8,$(NDK_VERSION)),)
$(error Your NDK $(NDK_VERSION) is too old, please download NDK from http://developer.android.com)
endif

NDK_PATH := $(shell dirname $(shell which ndk-build))

NDK_SUBDIR_MAKEFILES_FULL := $(call all-subdir-makefiles)

# If you want to exclude certain subprojects from the build process.
# v.g.: SDL2_image already brings it's own implementation of png, so we exclude the bundled one
ifeq ($(SDL_VERSION),2.0)
BLACKLISTED_SUBPROJECTS := jpeg png ogg mpg123 timidity fluidsynth faad openal sdl_blitpool sdl_gfx sdl_image sdl_main sdl_mixer sdl_net sdl_sound sdl_ttf zzip
else
BLACKLISTED_SUBPROJECTS := sdl2_image
endif

BLACKLISTED_MAKEFILES := $(addprefix jni/../jni/,$(BLACKLISTED_SUBPROJECTS))
BLACKLISTED_MAKEFILES := $(addsuffix /Android.mk,$(BLACKLISTED_MAKEFILES))

NDK_SUBDIR_MAKEFILES := $(filter-out $(BLACKLISTED_MAKEFILES), $(NDK_SUBDIR_MAKEFILES_FULL))

include $(NDK_SUBDIR_MAKEFILES)
