#include <math.h>
#include "../../HIL_testing/protoip_projects/heterogeneous_3/soc_prototype/src/FPGAclientAPI.h"
#include "../../src/user_main_header.h"


void soc_simulink_wrapper(double *x_init, double *theta_opt)
{


	//double x_init[n_states] = {1,2,3,4}; // comes from the function interface
	//double theta_opt[n_all_theta]; // comes from the function interface
	double dummy_input[1];
	double dummy_output[1];
	unsigned packet_input_size;
	unsigned Packet_type;
	unsigned packet_internal_ID ;
	unsigned packet_output_size = 1;
	
	double time_fpga_int;

	//reset ip
	Packet_type = 1;
	packet_internal_ID = 0;
	packet_output_size=1;
	dummy_input[0] = 1;
	packet_input_size = 1;
	FPGAclient( dummy_input, packet_input_size, Packet_type, packet_internal_ID, packet_output_size, dummy_output,&time_fpga_int);

	//send data to FPGA
	Packet_type = 3;
	packet_internal_ID = 0;
	packet_output_size=1;
	packet_input_size = n_states;
	FPGAclient( x_init, packet_input_size, Packet_type, packet_internal_ID, packet_output_size, dummy_output,&time_fpga_int);

	//start FPGA
	Packet_type = 2;
	packet_internal_ID = 0;
	packet_output_size=1;
	packet_input_size = 1;
	FPGAclient( dummy_input, packet_input_size, Packet_type, packet_internal_ID, packet_output_size, dummy_output,&time_fpga_int);

	// read data from FPGA
	Packet_type = 4;
	packet_internal_ID = 0;
	packet_output_size=n_all_theta;
	packet_input_size = 1;
	FPGAclient( dummy_input, packet_input_size, Packet_type, packet_internal_ID, packet_output_size, theta_opt,&time_fpga_int);

}