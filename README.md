# Tomasulo Algorithm 🚀

This repository contains an **out-of-order execution simulator** based on the **Tomasulo Algorithm**. The implementation is written in **Python** and simulates instruction execution using reservation stations, register renaming, and instruction reordering.

---

## 📌 Overview

### **What is Tomasulo's Algorithm?**
Tomasulo’s algorithm is used in modern CPUs to enable **out-of-order execution** by dynamically scheduling instructions and improve effciency





---

## 📁 Repository Structure
```bash
📂 Tomasulo
│── 📜 README.md              # This file
│── 🖥️ Tomasulo.py            # Main execution engine
│── 📜 Registers.py           # Register file with renaming support
│── 📜 Reservation.py         # Reservation stations for execution
│── 📜 Load_store.py          # Load/Store unit for memory operations
│── 📜 Parse.py               # Instruction parsing & binary conversion
│── 📜 constants.py           # Opcodes and delays
│── 📜 call_tb.py             # Testbench execution for instructions
│── 📜 gen_memory.py          # Main Memory initialization

