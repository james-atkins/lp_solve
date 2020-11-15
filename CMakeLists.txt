cmake_minimum_required(VERSION 3.5)

project(lp_solve LANGUAGES C)

include(CheckFunctionExists)
find_package(BLAS REQUIRED)

check_function_exists(isnan HAVE_ISNAN)

find_library(MATH_LIBRARY m)

add_library(lpsolve55
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_MDO.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/shared/commonlib.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/shared/mmio.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/shared/myblas.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/ini.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/fortify.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/colamd/colamd.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_rlp.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_crash.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/bfp/bfp_LUSOL/lp_LUSOL.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/bfp/bfp_LUSOL/LUSOL/lusol.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_Hash.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_lib.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_wlp.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_matrix.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_mipbb.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_MPS.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_params.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_presolve.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_price.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_pricePSE.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_report.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_scale.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_simplex.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_SOS.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_utils.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/yacc_read.c"
)

set_target_properties(lpsolve55 PROPERTIES
    C_STANDARD 99
    POSITION_INDEPENDENT_CODE ON
    PUBLIC_HEADER "lp_SOS.h;lp_Hash.h;lp_lib.h;lp_matrix.h;lp_types.h;lp_utils.h;lp_mipbb.h"
)

target_include_directories(lpsolve55
    PUBLIC
        $<INSTALL_INTERFACE:include>    
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}"
        "${CMAKE_CURRENT_SOURCE_DIR}/shared"
        "${CMAKE_CURRENT_SOURCE_DIR}/bfp"
        "${CMAKE_CURRENT_SOURCE_DIR}/bfp/bfp_LUSOL"
        "${CMAKE_CURRENT_SOURCE_DIR}/bfp/bfp_LUSOL/LUSOL"
        "${CMAKE_CURRENT_SOURCE_DIR}/colamd"
)

target_compile_definitions(lpsolve55 PRIVATE
	YY_NEVER_INTERACTIVE
	PARSER_LP
	INVERSE_ACTIVE=INVERSE_LUSOL
	RoleIsExternalInvEngine
)

if (NOT HAVE_ISNAN)
    target_compile_definitions(lpsolve55 PUBLIC NOISNAN)
endif()

if(APPLE)
    target_compile_definitions(lpsolve55 PRIVATE INTEGERTIME)
endif()

target_link_libraries(lpsolve55 PRIVATE ${BLAS_LIBRARIES} ${CMAKE_DL_LIBS})
if(MATH_LIBRARY)
    target_link_libraries(lpsolve55 PRIVATE ${MATH_LIBRARY})
endif()

add_executable(lp_solve
    "${CMAKE_CURRENT_SOURCE_DIR}/lp_solve/lp_solve.c"
)

target_link_libraries(lp_solve lpsolve55)

