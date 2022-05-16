# A Register
class reg:
    def __init__(self, idx):
        self.idx = idx
        self.valid = False
        self.tag = ""           #for regsiter renaming
        self.data = ""          #value stores

# Register File
class RegisterFile:
    def __init__(self):
        self.file = [reg(i) for i in range(32)]

    def update_reg(self,tag,result):
        for reg in RegisterFile:
            if (reg.tag == tag and reg.valid == False):
                reg.valid = True
                reg.data = result
                reg.tag = ""
    
    def write_register(self, addr, value):
        idx = int(addr, 2)
        self.file[idx].valid = True
        self.file[idx].data = value
        self.file[idx].tag = ""

    def read_register(self, addr):
        idx = int(addr, 2)
        if (self.file[idx].valid == True):
            return self.file[idx].data

    def op_reg(self,dest,tag):
        idx = int(dest, 2)
        self.file[idx].valid = False
        self.file[idx].tag = tag


    def print_file(self):
        print("-------------Register File-------------")
        for reg in self.file:
            print([reg.idx, reg.valid, reg.tag,(int(reg.data,2) if reg.data != '' else reg.data)])
        print("---------------------------------------")