import sys
import os
import binascii
from constants import *

def read_code():
    # Read input from assembly code
    file = open("input.txt", "r")

    instr = []          #create a list to store each line from input
    instr_format = []   

    for line in file.readlines():
        
        temp = line.strip('\n')     # Split each instruction and remove escape sequence \n
        if (temp != ""):
            instr.append(temp)      # Store each line of code in instr[]

    for inst in instr:

        operation, registers = inst.split(' ') # Split  ie.LD R5,6H becomes opeartion=['LD']
        operation = operation.upper()          # and register = ['R5,6H']

        # Opcode  Reg Addr
        if operation == 'LD' or operation == 'ST':
            reg, addr = registers.split(',')
            reg = int(reg[1:])                  #if we have Rij the 'ij' is coverted to integr
            reg = '{0:05b}'.format(reg)         #integer is coverted to 5 bit binary as we have 32 registers
            addr = addr[:-1]                    # if address is ijH then address become ij

            addr = int(addr,16)                 # covert to int and fromat to 16 bit bin
            addr = str(format(addr,'0>16b'))

            temp = [opcodes[operation], reg, '00000', addr]
            temp = ' '.join(temp)
            instr_format.append(temp)

        # Opcode Reg_dst Reg_source
        elif operation == 'NEG' or operation == 'NOT':
            dst_reg, src_reg = registers.split(',')

            dst_reg = int(dst_reg[1:])
            dst_reg = '{0:05b}'.format(dst_reg)

            src_reg = int(src_reg[1:])
            src_reg = '{0:05b}'.format(src_reg)

            temp = [opcodes[operation], dst_reg, src_reg, '0000000000000000']
            temp = ' '.join(temp)
            instr_format.append(temp)

        # Opcode Reg_dst Reg_source1 Reg_source2
        else:
            dst_reg, src_r1, src_r2 = registers.split(',')

            dst_reg = int(dst_reg[1:])
            dst_reg = '{0:05b}'.format(dst_reg)

            src_r1 = int(src_r1[1:])
            src_r1 = '{0:05b}'.format(src_r1)

            src_r2 = int(src_r2[1:])
            src_r2 = '{0:05b}'.format(src_r2)

            temp = [opcodes[operation], dst_reg, src_r1, src_r2, '00000000000']
            temp = ' '.join(temp)
            instr_format.append(temp)

    file.close()

    # Write binary format instruction into text file
    with open('binary_format.txt', 'w') as f:
        for inst in instr_format:
            f.write(inst)
            f.write('\n')
            # print(inst)

def make_instr_queue(iQ):
    
    ptr = open("binary_format.txt", "r")

    for line in ptr.readlines():
        instr = line.strip('\n')
        iQ.append(instr)

def split_instr(bin_instr):
    instr = bin_instr.split(' ')

    opcode = instr[0]
    dest = None
    src1 = None
    src2 = None

    if (opcode == '000110'):
        dest = instr[1]
        src1 = instr[3] 
    
    elif (opcode == '000111'):
        src1 = instr[1]
        src2 = instr[3]

    else:
        dest = instr[1]
        src1 = instr[2]

        if (opcode != '001100' and opcode != '001110'): #not and 2's complement
            src2 = instr[3]

    return opcode,dest,src1,src2
