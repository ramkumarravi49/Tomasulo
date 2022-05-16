import Parse
import Registers
import Reservation
import Load_store as ls
import call_tb as exe
from constants import *

global reg_file,re_st_Add,re_st_Sub,re_st_Mul,re_st_Fadd,re_st_Fsub,re_st_Fmul,re_st_Load,re_st_Store,re_st_Logic

# Make register file and reservation stations
reg_file = Registers.RegisterFile()
re_st_Add,re_st_Sub,re_st_Mul,re_st_Fadd,re_st_Fsub,re_st_Fmul,re_st_Load,re_st_Store,re_st_Logic = Reservation.make_stations()

global re_st_code

re_st_code =  {
    '000000': re_st_Add,
    '000001': re_st_Sub,
    '000010': re_st_Mul,
    '000011': re_st_Fadd,
    '000100': re_st_Fsub,
    '000101': re_st_Fmul,
    '000110': re_st_Load,
    '000111': re_st_Store,
    '001000': re_st_Logic,
    '001001': re_st_Logic,
    '001010': re_st_Logic,
    '001011': re_st_Logic,
    '001100': re_st_Logic,
    '001101': re_st_Logic,
    '001110': re_st_Logic,
    '001111': re_st_Logic }



def broadcast(tag,res):
    
    for reg in reg_file.file:
        if (reg.valid == False and reg.tag == tag) :
            reg.valid = True
            reg.data = res
            reg.tag = ""
    
    for rst in [re_st_Add,re_st_Sub,re_st_Mul,re_st_Fadd,re_st_Fsub,re_st_Fmul,re_st_Load,re_st_Store,re_st_Logic]:
        for unit in rst.station:
            if (unit.avail == False):
                if (unit.tag1 == tag):
                    unit.valid1 = True
                    unit.src1 = res
                    unit.tag1 = ""

                if (unit.tag2 == tag):
                    unit.valid2 = True
                    unit.src2 = res
                    unit.tag2 = ""

def update_stations():

    for rst in [re_st_Add,re_st_Sub,re_st_Mul,re_st_Fadd,re_st_Fsub,re_st_Fmul,re_st_Load,re_st_Store,re_st_Logic]:
        for unit in rst.station:
            if (unit.delay > 1):
                unit.delay = unit.delay - 1

            if (unit.avail == False and unit.delay == 1):
                res = unit.result
                tag = unit.name
                unit.reset_unit()
                broadcast(tag,res) 



def exec_instr(target_rst,opcode):
    unit_free =  all([(unit.exe == False) for unit in target_rst.station]) # not target_rst.isfull() #

    if (unit_free == True):
        for unit in target_rst.station:
            canexe = all([not unit.avail,not unit.fin,unit.valid1,unit.valid2])
            if (canexe):
                unit.delay = Delay[opcode] #assign delay for instruction execution

                if(opcode == '000110'): # Load
                    unit.result = ls.read_memory(unit.src1)                   

                elif(opcode == '000111'): # Store                    
                    ls.store_memory(unit.src1,unit.src2)
                
                else:                    
                    exe.prepare_tb(opcode,unit.src1,unit.src2)
                    unit.result = exe.get_tb_res(opcode)
                


def main():
    
    Parse.read_code()
    
    instr_queue = []
    Parse.make_instr_queue(instr_queue) #store bin instruction in list in revrsre order to order of execution
    instr_queue.reverse()

       

    while (len(instr_queue) != 0):
        instr = instr_queue.pop()      #popping 1 instr from queue per iteration
        opcode,dest,src1,src2 = Parse.split_instr(instr) 

        target_rst = re_st_code[opcode]

        if (opcode == '000110'): #load LD 
            new_name = target_rst.add_entry(src1,src2)
        
        elif (opcode == '000111'): #store
            val = reg_file.read_register(src1)
            new_name = target_rst.add_entry(val,src2)

        else:
            val1 = reg_file.read_register(src1)
            val2 = reg_file.read_register(src2)
            new_name = target_rst.add_entry(val1,val2)

        if (opcode != '000111'): #store does not have dst
            reg_file.op_reg(dest,new_name)
        


        exec_instr(target_rst,opcode)        
        update_stations()
        reg_file.print_file()

               
    


if __name__ == "__main__":
    main()