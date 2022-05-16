from instructionDecoder import *

# A single Register
class Register:
    def __init__(self, index):
        self.index = index
        self.data = "0"
        self.valid = False
    
# A set of registers
class Registers:
    def __init__(self):
        self.list = [Register(i) for i in range(32)]

    def print_registers(self):
        print("---------------Registers----------------------")
        for i in self.list:
            print("Register", i.index, i.data)
        print("______________________________________________")

    def write_register(self, idx, value):
        self.list[idx].data = str(value)
        self.list[idx].valid = True

    # address is integer
    def read_register(self, idx):
        return self.list[idx].data

def VLIWScheduler(registers):

    instructions = []
    f = open('encodedInstructions.txt','r')

    for line in f.readlines():
        instructions.append(line.strip('\n'))
    f.close()
    print("\nInstructions:")         
    print(instructions)

    intAdder = ["ADD","SUB"]
    intAdder_OPCode = ["000000","000001"]

    intMultiplier = ["MUL"]
    intMultiplier_OPCode = ["000010"]

    floatAdder = ["FADD","FSUB","FMUL"]
    floatAdder_OPCode = ["000011","000100","000101"]

    floatMultiplier = ["FMUL"]
    floatMultiplier_OPCode = ["000101"]

    LogicUnit = ["AND","XOR","NAND","OR","NOT","NOR","NEG","XNOR"]
    LogicUnitOpc = ["001000","001001","001010","001011","001100","001101","001110","001111"]

    Mem = ["LD","ST"]
    MemOpc = ["000110","000111"]

    Units = [intAdder,intMultiplier,floatAdder,floatMultiplier,LogicUnit,Mem]
    UnitsOpc = [intAdder_OPCode,intMultiplier_OPCode,floatAdder_OPCode,floatMultiplier_OPCode,LogicUnitOpc,MemOpc]

    Un = []
    for i in Units:
        Un = Un+i

    UnOp = []
    for i in UnitsOpc:
        UnOp = UnOp+i
    Opc = dict(zip(Un,UnOp))

    def GetUnit(i):
        for j in UnitsOpc:
            if(i in j):
                return(j)

    Delay = {
        "000000": 6,
        "000001": 6,
        "000010": 17,
        "000011": 40,
        "000100": 40,
        "000101": 80,
        "001000": 1,
        "001001": 1,
        "001010": 1,
        "001011": 1,
        "001100": 1,
        "001101": 1,
        "001110": 9,
        "001111": 1,
        "000110": 1,
        "000111": 1
    }

    Opcode = []
    Registers = []

    for instruction in instructions:
        decInst = instruction.split(' ')
        Opcode.append(decInst[0])
        Registers.append(decInst[1:-1])

    print("\nOpcode and Registers: ")
    print(Opcode)
    print(Registers)

    class Node:
        def __init__(self,Reg,ins):
            self.Reg = Reg
            self.Instruction = None
            self.InstructionAsWord = ins
            self.Delay = 0
            self.Parents = []
            self.Children = []
            self.WAWdeps = []
            self.WARdeps = []
            self.exc = False

        def add_child(self,child):
            self.Children.append(child)

        def add_parents(self,parents):
            self.Parents = parents

        def add_WAW(self,deps):
            if(type(deps)==list):
                self.WAWdeps.extend(deps)
                
            else:
                self.WAWdeps.append(deps)
                
        def add_WAR(self,deps):
            if(type(deps)==list):
                self.WARdeps.extend(deps)
            
            else:
                self.WARdeps.append(deps)

        def add_ins(self,ins):
            self.Instruction = ins
            self.Delay = Delay[ins]

        def print_node(self):
            print("Reg Name:",self.Reg)

    BegNodeTable = [Node("R"+str(i),"") for i in range(32)]   
    GlobalNodeTable = list(BegNodeTable)

    for i in range(len(Opcode)):
        rparents = []
        
        for register in Registers[i][1:]:
            rparents.append('R' + str(int(register, 2)))

        rname = 'R' + str(int(Registers[i][0], 2))

        #Create Node and set parents, instruction
        N = Node(rname,instructions[i])
        N.add_ins(Opcode[i])
        N.add_parents(rparents)

        #Update the child for the parents
        for j in rparents:
            GlobalNodeTable[int(j[1:])].add_child(N)

        #Set WAWdeps to previous Node pointing to the register
        N.add_WAW(GlobalNodeTable[int(rname[1:])])

        #Set WARdeps to children of Node pointing to register
        N.add_WAR(GlobalNodeTable[int(rname[1:])].Children)

        #Remove Cyclic WAR dependencies (if source & dest are same reg)
        while(N in N.WARdeps):
            N.WARdeps.remove(N)

        #Swap the new node with the old one
        GlobalNodeTable[int(rname[1:])] = N 

    NextLv = []
    Packet = []
    PacketedIns = []
    while len(BegNodeTable)!=0:
        #degue first element of the node table
        leader = BegNodeTable[0]
        BegNodeTable = BegNodeTable[1:]

        #Check if the unit (ADD/MUL/FPA/FPM/LU/MEM) is free for that clock cycle
        UnitFree = all([not(GetUnit(i.split(' ')[0]) == GetUnit(leader.Instruction)) for i in Packet])

        WAWCleared = all([((i.Delay==0)) for i in leader.WAWdeps])
        WARCleared = all([i.exc for i in leader.WARdeps])

        #if the instruction is executable, set exc and print it
        if(leader.Parents==[] and leader.Instruction!=None and leader.exc==False and WAWCleared and WARCleared and UnitFree):
            leader.exc = True
            # print(leader.InstructionAsWord,"("+str(leader.Delay)+")",end="\t")
            Packet.append(leader.InstructionAsWord)


        #if WAW,WAR is not cleared or Unit is Busy just append the leader as is
        if(leader.Parents == [] and ((not WAWCleared) or (not WARCleared) or (not UnitFree))):
            NextLv.append(leader)

        #if the leader is executable (no parent dependency) and is not a zero delay node decrease delay
        #Then append back to waiting queue
        elif(leader.Parents == [] and leader.Delay!=0):
            leader.Delay = leader.Delay-1
            if(leader.Delay>0):
                NextLv.append(leader)


        #if leader has completed push children
        #and delink leader from the Parent's list of it's children            
        if(leader.Delay==0):
            NextLv.extend(leader.Children)
            for i in leader.Children:
                i.Parents.remove(leader.Reg)

        if(BegNodeTable==[]):
            BegNodeTable = list(set(NextLv))
            NextLv = []
            PacketedIns.append(Packet)
            Packet = []
            # print()
    #First instruction is NOP because of dummy registers
    PacketedIns = PacketedIns[1:]

    #Reorder instruction packet based of funtional unit {Mem|Logic|FPM|FPA|Mul|Add}
    RepackedIns = []
    for i in PacketedIns:
        repack = ["NOP"]*6
        for j in i:
            for k in range(6):
                if(j.split(' ')[0] in UnitsOpc[k]):
                    repack[k] = j
        RepackedIns.append(repack)

    print("\nRepacked Instructions: ")
    for i in RepackedIns:
        print(i,end='\n')
        decodePacket(i,registers)

