/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"



void foo	(	
				uint32_t byte_init_in_offset,
				uint32_t byte_sc_in_in_offset,
				uint32_t byte_block_in_offset,
				uint32_t byte_out_block_in_offset,
				uint32_t byte_v_in_in_offset,
				uint32_t byte_v_out_out_offset,
				uint32_t byte_sc_out_out_offset,
				volatile data_t_memory *memory_inout);


using namespace std;
#define BUF_SIZE 64

//Input and Output vectors base addresses in the virtual memory
#define init_IN_DEFINED_MEM_ADDRESS 0
#define sc_in_IN_DEFINED_MEM_ADDRESS (INIT_IN_LENGTH)*4
#define block_IN_DEFINED_MEM_ADDRESS (INIT_IN_LENGTH+SC_IN_IN_LENGTH)*4
#define out_block_IN_DEFINED_MEM_ADDRESS (INIT_IN_LENGTH+SC_IN_IN_LENGTH+BLOCK_IN_LENGTH)*4
#define v_in_IN_DEFINED_MEM_ADDRESS (INIT_IN_LENGTH+SC_IN_IN_LENGTH+BLOCK_IN_LENGTH+OUT_BLOCK_IN_LENGTH)*4
#define v_out_OUT_DEFINED_MEM_ADDRESS (INIT_IN_LENGTH+SC_IN_IN_LENGTH+BLOCK_IN_LENGTH+OUT_BLOCK_IN_LENGTH+V_IN_IN_LENGTH)*4
#define sc_out_OUT_DEFINED_MEM_ADDRESS (INIT_IN_LENGTH+SC_IN_IN_LENGTH+BLOCK_IN_LENGTH+OUT_BLOCK_IN_LENGTH+V_IN_IN_LENGTH+V_OUT_OUT_LENGTH)*4


