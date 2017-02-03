################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/echo.c \
../src/foo_function_wrapped.c \
../src/i2c_access.c \
../src/main.c \
../src/platform.c \
../src/platform_mb.c \
../src/platform_ppc.c \
../src/platform_zynq.c \
../src/sfp.c \
../src/si5324.c \
../src/soc_user.c \
../src/user_block.c \
../src/user_bounds.c \
../src/user_gradient.c \
../src/user_hessians.c \
../src/user_jacobians.c \
../src/user_lanczos.c \
../src/user_minres.c \
../src/user_mv_mult.c \
../src/user_mv_mult_prescaled.c \
../src/user_nlp_solver.c \
../src/user_prescaler.c \
../src/user_rec_sol.c \
../src/user_residual.c 

OBJS += \
./src/echo.o \
./src/foo_function_wrapped.o \
./src/i2c_access.o \
./src/main.o \
./src/platform.o \
./src/platform_mb.o \
./src/platform_ppc.o \
./src/platform_zynq.o \
./src/sfp.o \
./src/si5324.o \
./src/soc_user.o \
./src/user_block.o \
./src/user_bounds.o \
./src/user_gradient.o \
./src/user_hessians.o \
./src/user_jacobians.o \
./src/user_lanczos.o \
./src/user_minres.o \
./src/user_mv_mult.o \
./src/user_mv_mult_prescaled.o \
./src/user_nlp_solver.o \
./src/user_prescaler.o \
./src/user_rec_sol.o \
./src/user_residual.o 

C_DEPS += \
./src/echo.d \
./src/foo_function_wrapped.d \
./src/i2c_access.d \
./src/main.d \
./src/platform.d \
./src/platform_mb.d \
./src/platform_ppc.d \
./src/platform_zynq.d \
./src/sfp.d \
./src/si5324.d \
./src/soc_user.d \
./src/user_block.d \
./src/user_bounds.d \
./src/user_gradient.d \
./src/user_hessians.d \
./src/user_jacobians.d \
./src/user_lanczos.d \
./src/user_minres.d \
./src/user_mv_mult.d \
./src/user_mv_mult_prescaled.d \
./src/user_nlp_solver.d \
./src/user_prescaler.d \
./src/user_rec_sol.d \
./src/user_residual.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O2 -c -fmessage-length=0 -MT"$@" -I../../test_fpga_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


