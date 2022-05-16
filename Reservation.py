# A single Reservation Station
class Unit:
    def __init__(self, idx):
        self.idx = idx

        self.name = ""     # new name

        self.valid1 = False  # src1 ready
        self.tag1 = ""     # src1 from    
        self.src1 = ""     # src1 value

        self.valid2 = False  # src2 ready
        self.tag2 = ""     # src1 from
        self.src2 = ""     # src2 value
        
        self.result = ""  # answer of computation
        self.delay = 0    # time required to execute
        self.avail = True # unit is free
        self.exe = False  # whether instr is executing
        self.fin = True  # execution complete
    
    def reset_unit(self):
        self.valid1 = False
        self.tag1 = ""      
        self.src1 = ""   

        self.valid2 = False 
        self.tag2 = ""    
        self.src2 = ""  
        
        self.result = "" 
        self.delay = 0   
        self.avail = True 
        self.exe = False  
        self.fin = True 

class reservation_station:
    def __init__(self):
        self.count = 0
        self.op = ""
        self.station = [Unit(i) for i in range(10)]   

    def isfull(self):
        if (self.count == 10):
            return True
        else:
            return False

    def set_names(self,name):
        i = 0
        for unit in self.station:
            unit.name = name  + str(i)
            i = i+1
    
    def add_entry(self,src1,src2):
        if (not self.isfull()):
            for unit in self.station:
                if (unit.avail == True):
                    unit.avail = False
                    unit.fin = False
                    unit.src1 = src1
                    unit.src2 = src2
                    self.count = self.count + 1
                    if (unit.tag1 == ""):
                        unit.valid1 = True
                    if (unit.tag2 == ""):
                        unit.valid2 = True
                    return unit.name
    
    def update_tag(self,tag,value):
        for unit in self.station:

            if (unit.tag1 == tag and unit.valid1 == False):
                unit.valid1 = True
                unit.src1 = value

            if (unit.tag2 == tag and unit.valid2 == False):
                unit.valid2 = True
                unit.src2 = value

    def print_reST(self):
        print("-------------Reservation Station  -------------")
        for rst in self.station:
            if(rst.src1 == "" or rst.src1 == None):
                val1 = rst.src1
            else:
                val1 = int(rst.src1,2)

            if(rst.src2 == "" or rst.src2 == None):
                val2 = rst.src2
            else:
                val2 = int(rst.src2,2)

            if(rst.result == "" or rst.result == None):
                res = rst.result
            else:
                res = int(rst.result,2)

            print(str([rst.avail,rst.name]) +
            "      " + str([rst.valid1, rst.tag1, val1]) +
            "      " + str([rst.valid2,rst.tag2, val2]) +
            "       " + str([res,rst.delay]))
        print("---------------------------------------")
                


def make_stations():
    re_st_Add = reservation_station()
    re_st_Add.set_names("ADD")

    re_st_Sub = reservation_station()
    re_st_Sub.set_names("SUB")

    re_st_Mul = reservation_station()
    re_st_Mul.set_names("MUL")

    re_st_Fadd = reservation_station()
    re_st_Fadd.set_names("FADD")

    re_st_Fsub = reservation_station()
    re_st_Fsub.set_names("FSUB")

    re_st_Fmul = reservation_station()
    re_st_Fmul.set_names("FMUL")

    re_st_Load = reservation_station()
    re_st_Load.set_names("LD")

    re_st_Store = reservation_station()
    re_st_Store.set_names("ST")

    re_st_Logic = reservation_station()
    re_st_Logic.set_names("LOG")

    return re_st_Add,re_st_Sub,re_st_Mul,re_st_Fadd,re_st_Fsub,re_st_Fmul,re_st_Load,re_st_Store,re_st_Logic
