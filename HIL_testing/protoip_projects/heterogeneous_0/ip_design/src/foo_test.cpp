/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"



void foo	(	
				uint32_t byte_block_in_offset,
				uint32_t byte_x_in_in_offset,
				uint32_t byte_y_out_out_offset,
				volatile data_t_memory *memory_inout);


using namespace std;
#define BUF_SIZE 64

//Input and Output vectors base addresses in the virtual memory
#define block_IN_DEFINED_MEM_ADDRESS 0
#define x_in_IN_DEFINED_MEM_ADDRESS (BLOCK_IN_LENGTH)*4
#define y_out_OUT_DEFINED_MEM_ADDRESS (BLOCK_IN_LENGTH+X_IN_IN_LENGTH)*4


int main()
{

	char filename[BUF_SIZE]={0};

    int max_iter;

	uint32_t byte_block_in_offset;
	uint32_t byte_x_in_in_offset;
	uint32_t byte_y_out_out_offset;

	int32_t tmp_value;

	//assign the input/output vectors base address in the DDR memory
	byte_block_in_offset=block_IN_DEFINED_MEM_ADDRESS;
	byte_x_in_in_offset=x_in_IN_DEFINED_MEM_ADDRESS;
	byte_y_out_out_offset=y_out_OUT_DEFINED_MEM_ADDRESS;

	//allocate a memory named address of uint32_t or float words. Number of words is 1024 * (number of inputs and outputs vectors)
	data_t_memory *memory_inout;
	memory_inout = (data_t_memory *)malloc((BLOCK_IN_LENGTH+X_IN_IN_LENGTH+Y_OUT_OUT_LENGTH)*4); //malloc size should be sum of input and output vector lengths * 4 Byte

	FILE *stimfile;
	FILE * pFile;
	int count_data;


	float *block_in;
	block_in = (float *)malloc(BLOCK_IN_LENGTH*sizeof (float));
	float *x_in_in;
	x_in_in = (float *)malloc(X_IN_IN_LENGTH*sizeof (float));
	float *y_out_out;
	y_out_out = (float *)malloc(Y_OUT_OUT_LENGTH*sizeof (float));


	////////////////////////////////////////
	//read block_in vector

	// Open stimulus block_in.dat file for reading
	sprintf(filename,"block_in.dat");
	stimfile = fopen(filename, "r");

	// read data from file
	ifstream input1(filename);
	vector<float> myValues1;

	count_data=0;

	for (float f; input1 >> f; )
	{
		myValues1.push_back(f);
		count_data++;
	}

	//fill in input vector
	for (int i = 0; i<count_data; i++)
	{
		if  (i < BLOCK_IN_LENGTH) {
			block_in[i]=(float)myValues1[i];

			#if FLOAT_FIX_BLOCK_IN == 1
				tmp_value=(int32_t)(block_in[i]*(float)pow(2,(BLOCK_IN_FRACTIONLENGTH)));
				memory_inout[i+byte_block_in_offset/4] = *(uint32_t*)&tmp_value;
			#elif FLOAT_FIX_BLOCK_IN == 0
				memory_inout[i+byte_block_in_offset/4] = (float)block_in[i];
			#endif
		}

	}


	////////////////////////////////////////
	//read x_in_in vector

	// Open stimulus x_in_in.dat file for reading
	sprintf(filename,"x_in_in.dat");
	stimfile = fopen(filename, "r");

	// read data from file
	ifstream input2(filename);
	vector<float> myValues2;

	count_data=0;

	for (float f; input2 >> f; )
	{
		myValues2.push_back(f);
		count_data++;
	}

	//fill in input vector
	for (int i = 0; i<count_data; i++)
	{
		if  (i < X_IN_IN_LENGTH) {
			x_in_in[i]=(float)myValues2[i];

			#if FLOAT_FIX_X_IN_IN == 1
				tmp_value=(int32_t)(x_in_in[i]*(float)pow(2,(X_IN_IN_FRACTIONLENGTH)));
				memory_inout[i+byte_x_in_in_offset/4] = *(uint32_t*)&tmp_value;
			#elif FLOAT_FIX_X_IN_IN == 0
				memory_inout[i+byte_x_in_in_offset/4] = (float)x_in_in[i];
			#endif
		}

	}


	/////////////////////////////////////
	// foo c-simulation
	
	foo(	
				byte_block_in_offset,
				byte_x_in_in_offset,
				byte_y_out_out_offset,
				memory_inout);
	
	
	/////////////////////////////////////
	// read computed y_out_out and store it as y_out_out.dat
	pFile = fopen ("y_out_out.dat","w+");

	for (int i = 0; i < Y_OUT_OUT_LENGTH; i++)
	{

		#if FLOAT_FIX_Y_OUT_OUT == 1
			tmp_value=*(int32_t*)&memory_inout[i+byte_y_out_out_offset/4];
			y_out_out[i]=((float)tmp_value)/(float)pow(2,(Y_OUT_OUT_FRACTIONLENGTH));
		#elif FLOAT_FIX_Y_OUT_OUT == 0
			y_out_out[i]=(float)memory_inout[i+byte_y_out_out_offset/4];
		#endif
		
		fprintf(pFile,"%f \n ",y_out_out[i]);

	}
	fprintf(pFile,"\n");
	fclose (pFile);
		

	return 0;
}
