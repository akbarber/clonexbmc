#.rst:
# FindCdio
# --------
# Finds the cdio library
#
# This will define the following variables::
#
# CDIO_FOUND - system has cdio
# CDIO_INCLUDE_DIRS - the cdio include directory
# CDIO_LIBRARIES - the cdio libraries
#
# and the following imported targets::
#
#   CDIO::CDIO - The cdio library

if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_CDIO libcdio>=0.78 libiso9660 QUIET)
endif()

find_path(CDIO_INCLUDE_DIR NAMES cdio/cdio.h
                           PATHS ${PC_CDIO_libcdio_INCLUDEDIR}
                                 ${PC_CDIO_libiso9660_INCLUDEDIR})
find_library(CDIO_LIBRARY NAMES cdio libcdio
                          PATHS ${CDIO_libcdio_LIBDIR} ${CDIO_libiso9660_LIBDIR})

if(NOT WIN32)
  find_path(ISO9660_INCLUDE_DIR NAMES cdio/iso9660.h
                                PATHS ${PC_CDIO_libcdio_INCLUDEDIR}
                                      ${PC_CDIO_libiso9660_INCLUDEDIR})
  find_library(ISO9660_LIBRARY NAMES iso9660
                               PATHS ${CDIO_libcdio_LIBDIR} ${CDIO_libiso9660_LIBDIR})
  list(APPEND ISO9660_VARS ISO9660_INCLUDE_DIR ISO9660_LIBRARY)
endif()

set(CDIO_VERSION ${PC_CDIO_libcdio_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Cdio
                                  REQUIRED_VARS CDIO_LIBRARY CDIO_INCLUDE_DIR ${ISO9660_VARS}
                                  VERSION_VAR CDIO_VERSION)

if(CDIO_FOUND)
  set(CDIO_LIBRARIES ${CDIO_LIBRARY} ${ISO9660_LIBRARY})
  set(CDIO_INCLUDE_DIRS ${CDIO_INCLUDE_DIR} ${ISO9660_INCLUDE_DIR})

  if(NOT TARGET CDIO::CDIO)
    add_library(CDIO::CDIO UNKNOWN IMPORTED)
    set_target_properties(CDIO::CDIO PROPERTIES
                                     IMPORTED_LOCATION "${CDIO_LIBRARY}"
                                     INTERFACE_INCLUDE_DIRECTORIES "${CDIO_INCLUDE_DIR}")
  endif()
endif()

mark_as_advanced(CDIO_INCLUDE_DIR CDIO_LIBRARY ISO9660_INCLUDE_DIR ISO9660_LIBRARY)
