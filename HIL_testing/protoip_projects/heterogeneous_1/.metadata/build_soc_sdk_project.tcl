# ##############################################################################################
# icl::protoip
# Author: asuardi <https://github.com/asuardi>
# Date: November - 2014
# ##############################################################################################



set workspace_name "workspace1"
set hdf "design_1_wrapper.hdf"

sdk set_workspace $workspace_name
sdk create_hw_project -name design_1_wrapper_hw_platform_1 -hwspec $hdf
sdk create_app_project -name test_fpga -proc ps7_cortexa9_0 -hwproject design_1_wrapper_hw_platform_1 -lang C  -app {lwIP Echo Server}

#added by Bulat
sdk configapp -app test_fpga build-config Release
sdk configapp -app test_fpga libraries m
sdk configapp -app test_fpga compiler-misc {-O3}
#end added by Bulat

file copy -force ../../../src/echo.c workspace1/test_fpga/src
file copy -force ../../../src/main.c workspace1/test_fpga/src
file copy -force ../../../src/FPGAserver.h workspace1/test_fpga/src
file copy -force ../../../src/foo_function_wrapped.h workspace1/test_fpga/src
file copy -force ../../../src/foo_function_wrapped.c workspace1/test_fpga/src

#added by Bulat
# copy all the files that have word 'user' in their names
set pattern "" 
append pattern ../../../src/*user*
set file_list [glob $pattern]
foreach file $file_list {
	file copy -force $file "workspace1/test_fpga/src"
}

# copy project settings in xml format
#if { [file exists ../../../src/.cproject] } {
#	file copy -force ../../../src/.cproject workspace1/test_fpga/.cproject
#}
#
#if { [file exists ../../../src/.project] } {
#	file copy -force ../../../src/.project workspace1/test_fpga/.project
#}
#end added by Bulat

sdk build_project -type all