int main()
{

	char filename[BUF_SIZE]={0};

    int max_iter;

	uint32_t byte_init_in_offset;
	uint32_t byte_sc_in_in_offset;
	uint32_t byte_block_in_offset;
	uint32_t byte_out_block_in_offset;
	uint32_t byte_v_in_in_offset;
	uint32_t byte_v_out_out_offset;
	uint32_t byte_sc_out_out_offset;

	int32_t tmp_value;

	//assign the input/output vectors base address in the DDR memory
	byte_init_in_offset=init_IN_DEFINED_MEM_ADDRESS;
	byte_sc_in_in_offset=sc_in_IN_DEFINED_MEM_ADDRESS;
	byte_block_in_offset=block_IN_DEFINED_MEM_ADDRESS;
	byte_out_block_in_offset=out_block_IN_DEFINED_MEM_ADDRESS;
	byte_v_in_in_offset=v_in_IN_DEFINED_MEM_ADDRESS;
	byte_v_out_out_offset=v_out_OUT_DEFINED_MEM_ADDRESS;
	byte_sc_out_out_offset=sc_out_OUT_DEFINED_MEM_ADDRESS;

	//allocate a memory named address of uint32_t or float words. Number of words is 1024 * (number of inputs and outputs vectors)
	data_t_memory *memory_inout;
	memory_inout = (data_t_memory *)malloc((INIT_IN_LENGTH+SC_IN_IN_LENGTH+BLOCK_IN_LENGTH+OUT_BLOCK_IN_LENGTH+V_IN_IN_LENGTH+V_OUT_OUT_LENGTH+SC_OUT_OUT_LENGTH)*4); //malloc size should be sum of input and output vector lengths * 4 Byte

	FILE *stimfile;
	FILE * pFile;
	int count_data;


	float *init_in;
	init_in = (float *)malloc(INIT_IN_LENGTH*sizeof (float));
	float *sc_in_in;
	sc_in_in = (float *)malloc(SC_IN_IN_LENGTH*sizeof (float));
	float *block_in;
	block_in = (float *)malloc(BLOCK_IN_LENGTH*sizeof (float));
	float *out_block_in;
	out_block_in = (float *)malloc(OUT_BLOCK_IN_LENGTH*sizeof (float));
	float *v_in_in;
	v_in_in = (float *)malloc(V_IN_IN_LENGTH*sizeof (float));
	float *v_out_out;
	v_out_out = (float *)malloc(V_OUT_OUT_LENGTH*sizeof (float));
	float *sc_out_out;
	sc_out_out = (float *)malloc(SC_OUT_OUT_LENGTH*sizeof (float));


	////////////////////////////////////////
	//read init_in vector

	// Open stimulus init_in.dat file for reading
	sprintf(filename,"init_in.dat");
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
		if  (i < INIT_IN_LENGTH) {
			init_in[i]=(float)myValues1[i];

			#if FLOAT_FIX_INIT_IN == 1
				tmp_value=(int32_t)(init_in[i]*(float)pow(2,(INIT_IN_FRACTIONLENGTH)));
				memory_inout[i+byte_init_in_offset/4] = *(uint32_t*)&tmp_value;
			#elif FLOAT_FIX_INIT_IN == 0
				memory_inout[i+byte_init_in_offset/4] = (float)init_in[i];
			#endif
		}

	}


	////////////////////////////////////////
	//read sc_in_in vector

	// Open stimulus sc_in_in.dat file for reading
	sprintf(filename,"sc_in_in.dat");
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
		if  (i < SC_IN_IN_LENGTH) {
			sc_in_in[i]=(float)myValues2[i];

			#if FLOAT_FIX_SC_IN_IN == 1
				tmp_value=(int32_t)(sc_in_in[i]*(float)pow(2,(SC_IN_IN_FRACTIONLENGTH)));
				memory_inout[i+byte_sc_in_in_offset/4] = *(uint32_t*)&tmp_value;
			#elif FLOAT_FIX_SC_IN_IN == 0
				memory_inout[i+byte_sc_in_in_offset/4] = (float)sc_in_in[i];
			#endif
		}

	}


	////////////////////////////////////////
	//read block_in vector

	// Open stimulus block_in.dat file for reading
	sprintf(filename,"block_in.dat");
	stimfile = fopen(filename, "r");

	// read data from file
	ifstream input3(filename);
	vector<float> myValues3;

	count_data=0;

	for (float f; input3 >> f; )
	{
		myValues3.push_back(f);
		count_data++;
	}

	//fill in input vector
	for (int i = 0; i<count_data; i++)
	{
		if  (i < BLOCK_IN_LENGTH) {
			block_in[i]=(float)myValues3[i];

			#if FLOAT_FIX_BLOCK_IN == 1
				tmp_value=(int32_t)(block_in[i]*(float)pow(2,(BLOCK_IN_FRACTIONLENGTH)));
				memory_inout[i+byte_block_in_offset/4] = *(uint32_t*)&tmp_value;
			#elif FLOAT_FIX_BLOCK_IN == 0
				memory_inout[i+byte_block_in_offset/4] = (float)block_in[i];
			#endif
		}

	}


	////////////////////////////////////////
	//read out_block_in vector

	// Open stimulus out_block_in.dat file for reading
	sprintf(filename,"out_block_in.dat");
	stimfile = fopen(filename, "r");

	// read data from file
	ifstream input4(filename);
	vector<float> myValues4;

	count_data=0;

	for (float f; input4 >> f; )
	{
		myValues4.push_back(f);
		count_data++;
	}

	//fill in input vector
	for (int i = 0; i<count_data; i++)
	{
		if  (i < OUT_BLOCK_IN_LENGTH) {
			out_block_in[i]=(float)myValues4[i];

			#if FLOAT_FIX_OUT_BLOCK_IN == 1
				tmp_value=(int32_t)(out_block_in[i]*(float)pow(2,(OUT_BLOCK_IN_FRACTIONLENGTH)));
				memory_inout[i+byte_out_block_in_offset/4] = *(uint32_t*)&tmp_value;
			#elif FLOAT_FIX_OUT_BLOCK_IN == 0
				memory_inout[i+byte_out_block_in_offset/4] = (float)out_block_in[i];
			#endif
		}

	}


	////////////////////////////////////////
	//read v_in_in vector

	// Open stimulus v_in_in.dat file for reading
	sprintf(filename,"v_in_in.dat");
	stimfile = fopen(filename, "r");

	// read data from file
	ifstream input5(filename);
	vector<float> myValues5;

	count_data=0;

	for (float f; input5 >> f; )
	{
		myValues5.push_back(f);
		count_data++;
	}

	//fill in input vector
	for (int i = 0; i<count_data; i++)
	{
		if  (i < V_IN_IN_LENGTH) {
			v_in_in[i]=(float)myValues5[i];

			#if FLOAT_FIX_V_IN_IN == 1
				tmp_value=(int32_t)(v_in_in[i]*(float)pow(2,(V_IN_IN_FRACTIONLENGTH)));
				memory_inout[i+byte_v_in_in_offset/4] = *(uint32_t*)&tmp_value;
			#elif FLOAT_FIX_V_IN_IN == 0
				memory_inout[i+byte_v_in_in_offset/4] = (float)v_in_in[i];
			#endif
		}

	}


	/////////////////////////////////////
	// foo c-simulation
	
	foo(	
				byte_init_in_offset,
				byte_sc_in_in_offset,
				byte_block_in_offset,
				byte_out_block_in_offset,
				byte_v_in_in_offset,
				byte_v_out_out_offset,
				byte_sc_out_out_offset,
				memory_inout);
	
	
	/////////////////////////////////////
	// read computed v_out_out and store it as v_out_out.dat
	pFile = fopen ("v_out_out.dat","w+");

	for (int i = 0; i < V_OUT_OUT_LENGTH; i++)
	{

		#if FLOAT_FIX_V_OUT_OUT == 1
			tmp_value=*(int32_t*)&memory_inout[i+byte_v_out_out_offset/4];
			v_out_out[i]=((float)tmp_value)/(float)pow(2,(V_OUT_OUT_FRACTIONLENGTH));
		#elif FLOAT_FIX_V_OUT_OUT == 0
			v_out_out[i]=(float)memory_inout[i+byte_v_out_out_offset/4];
		#endif
		
		fprintf(pFile,"%f \n ",v_out_out[i]);

	}
	fprintf(pFile,"\n");
	fclose (pFile);
		
	/////////////////////////////////////
	// read computed sc_out_out and store it as sc_out_out.dat
	pFile = fopen ("sc_out_out.dat","w+");

	for (int i = 0; i < SC_OUT_OUT_LENGTH; i++)
	{

		#if FLOAT_FIX_SC_OUT_OUT == 1
			tmp_value=*(int32_t*)&memory_inout[i+byte_sc_out_out_offset/4];
			sc_out_out[i]=((float)tmp_value)/(float)pow(2,(SC_OUT_OUT_FRACTIONLENGTH));
		#elif FLOAT_FIX_SC_OUT_OUT == 0
			sc_out_out[i]=(float)memory_inout[i+byte_sc_out_out_offset/4];
		#endif
		
		fprintf(pFile,"%f \n ",sc_out_out[i]);

	}
	fprintf(pFile,"\n");
	fclose (pFile);
		

	return 0;
}
