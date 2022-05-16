import pandas as pd

def read_memory(addr):  
    # Read the csv file
    ptr = pd.read_csv('main_memory.csv',header=None,dtype=str)

    idx = int(addr, 2)

    # Load Instruction
    row = ptr.iloc[idx]
    return row[1]

def store_memory(value,addr):  

    # Read the csv file
    ptr = pd.read_csv('main_memory.csv',header=None,dtype=str)

    idx = int(addr, 2)

    # Store Instruction
    ptr.loc[idx,1] = value

    ptr.to_csv('main_memory.csv',header=None,index=False)

# print(read_memory('0000000000000000'))
# store_memory('0000000000000000','0000000000000000000000000000000000000000000000000000000000001111')