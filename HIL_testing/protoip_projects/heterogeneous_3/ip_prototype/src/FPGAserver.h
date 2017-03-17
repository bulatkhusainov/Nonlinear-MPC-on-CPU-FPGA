/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


////////////////////////////////////////////////////////////
#define DEBUG 1 //1 to enable debug printf, 0 to disable debug printf


////////////////////////////////////////////////////////////
// Define FLOAT_FIX_VECTOR_NAME=1 to enable  fixed-point (up to 32 bits word length) arithmetic precision or 
// FLOAT_FIX_VECTOR_NAME=0 to enable floating-point single arithmetic precision.
#define FLOAT_FIX_MINRES_DATA_IN 0
#define FLOAT_FIX_BLOCK_IN 0
#define FLOAT_FIX_OUT_BLOCK_IN 0
#define FLOAT_FIX_X_IN_IN 0
#define FLOAT_FIX_Y_OUT_OUT 0

//Input vectors FRACTIONLENGTH:
#define MINRES_DATA_IN_FRACTIONLENGTH 0
#define BLOCK_IN_FRACTIONLENGTH 0
#define OUT_BLOCK_IN_FRACTIONLENGTH 0
#define X_IN_IN_FRACTIONLENGTH 0
//Output vectors FRACTIONLENGTH:
#define Y_OUT_OUT_FRACTIONLENGTH 0

////////////////////////////////////////////////////////////
//FPGA vectors memory maps
#define minres_data_IN_DEFINED_MEM_ADDRESS 0
#define block_IN_DEFINED_MEM_ADDRESS 20
#define out_block_IN_DEFINED_MEM_ADDRESS 40
#define x_in_IN_DEFINED_MEM_ADDRESS 60
#define y_out_OUT_DEFINED_MEM_ADDRESS 80


////////////////////////////////////////////////////////////
//Ethernet interface configuration:
#define TYPE_ETH 0 //1 for TCP, 0 for UDP
#define FPGA_IP "192.168.1.10" //FPGA IP
#define FPGA_NM "255.255.255.0" //Netmask
#define FPGA_GW "192.168.1.1" //Gateway
#define FPGA_PORT 2007


///////////////////////////////////////////////////////////////
//////////////////DO NOT EDIT HERE BELOW///////////////////////
//FPGA interface data specification:
#define ETH_PACKET_LENGTH 256+2 //Ethernet packet length in double words (32 bits) (from Matlab to  FPGA)
#define ETH_PACKET_LENGTH_RECV 64+2 //Ethernet packet length in double words (32 bits) (from FPGA to Matlab)


